//
//  CoinRowView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI

struct CoinRowView: View {
    let market: Market
    
    var body: some View {
        NavigationLink(destination: {
            let container = AppDependencyContainer.shared
            let coinDetailViewModel = container.makeCoinDetailViewModel(coinId: market.id)
            CoinDetailView(viewModel: coinDetailViewModel)
        }) {
            HStack(spacing: 12) {
                // Coin Icon
                AsyncImage(url: URL(string: market.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Text(String(market.symbol.prefix(1)))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                // Coin Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(market.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(market.symbol)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                // Mini Sparkline
                MiniSparklineView(
                    color: market.priceChangePercentage24h >= 0 ? .green : .red
                )
                .frame(width: 100, height: 30)
                
                Spacer()
                
                // Price and Change
                VStack(alignment: .trailing, spacing: 2) {
                    Text(PriceFormatter.shared.formatPrice(market.currentPrice))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: market.priceChangePercentage24h >= 0 ? "arrow.up" : "arrow.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(market.priceChangePercentage24h >= 0 ? .green : .red)
                        
                        Text(PriceFormatter.shared.formatPercentage(market.priceChangePercentage24h))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(market.priceChangePercentage24h >= 0 ? .green : .red)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleMarket = Market(
        id: "bitcoin",
        symbol: "BTC",
        name: "Bitcoin",
        imageURL: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
        currentPrice: 43250.50,
        priceChange24h: 1250.30,
        priceChangePercentage24h: 11.75,
        marketCap: 850000000000,
        volume24h: 35000000000,
        sparklineData: [100, 120, 105, 140, 135, 160, 155, 180, 175, 200],
        rank: 1
    )
    
    return CoinRowView(market: sampleMarket)
        .background(Color.black)
        .padding()
}
