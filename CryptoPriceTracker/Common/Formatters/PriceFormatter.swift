//
//  PriceFormatter.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation

struct PriceFormatter {
    static let shared = PriceFormatter()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }()
    
    private let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1 // CoinGecko already provides percentage values
        return formatter
    }()
    
    private let shortNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    func formatPrice(_ price: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: price)) ?? "$0.00"
    }
    
    func formatPercentage(_ percentage: Double) -> String {
        let sign = percentage >= 0 ? "+" : ""
        let formatted = percentageFormatter.string(from: NSNumber(value: percentage)) ?? "0.00%"
        return "\(sign)\(formatted)"
    }
    
    func formatLargeNumber(_ number: Double) -> String {
        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        let thousand = 1_000.0
        
        if number >= billion {
            let value = number / billion
            return "$\(shortNumberFormatter.string(from: NSNumber(value: value)) ?? "0")B"
        } else if number >= million {
            let value = number / million
            return "$\(shortNumberFormatter.string(from: NSNumber(value: value)) ?? "0")M"
        } else if number >= thousand {
            let value = number / thousand
            return "$\(shortNumberFormatter.string(from: NSNumber(value: value)) ?? "0")K"
        } else {
            return formatPrice(number)
        }
    }
}
