//
//  AppDependencyContainer.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import CoreData
import SwiftUI

/// Simple dependency injection container
final class AppDependencyContainer {
    static let shared = AppDependencyContainer()
    
    // MARK: - Core Data
    lazy var persistenceController = PersistenceController.shared
    
    // MARK: - Data Sources (will be implemented later)
    // lazy var remoteDataSource = RemoteMarketDataSource()
    // lazy var localDataSource = LocalFavoritesDataSource()
    
    // MARK: - Repositories (will be implemented later)
    // lazy var marketRepository = MarketRepository()
    // lazy var favoritesRepository = FavoritesRepository()
    
    // MARK: - Use Cases (will be implemented later)
    // lazy var fetchMarketsUseCase = FetchMarketsUseCase()
    // lazy var fetchCoinDetailUseCase = FetchCoinDetailUseCase()
    // lazy var toggleFavoriteUseCase = ToggleFavoriteUseCase()
    
    private init() {}
}
