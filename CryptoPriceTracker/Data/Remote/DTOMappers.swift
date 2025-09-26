//
//  DTOMappers.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation

// MARK: - DTO to Domain Mappers

extension MarketDTO {
    func toDomain() -> Market {
        Market(
            id: id,
            symbol: symbol.uppercased(),
            name: name,
            imageURL: image,
            currentPrice: currentPrice,
            priceChange24h: priceChange24h ?? 0.0,
            priceChangePercentage24h: priceChangePercentage24h ?? 0.0,
            marketCap: marketCap ?? 0.0,
            volume24h: totalVolume ?? 0.0,
            sparklineData: sparklineIn7d?.price ?? [],
            rank: marketCapRank ?? 0
        )
    }
}

extension CoinDetailDTO {
    func toDomain() -> CoinDetail {
        let usdPrice = marketData?.currentPrice?["usd"] ?? 0.0
        let usdPriceChange = marketData?.priceChange24h?["usd"] ?? 0.0
        let usdPriceChangePercentage = marketData?.priceChangePercentage24h?["usd"] ?? 0.0
        let usdMarketCap = marketData?.marketCap?["usd"] ?? 0.0
        let usdVolume = marketData?.totalVolume?["usd"] ?? 0.0
        
        return CoinDetail(
            id: id,
            symbol: symbol.uppercased(),
            name: name,
            imageURL: image?.large,
            currentPrice: usdPrice,
            priceChange24h: usdPriceChange,
            priceChangePercentage24h: usdPriceChangePercentage,
            marketCap: usdMarketCap,
            volume24h: usdVolume,
            marketCapRank: marketData?.marketCapRank ?? 0,
            description: description?.en ?? ""
        )
    }
}

extension ChartDataDTO {
    func toDomain() -> [ChartPoint] {
        return prices.compactMap { priceData in
            guard priceData.count >= 2 else { return nil }
            let timestamp = Date(timeIntervalSince1970: priceData[0] / 1000)
            let price = priceData[1]
            return ChartPoint(timestamp: timestamp, price: price)
        }
    }
}
