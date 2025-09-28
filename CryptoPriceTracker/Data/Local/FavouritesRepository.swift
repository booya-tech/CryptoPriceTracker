//
//  FavoritesRepository.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/28/25.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol FavoritesRepositoryProtocol {
    /// Returns a reactive stream of favorite coin IDs for instant UI updates
    func favoriteIds() -> Observable<Set<String>>
    
    /// Toggles favorite status - adds if not favorite, removes if already favorite
    func toggleFavorite(id: String, name: String, symbol: String, rank: Int?) -> Completable
    
    /// Checks if a specific coin is currently marked as favorite
    func isFavorite(coinId: String) -> Single<Bool>
    
    /// Retrieves all favorite coins sorted by most recently added
    func getFavorites() -> Single<[FavoriteCoin]>
}

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let context: NSManagedObjectContext
    private let favoriteIdsSubject = BehaviorSubject<Set<String>>(value: Set())
    
    /// Initializes repository with CoreData context and loads existing favorites
    init(context: NSManagedObjectContext) {
        self.context = context
        loadInitialFavorites()
    }
    
    /// Returns a reactive stream of favorite coin IDs for instant UI updates
    func favoriteIds() -> Observable<Set<String>> {
        return favoriteIdsSubject.asObservable()
    }
    
    /// Toggles favorite status - adds if not favorite, removes if already favorite
    func toggleFavorite(id: String, name: String, symbol: String, rank: Int?) -> Completable {
        return Completable.create { [weak self] observer in
            guard let self = self else {
                observer(.error(AppError.unknown("FavoritesRepository deallocated")))
                return Disposables.create()
            }
            
            do {
                let wasAlreadyFavorite = try self.existsFavorite(id: id)
                
                if wasAlreadyFavorite {
                    try self.removeFavorite(id: id)
                    print("💔 FAVORITE REMOVED: \(name) (\(id))")
                } else {
                    try self.addFavorite(id: id, name: name, symbol: symbol, rank: rank)
                    print("❤️ FAVORITE ADDED: \(name) (\(id))")
                }
                
                try self.context.save()
                print("💾 CoreData saved successfully")
                
                self.updateFavoriteIds()
                
                // Debug: Print database contents after toggle
                PersistenceController.shared.debugPrintFavorites()
                
                observer(.completed)
            } catch {
                print("❌ FAVORITE TOGGLE ERROR: \(error)")
                observer(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .observe(on: MainScheduler.instance)
    }
    
    /// Checks if a specific coin is currently marked as favorite
    func isFavorite(coinId: String) -> Single<Bool> {
        return Single.create { [weak self] observer in
            guard let self = self else {
                observer(.failure(AppError.unknown("FavoritesRepository deallocated")))
                return Disposables.create()
            }
            
            do {
                let exists = try self.existsFavorite(id: coinId)
                observer(.success(exists))
            } catch {
                observer(.failure(error))
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .observe(on: MainScheduler.instance)
    }
    
    /// Retrieves all favorite coins sorted by most recently added
    func getFavorites() -> Single<[FavoriteCoin]> {
        return Single.create { [weak self] observer in
            guard let self = self else {
                observer(.failure(AppError.unknown("FavoritesRepository deallocated")))
                return Disposables.create()
            }
            
            do {
                let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
                
                let favorites = try self.context.fetch(request)
                observer(.success(favorites))
            } catch {
                observer(.failure(error))
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .observe(on: MainScheduler.instance)
    }
    
    // MARK: - Private Methods
    /// Loads existing favorites from CoreData on initialization
    private func loadInitialFavorites() {
        do {
            let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
            let favorites = try context.fetch(request)
            let ids = Set(favorites.map { $0.id ?? "" })
            favoriteIdsSubject.onNext(ids)
        } catch {
            print("Failed to load initial favorites: \(error)")
            favoriteIdsSubject.onNext(Set())
        }
    }
    
    /// Updates the reactive stream with current favorite IDs after changes
    private func updateFavoriteIds() {
        do {
            let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
            let favorites = try context.fetch(request)
            let ids = Set(favorites.map { $0.id ?? "" })
            favoriteIdsSubject.onNext(ids)
        } catch {
            print("Failed to update favorite IDs: \(error)")
        }
    }
    
    /// Checks if a favorite with the given ID exists in CoreData
    private func existsFavorite(id: String) throws -> Bool {
        let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        let count = try context.count(for: request)
        return count > 0
    }
    
    /// Creates and saves a new favorite coin to CoreData
    private func addFavorite(id: String, name: String, symbol: String, rank: Int?) throws {
        let favorite = FavoriteCoin(context: context)
        favorite.id = id
        favorite.name = name
        favorite.symbol = symbol
        favorite.addedAt = Date()
        favorite.rank = Int16(rank ?? 0)
    }
    
    /// Finds and deletes favorite coin from CoreData by ID
    private func removeFavorite(id: String) throws {
        let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        let favorites = try context.fetch(request)
        for favorite in favorites {
            context.delete(favorite)
        }
    }
}
