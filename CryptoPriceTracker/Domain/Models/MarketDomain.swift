//
//  MarketDomain.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation

// MARK: - Domain Models (UI-friendly)

struct Market {
    let id: String
    let symbol: String
    let name: String
    let imageURL: String?
    let currentPrice: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let marketCap: Double
    let volume24h: Double
    let sparklineData: [Double]
    let rank: Int
}

struct CoinDetail {
    let id: String
    let symbol: String
    let name: String
    let imageURL: String?
    let currentPrice: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let marketCap: Double
    let volume24h: Double
    let marketCapRank: Int
    let description: String
}

struct ChartPoint {
    let timestamp: Date
    let price: Double
}

// MARK: - Error Types

enum AppError: Error, LocalizedError {
    case network(String)
    case decoding(String)
    case rateLimited
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .network(let message):
            return "Network error: \(message)"
        case .decoding(let message):
            return "Data parsing error: \(message)"
        case .rateLimited:
            return "Too many requests. Please try again later."
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}
