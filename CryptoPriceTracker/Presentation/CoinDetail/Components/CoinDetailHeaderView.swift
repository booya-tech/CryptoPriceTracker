//
//  CoinDetailHeaderView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI

struct CoinDetailHeaderView: View {
    let coinDetail: CoinDetail?
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // Coin information
            if let coin = coinDetail {
                HStack(spacing: 16) {
                    // Coin icon
                    AsyncImage(url: URL(string: coin.imageURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Circle()
                            .fill(Color.blue)
                            .overlay(
                                Text(String(coin.symbol.prefix(1)))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Coin name and symbol
                        HStack {
                            Text(coin.name)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("/ \(coin.symbol)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        // Price
                        Text(PriceFormatter.shared.formatPrice(coin.currentPrice))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Percentage change pill
                    HStack(spacing: 4) {
                        Image(systemName: coin.priceChangePercentage24h >= 0 ? "arrow.up" : "arrow.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(PriceFormatter.shared.formatPercentage(coin.priceChangePercentage24h))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(coin.priceChangePercentage24h >= 0 ? Color.green : Color.red)
                    .cornerRadius(16)
                }
            } else {
                // Loading skeleton
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 24)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 32)
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                }
            }
            
            // Separator line
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.top, 10)
        }
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
    
    return CoinDetailHeaderView(
        coinDetail: sampleCoinDetail,
        isFavorite: false,
        onFavoriteToggle: {}
    )
    .background(Color.black)
    .padding()
}
