//
//  CryptoPriceTrackerApp.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/24/25.
//

import SwiftUI
import CoreData

@main
struct CryptoPriceTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
