//
//  AppDependencyContainer.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import CoreData
import SwiftUI
import RxSwift

/// Simple dependency injection container
final class AppDependencyContainer {
    static let shared = AppDependencyContainer()
    
    // MARK: - Core Data
    lazy var persistenceController = PersistenceController.shared
    
    //MARK: - Networking
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var marketAPI: MarketAPIProtocol = MarketAPI(networkService: networkService)
    
    // MARK: - Repositories (will be implemented later)
    lazy var marketRepository: MarketRepositoryProtocol = MarketRepository(marketAPI: marketAPI)
    lazy var favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository(
        context: persistenceController.container.viewContext
    )
    
    // MARK: - Use Cases (will be implemented later)
    lazy var fetchMarketsUseCase: FetchMarketsUseCaseProtocol = FetchMarketsUseCase(marketRepository: marketRepository)
    lazy var fetchCoinDetailUseCase: FetchCoinDetailUseCaseProtocol = FetchCoinDetailUseCase(marketRepository: marketRepository)
    lazy var fetchMarketChartUseCase: FetchMarketChartUseCaseProtocol = FetchMarketChartUseCase(marketRepository: marketRepository)
    lazy var favoriteToggleUseCase: FavoriteToggleUseCaseProtocol = FavoriteToggleUseCase(
    favoritesRepository: favoritesRepository
)
    
    private init() {}

    // MARK: - ViewModels
    func makeMarketViewModel() -> MarketViewModel {
        return MarketViewModel(fetchMarketsUseCase: fetchMarketsUseCase)
    }
    
    func makeCoinDetailViewModel(coinId: String) -> CoinDetailViewModel {
        return CoinDetailViewModel(
            coinId: coinId,
            fetchCoinDetailUseCase: fetchCoinDetailUseCase,
            fetchMarketChartUseCase: fetchMarketChartUseCase,
            favoriteToggleUseCase: favoriteToggleUseCase,
            favoritesRepository: favoritesRepository
        )
    }
}
