//
//  PaymentRequestPresenter.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation
import RxSwift

class PaymentRequestPresenter {
    
    var waitTransactionInteractor: WaitTransactionInteractor?
    var router: PaymentRequestRouter?
    
    weak var viewDelegate: PaymentRequestViewController?
    
    fileprivate let bag = DisposeBag()
    fileprivate var pr: PaymentRequest
    
    init(_ pr: PaymentRequest) {
        self.pr = pr
        print(pr.amountInFiat)
        print(pr.amountInSatoshis)
        print(pr.toAddress)
    }
    
    func viewDidLoad() {
        let data = "\(pr.toAddress)?amount=\(pr.amountInSatoshis.toBCH())"
        viewDelegate?.onSetQRCode(withData: data)
        viewDelegate?.onSetAmount(pr.amountInFiat)
        
        waitTransactionInteractor?
            .waitTransaction(withPr: pr)
            .subscribe(onSuccess: { isSuccess in
                print("success")
                self.viewDelegate?.onSuccess()
            }, onError: { error in
                print("error")
                // Handle error
            })
            .disposed(by: bag)
    }
    
    func didPushClose() {
        router?.transitBackTo()
    }
}
