//
//  FetchMarketChartUseCase.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift

protocol FetchMarketChartUseCaseProtocol {
    func execute(coinId: String, days: Int) -> Single<[ChartPoint]>
}

final class FetchMarketChartUseCase: FetchMarketChartUseCaseProtocol {
    private let marketRepository: MarketRepositoryProtocol
    
    init(marketRepository: MarketRepositoryProtocol) {
        self.marketRepository = marketRepository
    }
    
    func execute(coinId: String, days: Int = 7) -> Single<[ChartPoint]> {
        return marketRepository.getMarketChart(id: coinId, days: days)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
    }
}
