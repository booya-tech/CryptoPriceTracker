//
//  MarketViewState.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation

// MARK: - Market View State
struct MarketViewState {
    let markets: [Market]
    let isLoading: Bool
    let errorMessage: String?
    let isEmpty: Bool
    let searchQuery: String
    
    static let initial = MarketViewState(
        markets: [],
        isLoading: false,
        errorMessage: nil,
        isEmpty: true,
        searchQuery: ""
    )
}

// MARK: - Portfolio Mock Data (for UI)
struct PortfolioData {
    let totalBalance: String
    let monthlyChange: String
    let monthlyPercentage: String
    let isPositive: Bool
    let sparklineData: [Double]
    
    static let mock = PortfolioData(
        totalBalance: "$24,562.50",
        monthlyChange: "+$2,562.50",
        monthlyPercentage: "+11.23%",
        isPositive: true,
        sparklineData: [100, 120, 105, 140, 135, 160, 155, 180, 175, 200, 195, 220, 210, 245]
    )
}
