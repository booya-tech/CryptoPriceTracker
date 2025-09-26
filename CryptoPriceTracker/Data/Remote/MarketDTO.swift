//
//  MarketDTO.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation

// MARK: - API Response DTOs

struct MarketDTO: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String?
    let currentPrice: Double
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
    let marketCap: Double?
    let totalVolume: Double?
    let sparklineIn7d: SparklineDTO?
    let marketCapRank: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case sparklineIn7d = "sparkline_in_7d"
        case marketCapRank = "market_cap_rank"
    }
}

struct SparklineDTO: Codable {
    let price: [Double]
}

struct CoinDetailDTO: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: ImageDTO?
    let marketData: MarketDataDTO?
    let description: DescriptionDTO?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image, description
        case marketData = "market_data"
    }
}

struct ImageDTO: Codable {
    let large: String?
}

struct MarketDataDTO: Codable {
    let currentPrice: [String: Double]?
    let priceChange24h: [String: Double]?
    let priceChangePercentage24h: [String: Double]?
    let marketCap: [String: Double]?
    let totalVolume: [String: Double]?
    let marketCapRank: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case marketCapRank = "market_cap_rank"
    }
}

struct DescriptionDTO: Codable {
    let en: String?
}

struct ChartDataDTO: Codable {
    let prices: [[Double]]
}
