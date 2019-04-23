//
//  RateManager.swift
//  Merchant
//
//  Copyright © 2019 Jean-Baptiste Dominguez
//  Copyright © 2019 Bitcoin.com developers
//

import RxSwift
import RxCocoa
import RealmSwift
import Moya

class RateManager {
    
    // Singleton
    static let shared = RateManager()
    
    var output: Observable<StoreRate> {
        return rate.asObservable()
    }
    
    fileprivate let bag = DisposeBag()
    fileprivate let realm = try! Realm()
    fileprivate let rate: BehaviorRelay<StoreRate>
    
    fileprivate lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now(), repeating: 10)
        t.setEventHandler(handler: { [weak self] in
            self?.fetchRate()
        })
        return t
    }()
    
    init() {
        
        struct RateResponse: Codable {
            var code: String
            var name: String
            var rate: String
        }
        
        // Load symbols + basic rates
        // Then load the scheduler
        let path = Bundle.main.path(forResource: "rates", ofType: "json")
        
        do {
            let url = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            let rates = try JSONDecoder().decode([RateResponse].self, from: data)
            
            print(rates)
            
        } catch {
            
        }
        
        
        let results = realm.objects(StoreRate.self)
            .sorted(byKeyPath: "updatedAt")
        if let rate = results.first {
            self.rate = BehaviorRelay(value: rate)
        } else {
            self.rate = BehaviorRelay(value: StoreRate())
        }
        timer.resume()
    }
    
    func fetchRate() {
//        let provider = MoyaProvider<RateNetwork>()
//        provider.rx
//            .request(.get("BCH"))
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .retry(3)
//            .filterSuccessfulStatusCodes()
//            .map(ResponseRate.self)
//            .observeOn(MainScheduler.asyncInstance)
//            .subscribe(onSuccess: { response in
//                let updateAt = Int(Date().timeIntervalSince1970)
//
//                let rate = StoreRate()
//                rate.eur = response.eur
//                rate.usd = response.usd
//                rate.updatedAt = updateAt
//                do {
//                    try self.realm.write {
//                        self.realm.add(rate)
//                    }
//                } catch {
//                    print(error)
//                }
//
//                self.rate.accept(rate)
//            })
//            .disposed(by: bag)
    }
}
