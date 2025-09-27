//
//  MyPortfolioView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct MyPortfolioView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with title and dropdown
            HStack {
                Text("My Portfolio")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                HStack(spacing: 4) {
                    Text("Monthly")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.teal)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.teal)
                }
            }

            // Portfolio cards
            HStack(spacing: 12) {
                // Bitcoin card
                PortfolioCoinCard(name: "Bitcoin", symbol: "BTC", price: "$6780", change: "+11.75%", isPositive: true, iconColor: .orange)
                // Ethereum card
                PortfolioCoinCard(name: "Ethereum", symbol: "ETH", price: "$1478", change: "+8.23%", isPositive: true, iconColor: .blue)
            }
        }
    }
}



#Preview {
    MyPortfolioView()
}
