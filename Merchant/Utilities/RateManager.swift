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
    static let shared = RateManager()
    
    var defaultRate = StoreRate()
    var defaultCurrency = StoreCurrency()
    var lastUpdate = 0.0
    
    fileprivate let bag = DisposeBag()
    fileprivate lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now(), repeating: 30)
        t.setEventHandler(handler: { [weak self] in
            self?.fetchRate()
        })
        return t
    }()
    
    struct RateResponse: Codable {
        var code: String
        var name: String
        var rate: Double
    }
    
    private init() {
        
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
                guard rate.code != "BCH"
                    , rate.code != "BCH_BTC"
                    , rate.code != "BCC" else {
                    return nil
                }
                
                let newRate = StoreRate()
                newRate.id = rate.code
                newRate.rate = rate.rate*bchRate.rate
                newRate.updatedAt = 0
                
                if rate.code == "USD" {
                    self.defaultRate = newRate
                }
                
                return newRate
            }
            
            let storeCurrencies = currencies.compactMap({ $1 })
            
            let realm = try Realm()
            try realm.write {
                realm.add(storeCurrencies, update: .all)
                realm.add(storeRates, update: .all)
            }
            
        } catch {
            print("Error loading symbols & default rates", error)
        }
        
        timer.resume()
    }
    
    func fetchRate() {
        let provider = MoyaProvider<RateNetwork>()
        provider.rx
            .request(.get)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map([RateResponse].self)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: { [weak self] response in
                self?.storeData(withRates: response)
                self?.lastUpdate = NSDate().timeIntervalSince1970
            })
            .disposed(by: bag)
    }
    
    func isSeverelyOutdated() -> Bool {
        let now = NSDate().timeIntervalSince1970
        let timeSince = now - self.lastUpdate
        return timeSince >= (1 * 60)
    }
    
    func storeData(withRates rates: [RateResponse]) {
        do {
            guard let btcUsdRate = rates.filter({ $0.code == "USD" }).first else {
                return
            }
            guard let bchRate = rates.filter({ $0.code == "BCH" }).first else {
                return
            }
            let bchUsdRate = btcUsdRate.rate/bchRate.rate
            let bchBtcRate = bchUsdRate/btcUsdRate.rate
            
            let storeRates = rates.compactMap { rate -> StoreRate? in
                guard rate.code != "BCH"
                    , rate.code != "BCH_BTC"
                    , rate.code != "BCC" else {
                        return nil
                }
                
                let newRate = StoreRate()
                newRate.id = rate.code
                newRate.rate = rate.rate*bchBtcRate
                newRate.updatedAt = 0
                if rate.code == "USD" {
                    self.defaultRate = newRate
                }
                
                return newRate
            }
            
            let realm = try Realm()
            try realm.write {
                realm.add(storeRates, update: .all)
            }
            
        } catch {
            print("Error loading symbols & default rates", error)
        }
    }
}
