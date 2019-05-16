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
    var currencyToCountryLocales : [String:[CountryLocales]]? = nil
    
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

    struct CountryLocales: Codable {
        var country: String
        var locales: String
    }
    
    fileprivate func createCurrencies(_ rates: [RateManager.RateResponse], _ symbols: [String : String]) -> [String:StoreCurrency] {
        var currencies = [String:StoreCurrency]()
        rates.forEach { rate in
            let newCurrency = StoreCurrency()
            newCurrency.name = rate.name
            newCurrency.symbol = symbols[rate.code] ?? rate.code
            newCurrency.ticker = rate.code
            if !rate.name.lowercased().contains("coin") {
                currencies[rate.code] = newCurrency
            }
            if rate.code == "USD" {
                self.defaultCurrency = newCurrency
            }
        }
        return currencies
    }
    
    fileprivate func createRates(_ rates: [RateManager.RateResponse], _ bchRate: RateManager.RateResponse) -> [StoreRate] {
        return rates.compactMap { rate -> StoreRate? in
            guard !rate.name.lowercased().contains("coin") else {
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
    }

    init() {
        
        // Load symbols + basic rates + locales
        // Then load the scheduler
        let ratesPath = Bundle.main.path(forResource: "rates", ofType: "json")
        let symbolsPath = Bundle.main.path(forResource: "symbols", ofType: "json")
        let localesPath = Bundle.main.path(forResource: "currency_to_locales", ofType: "json")

        do {
            let symbolsUrl = URL(fileURLWithPath: symbolsPath!)
            let symbolsData = try Data(contentsOf: symbolsUrl)
            let symbols = try JSONDecoder().decode([String:String].self, from: symbolsData)
            
            let ratesUrl = URL(fileURLWithPath: ratesPath!)
            let ratesData = try Data(contentsOf: ratesUrl)
            let rates = try JSONDecoder().decode([RateResponse].self, from: ratesData)
            
            let localesUrl = URL(fileURLWithPath: localesPath!)
            let localesData = try Data(contentsOf: localesUrl)
            currencyToCountryLocales = try JSONDecoder().decode([String:[CountryLocales]].self, from: localesData)

            guard let bchRate = rates.filter({ $0.code == "BCH" }).first else {
                return
            }
            
            let currencies = createCurrencies(rates, symbols)
            let storeRates = createRates(rates, bchRate)
            let storeCurrencies = currencies.compactMap({ $1 })
            
            let realm = try Realm()
            try realm.write {
                realm.add(storeCurrencies, update: true)
                realm.add(storeRates, update: true)
            }
            
        } catch {
            print("Error loading symbols & default rates", error)
        }
        
        timer.resume()
    }
    
    func fetchRate() {
        let provider = MoyaProvider<RateNetwork>()
        provider.rx
            .request(.get())
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map([RateResponse].self)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: { [weak self] response in
                self?.storeData(withRates: response)
            })
            .disposed(by: bag)
    }
    
    func storeData(withRates rates: [RateResponse]) {
        do {
            guard let bchRate = rates.filter({ $0.code == "BCH" }).first else {
                return
            }
            
            let storeRates = createRates(rates, bchRate)

            let realm = try Realm()
            try realm.write {
                realm.add(storeRates, update: true)
            }
            
        } catch {
            print("Error loading symbols & default rates", error)
        }
    }
}
