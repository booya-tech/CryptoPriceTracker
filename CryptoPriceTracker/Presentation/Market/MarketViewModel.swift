//
//  MarketViewModel.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MarketViewModel {
    // MARK: - Inputs
    private let refreshTrigger = PublishSubject<Void>()
    private let searchText = BehaviorSubject<String>(value: "")

    // MARK: - Outputs
    let markets: Driver<[Market]>
    let isLoading: Driver<Bool>
    let errorMessage: Driver<String?>
    let isEmpty: Driver<Bool>

    // MARK: - Private
    private let fetchMarketsUseCase: FetchMarketsUseCaseProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(fetchMarketsUseCase: FetchMarketsUseCaseProtocol) {
        self.fetchMarketsUseCase = fetchMarketsUseCase

        // Create loading state
        let activityIndicator = ActivityIndicator()
        self.isLoading = activityIndicator.asDriver()

        // Create error tracker
        let errorTracker = ErrorTracker()
        self.errorMessage = errorTracker.asDriver()

        // Fetch markets on refresh trigger or initial load
        let fetchedMarkets = Observable.merge(
            Observable.just(()),  // Initial load
            refreshTrigger.asObservable()
        )
        .flatMapLatest { [fetchMarketsUseCase = self.fetchMarketsUseCase, activityIndicator, errorTracker] _ -> Observable<[Market]> in
            return fetchMarketsUseCase.execute(page: 1, perPage: 100)
                .asObservable()
                .do(
                    onNext: { _ in activityIndicator.loading.onNext(false) },
                    onError: { error in
                        activityIndicator.loading.onNext(false)
                        if let appError = error as? AppError {
                            errorTracker.error.onNext(appError.localizedDescription)
                        } else {
                            errorTracker.error.onNext(error.localizedDescription)
                        }
                    },
                    onSubscribe: { activityIndicator.loading.onNext(true) }
                )
                .catch { _ in Observable.empty() }
        }
        .share(replay: 1)
        // Combine fetched markets with search text for filtering
        let marketsObservable = Observable.combineLatest(
            fetchedMarkets,
            searchText.distinctUntilChanged()
        )
        .map { markets, searchQuery in
            guard !searchQuery.isEmpty else { return markets }
            return markets.filter { market in
                market.name.lowercased().contains(searchQuery.lowercased())
                    || market.symbol.lowercased().contains(searchQuery.lowercased())
            }
        }

        self.markets = marketsObservable.asDriver(onErrorJustReturn: [])

        // Empty state
        self.isEmpty =
            marketsObservable
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
    }

    // MARK: - Public Methods
    func refresh() {
        refreshTrigger.onNext(())
    }

    func search(query: String) {
        searchText.onNext(query)
    }
}

// MARK: - Activity Indicator
fileprivate final class ActivityIndicator {
    fileprivate let loading = BehaviorSubject<Bool>(value: false)

    func asDriver() -> Driver<Bool> {
        return loading.asDriver(onErrorJustReturn: false)
    }
}

// MARK: - Error Tracker
fileprivate final class ErrorTracker {
    fileprivate let error = BehaviorSubject<String?>(value: nil)

    func asDriver() -> Driver<String?> {
        return error.asDriver(onErrorJustReturn: nil)
    }
}