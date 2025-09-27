//
//  TimePeriod.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import Foundation

// MARK: - Time Period Enum
enum TimePeriod: String, CaseIterable {
    case oneHour = "1H"
    case oneDay = "1D"
    case oneWeek = "1W"
    case oneMonth = "1M"
    case oneYear = "1Y"
    case all = "All"
    
    var days: Int {
        switch self {
        case .oneHour: return 1
        case .oneDay: return 1
        case .oneWeek: return 7
        case .oneMonth: return 30
        case .oneYear: return 365
        case .all: return 365 // Max supported by CoinGecko
        }
    }
}
