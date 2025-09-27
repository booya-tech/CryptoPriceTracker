//
//  PortfolioHeaderView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct PortfolioHeaderView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Profile Avatar
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)

                Spacer()

                // Notification Bell
                Button(action: {}) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
        }

        // Portfolio Balance Section
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Portfolio Balance")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)

                Spacer()

                // Percentage Change Pill
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)

                    Text("10.75%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.15))
                .cornerRadius(16)
            }
            Text("$12550.50")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PortfolioHeaderView()
        .background(Color.black)
        .padding()
}
