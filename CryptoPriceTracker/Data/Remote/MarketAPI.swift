//
//  MarketAPI.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift

protocol MarketAPIProtocol {
    func getMarkets(page: Int, perPage: Int) -> Single<[MarketDTO]>
    func getCoinDetail(id: String) -> Single<CoinDetailDTO>
    func getMarketChart(id: String, days: Int) -> Single<ChartDataDTO>
}

final class MarketAPI: MarketAPIProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getMarkets(page: Int = 1, perPage: Int = 100) -> Single<[MarketDTO]> {
        let endpoint = APIEndpoint.markets(page: page, perPage: perPage)
        return networkService.request(endpoint)
            .retry { errors in
                return errors.enumerated().flatMap { (index, error) -> Observable<Int> in
                    // Retry only for rate limiting, max 2 retries
                    if case AppError.rateLimited = error, index < 2 {
                        return Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance)
                    }
                    return Observable.error(error)
                }
            }
    }
    
    func getCoinDetail(id: String) -> Single<CoinDetailDTO> {
        let endpoint = APIEndpoint.coinDetail(id: id)
        return networkService.request(endpoint)
            .retry { errors in
                return errors.enumerated().flatMap { (index, error) -> Observable<Int> in
                    if case AppError.rateLimited = error, index < 1 {
                        return Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance)
                    }
                    return Observable.error(error)
                }
            }
    }
    
    func getMarketChart(id: String, days: Int = 7) -> Single<ChartDataDTO> {
        let endpoint = APIEndpoint.marketChart(id: id, days: days)
        return networkService.request(endpoint)
            .retry { errors in
                return errors.enumerated().flatMap { (index, error) -> Observable<Int> in
                    if case AppError.rateLimited = error, index < 1 {
                        return Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance)
                    }
                    return Observable.error(error)
                }
            }
    }
}