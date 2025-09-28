//
//  NetwokService.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/26/25.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> Single<T>
}

final class NetworkService: NetworkServiceProtocol {
    private let session: Session
    private let baseURL: String = "https://api.coingecko.com/api/v3"

    init() {
        // Adds User-Agent header (CoinGecko recommneds this for identification)
        let configuration = URLSessionConfiguration.default
        configuration.headers = HTTPHeaders([ 
            "User-Agent": "CryptoPriceTracker-iOS/1.0",
        ])

        // Max seconds to establish connection
        configuration.timeoutIntervalForRequest = 30
        // Max seconds to entire request
        configuration.timeoutIntervalForResource = 60
        
        self.session = Session(configuration: configuration)
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) -> Single<T> {
        return Single.create { observer in
            let url = "\(self.baseURL)\(endpoint.path)"
            print("🌐 Making request to: \(url)")
            print("📝 Parameters: \(endpoint.parameters)")

            let request = self.session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: URLEncoding.default
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                    case .success(let data):
                        observer(.success(data))
                    case .failure(let error):
                    print("❌ Network Error: \(error)")
                    print("📱 Response: \(String(describing: response.response))")
                    let appError = self.mapError(error, response: response.response)
                    observer(.failure(appError))
                }
            }

            return Disposables.create {
                // cancel network call if disposed
                request.cancel()
            }
        }
    }

    private func mapError(_ error: AFError, response: HTTPURLResponse?) -> AppError {
        switch error {
        case .responseValidationFailed(let reason):
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 429:
                    return .rateLimited
                case 400...499:
                    return .network("Client error: \(statusCode)")
                case 500...599:
                    return .network("Server error: \(statusCode)")
                default:
                    return .network("HTTP error: \(statusCode)")
                }
            }
            return .network("Validation failed: \(reason)")
        case .responseSerializationFailed:
            return .decoding("Failed to decode response")
        case .sessionTaskFailed(let sessionError):
            if let urlError = sessionError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    return .network("No internet connection")
                case .timedOut:
                    return .network("Request timed out")
                default:
                    return .network("Network error: \(urlError.localizedDescription)")
                }
            }
            return .network("Session error: \(sessionError.localizedDescription)")
        default:
            return .network("Unexpected error: \(error.localizedDescription)")
        }
    }
}
