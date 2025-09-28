//
//  StatsRowView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI

struct StatsRowView: View {
    let coinDetail: CoinDetail
    
    var body: some View {
        HStack(spacing: 0) {
            // Popularity Rank
            StatPillView(
                title: "POPULARITY",
                value: "#\(coinDetail.marketCapRank)"
            )
            
            // Market Cap
            StatPillView(
                title: "MARKET CAP",
                value: PriceFormatter.shared.formatLargeNumber(coinDetail.marketCap)
            )
            
            // Volume
            StatPillView(
                title: "VOLUME",
                value: PriceFormatter.shared.formatLargeNumber(coinDetail.volume24h)
            )
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatPillView: View {
    let title: String
    let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview {
    let sampleCoinDetail = CoinDetail(
        id: "cardano",
        symbol: "ADA",
        name: "Cardano",
        imageURL: "https://assets.coingecko.com/coins/images/975/large/cardano.png",
        currentPrice: 123.77,
        priceChange24h: 12.85,
        priceChangePercentage24h: 11.75,
        marketCap: 32400000000,
        volume24h: 20600000000,
        marketCapRank: 61,
        description: "Cardano is a blockchain platform for changemakers, innovators, and visionaries."
    )
    
    return StatsRowView(coinDetail: sampleCoinDetail)
        .background(Color.black)
        .padding()
}
