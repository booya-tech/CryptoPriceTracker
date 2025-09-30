//
//  Persistence.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/24/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Sample crypto favorites for preview
        let sampleCoins = [
            ("bitcoin", "Bitcoin", "BTC", 1),
            ("ethereum", "Ethereum", "ETH", 2),
            ("binancecoin", "BNB", "BNB", 4),
            ("solana", "Solana", "SOL", 5),
            ("cardano", "Cardano", "ADA", 8),
        ]

        for (id, name, symbol, rank) in sampleCoins {
            let favoriteCoin = FavoriteCoin(context: viewContext)
            favoriteCoin.id = id
            favoriteCoin.name = name
            favoriteCoin.symbol = symbol
            favoriteCoin.rank = Int16(rank)
            favoriteCoin.addedAt = Date().addingTimeInterval(-Double.random(in: 0...604800))  // Random within last week
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CryptoPriceTracker")
        if inMemory {
            // /dev/null -> throw away the data
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // Prevents data conflicts when multiple contexts modify the same data
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - CoreData Debugging Extension
extension PersistenceController {
    /// Debug function to print all favorites in CoreData
    func debugPrintFavorites() {
        let context = container.viewContext
        let request: NSFetchRequest<FavoriteCoin> = FavoriteCoin.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
        
        do {
            let favorites = try context.fetch(request)
            print("📊 COREDATA DEBUG - Total Favorites: \(favorites.count)")
            print("================================")
            
            if favorites.isEmpty {
                print("❌ No favorites found in database")
            } else {
                for (index, favorite) in favorites.enumerated() {
                    print("🔹 Favorite \(index + 1):")
                    print("   ID: \(favorite.id ?? "nil")")
                    print("   Name: \(favorite.name ?? "nil")")
                    print("   Symbol: \(favorite.symbol ?? "nil")")
                    print("   Rank: \(favorite.rank)")
                    print("   Added: \(favorite.addedAt ?? Date())")
                    print("   ----------------")
                }
            }
            print("================================")
        } catch {
            print("❌ CoreData Debug Error: \(error)")
        }
    }
    
    /// Debug function to check database file location
    func debugPrintDatabaseLocation() {
        guard let storeURL = container.persistentStoreDescriptions.first?.url else {
            print("❌ Could not find database URL")
            return
        }
        print("📍 CoreData Database Location:")
        print("   \(storeURL.path)")
        print("   File exists: \(FileManager.default.fileExists(atPath: storeURL.path))")
    }
}
