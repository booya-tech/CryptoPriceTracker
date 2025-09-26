//
//  FetchMarketsUseCase.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift

protocol FetchMarketsUseCaseProtocol {
    func execute(page: Int, perPage: Int) -> Single<[Market]>
}

final class FetchMarketsUseCase: FetchMarketsUseCaseProtocol {
    private let marketRepository: MarketRepositoryProtocol
    
    init(marketRepository: MarketRepositoryProtocol) {
        self.marketRepository = marketRepository
    }
    
    func execute(page: Int = 1, perPage: Int = 100) -> Single<[Market]> {
        return marketRepository.getMarkets(page: page, perPage: perPage)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
    }
}
