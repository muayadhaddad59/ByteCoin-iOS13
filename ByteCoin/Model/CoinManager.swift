//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinProtocol {
    func didFetchData(coin: CoinModel)
    func didFailData(error: Error)
}
struct CoinManager {

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "231AA186-BCDB-4ED1-92DB-3EF4442D1059"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    var delegate: CoinProtocol?
    func getCoinManager(currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        handleData(urlString)
    }
    func handleData(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, respone, error in
                if let safedata = data {
                    if let coin = parseJson(data: safedata) {
                        delegate?.didFetchData(coin: coin)
                    }

                }

            }
            task.resume()
        }
    }

    func parseJson(data: Data) -> CoinModel? {
        let decode = JSONDecoder()
        do {
            let coinRate = try decode.decode(CoinModel.self, from: data)
            let rate = coinRate.rate
            let coin = CoinModel(rate: rate , asset_id_quote: coinRate.asset_id_quote)
            return coin
        } catch {
            delegate?.didFailData(error: error)
            return nil
        }
    }
}
