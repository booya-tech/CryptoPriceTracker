//
//  FavoritesTestView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/30/25.
//

import SwiftUI
import CoreData

struct FavoritesTestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteCoin.addedAt, ascending: false)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteCoin>
    
    var body: some View {
        List(favorites, id: \.id) { coin in
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(coin.name ?? "Unknown")
                        Text(coin.symbol ?? "").foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("rank \(coin.rank)")
                        Text(coin.id ?? "").foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Favorites (\(favorites.count))")
    }
}

#Preview {
    FavoritesTestView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
