//
//  APIEndpoint.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case markets(page: Int, perPage: Int)
    case coinDetail(id: String)
    case marketChart(id: String, days: Int)
    
    var path: String {
        switch self {
        case .markets:
            return "/coins/markets"
        case .coinDetail(let id):
            return "/coins/\(id)"
        case .marketChart(let id, _):
            return "/coins/\(id)/market_chart"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any] {
        switch self {
        case .markets(let page, let perPage):
            return [
                "vs_currency": "usd",
                "order": "market_cap_desc",
                "per_page": perPage,
                "page": page,
                "sparkline": true,
                "price_change_percentage": "24h"
            ]
            
        case .coinDetail:
            return [
                "localization": false,
                "tickers": false,
                "market_data": true,
                "community_data": false,
                "developer_data": false,
                "sparkline": false
            ]
            
        case .marketChart(_, let days):
            return [
                "vs_currency": "usd",
                "days": days,
            ]
        }
    }
}
