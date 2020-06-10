//
//  ScannerViewController.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/24/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import AVKit

protocol ScannerViewControllerDelegate: class {
    func scannerViewController(_ viewController: ScannerViewController, didScanStringValue stringValue: String)
}

final class ScannerViewController: UIViewController {

    // MARK: - Properties
    private var navigationBar = NavigationBar()
    private var cameraView = UIView()
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var hasPermission = false
    weak var delegate: ScannerViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localize()
        checkPermissions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Private API
    private func setupView() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupCameraView()
    }
    
    private func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: NavigationBar.height)
        ])
    }
    
    private func setupCameraView() {
        cameraView.backgroundColor = .white
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cameraView.widthAnchor.constraint(equalToConstant: Constants.CAMERA_VIEW_SIZE),
            cameraView.heightAnchor.constraint(equalToConstant: Constants.CAMERA_VIEW_SIZE)
        ])
    }
    
    private func localize() {
        navigationBar.text = Localized.scanner
    }
    
    private func checkPermissions() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] success in
            guard let self = self else { return }
            
            if success {
                self.hasPermission = true
                self.setupCamera()
                return
            }
        }
    }
    
    private func setupCamera() {
        guard hasPermission else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession = AVCaptureSession()
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                Logger.log(message: "Video capture device not available.", type: .error)
                return
            }
            
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                Logger.log(message: "Video input not available \(error.localizedDescription)", type: .error)
                return
            }
            
            if (self.captureSession.canAddInput(videoInput)) {
                self.captureSession.addInput(videoInput)
            } else {
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.captureSession.canAddOutput(metadataOutput)) {
                self.captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                return
            }
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = self.cameraView.layer.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            self.cameraView.layer.addSublayer(self.previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.scannerViewController(self, didScanStringValue: stringValue)
        }
    }
    
}

private struct Localized {
    static var scanner: String { NSLocalizedString("scan", comment: "") }
    static var grantCameraPermission: String { NSLocalizedString("grant_camera_permission", comment: "") }
}

private struct Constants {
    static let CAMERA_VIEW_SIZE: CGFloat = UIScreen.main.bounds.size.width - 100.0
}
