//
//  MarketRepository.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift

protocol MarketRepositoryProtocol {
    func getMarkets(page: Int, perPage: Int) -> Single<[Market]>
    func getCoinDetail(id: String) -> Single<CoinDetail>
    func getMarketChart(id: String, days: Int) -> Single<[ChartPoint]>
}

final class MarketRepository: MarketRepositoryProtocol {
    private let marketAPI: MarketAPIProtocol
    
    init(marketAPI: MarketAPIProtocol) {
        self.marketAPI = marketAPI
    }
    
    func getMarkets(page: Int = 1, perPage: Int = 100) -> Single<[Market]> {
        return marketAPI.getMarkets(page: page, perPage: perPage)
            .map { marketDTOs in
                return marketDTOs.map { $0.toDomain() }
            }
            .observe(on: MainScheduler.instance)
    }
    
    func getCoinDetail(id: String) -> Single<CoinDetail> {
        return marketAPI.getCoinDetail(id: id)
            .map { $0.toDomain() }
            .observe(on: MainScheduler.instance)
    }
    
    func getMarketChart(id: String, days: Int = 7) -> Single<[ChartPoint]> {
        return marketAPI.getMarketChart(id: id, days: days)
            .map { $0.toDomain() }
            .observe(on: MainScheduler.instance)
    }
}
