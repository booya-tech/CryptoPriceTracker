//
//  FavoriteToggleUseCase.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/28/25.
//

import Foundation
import RxSwift

protocol FavoriteToggleUseCaseProtocol {
    /// Toggles favorite status for a coin using its detail information
    func execute(coinDetail: CoinDetail) -> Completable
}

final class FavoriteToggleUseCase: FavoriteToggleUseCaseProtocol {
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }
    
    /// Toggles favorite status for a coin using its detail information
    func execute(coinDetail: CoinDetail) -> Completable {
        return favoritesRepository.toggleFavorite(
            id: coinDetail.id,
            name: coinDetail.name,
            symbol: coinDetail.symbol,
            rank: coinDetail.marketCapRank
        )
    }
}
