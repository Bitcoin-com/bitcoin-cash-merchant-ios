//
//  PaymentRequestPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import RxSwift

protocol PaymentRequestPresenterDelegate {
    func cleanupInputField()
}

class PaymentRequestPresenter {
    
    var waitTransactionInteractor: WaitTransactionInteractor?
    var requestDelegate: PaymentRequestPresenterDelegate?
    var router: PaymentRequestRouter?
    
    weak var viewDelegate: PaymentRequestViewController?
    
    fileprivate let bag = DisposeBag()
    fileprivate var pr: PaymentRequest
    fileprivate var txDisp: Disposable?
    
    init(_ pr: PaymentRequest) {
        self.pr = pr
    }
    
    func viewDidLoad() {
        let data = "\(pr.toAddress)?amount=\(pr.amountInSatoshis.toBCH())"
        viewDelegate?.onSetQRCode(withData: data)
        viewDelegate?.onSetAmount(pr.amountInFiat, bchAmount: pr.amountInSatoshis.toBCHFormat())
        
        txDisp = waitTransactionInteractor?
            .waitTransaction(withPr: pr)
            .subscribe(onSuccess: { isSuccess in
                self.viewDelegate?.onSuccess()
                self.requestDelegate?.cleanupInputField()
            }, onError: { error in
                // Handle error
            })
        txDisp?.disposed(by: bag)
    }
    
    func viewDidDisappear() {
        txDisp?.dispose()
    }
    
    func didPushClose() {
        router?.transitBackTo()
    }
    
    func showAmountMismatched(receivedAmount: Int64, expectedAmount: Int64) {
        router?.openPopup(receivedAmount: receivedAmount, expectedAmount: expectedAmount)
    }
}
