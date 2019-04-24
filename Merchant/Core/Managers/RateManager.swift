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
    
    var defaultRate = StoreRate()
    var defaultCurrency = StoreCurrency()
    
//    var output: Observable<StoreRate> {
//        return rate.asObservable()
//    }
//
//    fileprivate let bag = DisposeBag()
//    fileprivate let realm = try! Realm()
//    fileprivate let rate: BehaviorRelay<StoreRate>
//
//    fileprivate lazy var timer: DispatchSourceTimer = {
//        let t = DispatchSource.makeTimerSource()
//        t.schedule(deadline: .now(), repeating: 10)
//        t.setEventHandler(handler: { [weak self] in
//            self?.fetchRate()
//        })
//        return t
//    }()
    
    struct RateResponse: Codable {
        var code: String
        var name: String
        var rate: Double
    }
    
    init() {
        
        // Load symbols + basic rates
        // Then load the scheduler
        let ratesPath = Bundle.main.path(forResource: "rates", ofType: "json")
        let symbolsPath = Bundle.main.path(forResource: "symbols", ofType: "json")
                
        do {
            let symbolsUrl = URL(fileURLWithPath: symbolsPath!)
            let symbolsData = try Data(contentsOf: symbolsUrl)
            let symbols = try JSONDecoder().decode([String:String].self, from: symbolsData)
            
            let ratesUrl = URL(fileURLWithPath: ratesPath!)
            let ratesData = try Data(contentsOf: ratesUrl)
            let rates = try JSONDecoder().decode([RateResponse].self, from: ratesData)
            
            guard let bchRate = rates.filter({ $0.code == "BCH" }).first else {
                return
            }
            
            var currencies = [String:StoreCurrency]()
            
            rates.forEach { rate in
                let newCurrency = StoreCurrency()
                newCurrency.name = rate.name
                newCurrency.symbol = symbols[rate.code] ?? rate.code
                newCurrency.ticker = rate.code
                currencies[rate.code] = newCurrency
                
                if rate.code == "USD" {
                    self.defaultCurrency = newCurrency
                }
            }
            
            let storeRates = rates.compactMap { rate -> StoreRate? in
                guard rate.code == "BCH"
                    , rate.code == "BCH_BTC"
                    , rate.code == "BCC" else {
                    return nil
                }
                
                let currency = currencies[rate.code]
                
                let newRate = StoreRate()
                newRate.id = "\(rate.code)-0"
                newRate.rate = rate.rate*bchRate.rate
                newRate.currency = currency
                newRate.updatedAt = 0
                
                if rate.code == "USD" {
                    self.defaultRate = newRate
                }
                
                return newRate
            }
            
            let storeCurrencies = currencies.compactMap({ $1 })
            
            let realm = try Realm()
            try realm.write {
                realm.add(storeCurrencies, update: true)
                realm.add(storeRates, update: true)
            }
            
        } catch {
            print("Error loading symbols & default rates", error)
        }
        
        
//        let results = realm.objects(StoreRate.self)
//            .sorted(byKeyPath: "updatedAt")
//        if let rate = results.first {
//            self.rate = BehaviorRelay(value: rate)
//        } else {
//            self.rate = BehaviorRelay(value: StoreRate())
//        }
//        timer.resume()
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
