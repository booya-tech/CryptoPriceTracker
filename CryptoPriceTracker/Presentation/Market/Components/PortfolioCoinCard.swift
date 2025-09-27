//
//  PortfolioCoinCard.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct PortfolioCoinCard: View {
    let name: String
    let symbol: String
    let price: String
    let change: String
    let isPositive: Bool
    let iconColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with icon and coin info
            HStack {
                // Coin Icon
                Circle()
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: name == "Bitcoin" ? "bitcoinsign" : "diamond")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(symbol)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            // Mini Chart
            MiniSparklineView(color: iconColor)
                .frame(height: 40)

            // Price and change
            HStack {
                Text(price)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isPositive ? .green : .red)

                    Text(change)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isPositive ? .green : .red)
                }
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PortfolioCoinCard(name: "Bitcoin", symbol: "BTC", price: "$10000", change: "+10%", isPositive: true, iconColor: .orange)
}
