//
//  FetchCoinDetailUseCase.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift

protocol FetchCoinDetailUseCaseProtocol {
    func execute(coinId: String) -> Single<CoinDetail>
}

final class FetchCoinDetailUseCase: FetchCoinDetailUseCaseProtocol {
    private let marketRepository: MarketRepositoryProtocol
    
    init(marketRepository: MarketRepositoryProtocol) {
        self.marketRepository = marketRepository
    }
    
    func execute(coinId: String) -> Single<CoinDetail> {
        return marketRepository.getCoinDetail(id: coinId)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
    }
}
