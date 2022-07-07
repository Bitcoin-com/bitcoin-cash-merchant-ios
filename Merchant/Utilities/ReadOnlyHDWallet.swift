// Copyright (c) 2019 Horizontal Systems <hsdao@protonmail.ch>
// Derived from https://github.com/horizontalsystems/hd-wallet-kit-ios/blob/master/HdWalletKit/Classes/ReadOnlyHDWallet.swift
// Copyright (c) 2022 Software Verde, LLC <value@softwareverde.com>

import OpenSslKit
import BitcoinKit

public class ReadOnlyHDWallet {

    enum ParseError: Error {
        case InvalidExtendedPublicKey
        case InvalidChecksum
    }

    private static func dataTo<T>(data: Data, type: T.Type) -> T {
        data.withUnsafeBytes { $0.load(as: T.self) }
    }

    private static func publicKeys(raw: Data, chainCode: Data, xPubKey: UInt32, depth: UInt8, fingerprint: UInt32, childIndex: UInt32, indices: Range<UInt32>, chain: HDWallet.Chain) throws -> [PublicKey] {
        guard let firstIndex = indices.first, let lastIndex = indices.last else {
            return []
        }

        if (0x80000000 & firstIndex) != 0 && (0x80000000 & lastIndex) != 0 {
            throw DerivationError.derivationFailed
        }

        var hdKey = HDKey(privateKey: nil, publicKey: raw, chainCode: chainCode, depth: depth, fingerprint: fingerprint, childIndex: childIndex)

        guard let derivedHdKey = Kit.derivedHDKey(hdKey: hdKey, at: UInt32(chain.rawValue), hardened: false), let publicKey = derivedHdKey.publicKey else {
            throw DerivationError.derivationFailed
        }

        hdKey = HDKey(privateKey: nil, publicKey: publicKey, chainCode: derivedHdKey.chainCode, depth: derivedHdKey.depth, fingerprint: derivedHdKey.fingerprint, childIndex: derivedHdKey.childIndex)

        var keys = [PublicKey]()

        for i in indices {
            guard let key = Kit.derivedHDKey(hdKey: hdKey, at: i, hardened: false), let publicKey = key.publicKey else {
                throw DerivationError.derivationFailed
            }

            keys.append(PublicKey(bytes: publicKey, network: .mainnetBCH))
        }

        return keys
    }

    public static func publicKeys(extendedPublicKey: String, indices: Range<UInt32>, chain: HDWallet.Chain) throws -> [PublicKey] {
        let data = OpenSslKit.Base58.decode(extendedPublicKey)

        guard data.count == 82 else {
            throw ParseError.InvalidExtendedPublicKey
        }

        let xPubKey = dataTo(data: Data(data[0..<4].reversed()), type: UInt32.self)
        let depth = dataTo(data: Data(data[4..<5]), type: UInt8.self)
        let fingerprint = dataTo(data: Data(data[5..<9]), type: UInt32.self)
        let childIndex = dataTo(data: Data(data[9..<13]), type: UInt32.self)
        let chainCode = Data(data[13..<45])
        let key = Data(data[45..<78])
        let checksum = Data(data[78..<82])

        guard checksum == Kit.sha256sha256(data.prefix(78)).prefix(4) else {
            throw ParseError.InvalidChecksum
        }

        return try Self.publicKeys(raw: key, chainCode: chainCode, xPubKey: xPubKey, depth: depth, fingerprint: fingerprint, childIndex: childIndex, indices: indices, chain: chain)
    }
}
