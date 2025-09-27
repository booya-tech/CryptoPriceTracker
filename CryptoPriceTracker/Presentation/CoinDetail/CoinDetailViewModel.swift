//
//  CoinDetailViewModel.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinDetailViewModel {
    
    // MARK: - Inputs
    private let coinId: String
    private let refreshTrigger = PublishSubject<Void>()
    private let timePeriodSubject = BehaviorSubject<TimePeriod>(value: .oneWeek)
    private let favoriteToggle = PublishSubject<Void>()
    
    // MARK: - Outputs
    let coinDetail: Driver<CoinDetail?>
    let chartData: Driver<[ChartPoint]>
    let isLoading: Driver<Bool>
    let isChartLoading: Driver<Bool>
    let errorMessage: Driver<String?>
    let isFavorite: Driver<Bool>
    let selectedTimePeriod: Driver<TimePeriod>
    
    // MARK: - Private
    private let fetchCoinDetailUseCase: FetchCoinDetailUseCaseProtocol
    private let fetchMarketChartUseCase: FetchMarketChartUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(
        coinId: String,
        fetchCoinDetailUseCase: FetchCoinDetailUseCaseProtocol,
        fetchMarketChartUseCase: FetchMarketChartUseCaseProtocol
    ) {
        self.coinId = coinId
        self.fetchCoinDetailUseCase = fetchCoinDetailUseCase
        self.fetchMarketChartUseCase = fetchMarketChartUseCase
        
        // Create activity indicators
        let detailActivityIndicator = ActivityIndicator()
        let chartActivityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        self.isLoading = detailActivityIndicator.asDriver()
        self.isChartLoading = chartActivityIndicator.asDriver()
        self.errorMessage = errorTracker.asDriver()
        self.selectedTimePeriod = timePeriodSubject.asDriver(onErrorJustReturn: .oneWeek)
        
        // Fetch coin detail on refresh or initial load
        let fetchedCoinDetail = Observable.merge(
            Observable.just(()), // Initial load
            refreshTrigger.asObservable()
        )
            .flatMapLatest { [fetchCoinDetailUseCase = self.fetchCoinDetailUseCase, coinId = self.coinId, detailActivityIndicator, errorTracker] _ -> Observable<CoinDetail> in
                return fetchCoinDetailUseCase.execute(coinId: coinId)
                    .asObservable()
                    .do(
                        onNext: { _ in detailActivityIndicator.loading.onNext(false) },
                        onError: { error in
                            detailActivityIndicator.loading.onNext(false)
                            if let appError = error as? AppError {
                                errorTracker.error.onNext(appError.localizedDescription)
                            } else {
                                errorTracker.error.onNext(error.localizedDescription)
                            }
                        },
                        onSubscribe: { detailActivityIndicator.loading.onNext(true) }
                    )
                    .catch { _ in Observable.empty() }
            }
            .share(replay: 1)
        
        self.coinDetail = fetchedCoinDetail
            .map { Optional($0) }
            .asDriver(onErrorJustReturn: nil)
        
        // Fetch chart data when time period changes
        let chartDataObservable = timePeriodSubject
            .distinctUntilChanged()
            .flatMapLatest { [fetchMarketChartUseCase = self.fetchMarketChartUseCase, coinId = self.coinId, chartActivityIndicator, errorTracker] (timePeriod: TimePeriod) -> Observable<[ChartPoint]> in
                return fetchMarketChartUseCase.execute(coinId: coinId, days: timePeriod.days)
                    .asObservable()
                    .do(
                        onNext: { _ in chartActivityIndicator.loading.onNext(false) },
                        onError: { error in
                            chartActivityIndicator.loading.onNext(false)
                            if let appError = error as? AppError {
                                errorTracker.error.onNext(appError.localizedDescription)
                            } else {
                                errorTracker.error.onNext(error.localizedDescription)
                            }
                        },
                        onSubscribe: { chartActivityIndicator.loading.onNext(true) }
                    )
                    .catch { _ in Observable.empty() }
            }
        
        self.chartData = chartDataObservable.asDriver(onErrorJustReturn: [])
        
        // Favorite state (placeholder - will implement CoreData later)
        self.isFavorite = favoriteToggle
            .scan(false) { currentState, _ in !currentState }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }
    
    // MARK: - Public Methods
    func refresh() {
        refreshTrigger.onNext(())
    }
    
    func selectTimePeriod(_ period: TimePeriod) {
        timePeriodSubject.onNext(period)
    }
    
    func toggleFavorite() {
        favoriteToggle.onNext(())
    }
}

// MARK: - Activity Indicator (Reused from MarketViewModel)
fileprivate final class ActivityIndicator {
    fileprivate let loading = BehaviorSubject<Bool>(value: false)
    
    func asDriver() -> Driver<Bool> {
        return loading.asDriver(onErrorJustReturn: false)
    }
}

// MARK: - Error Tracker (Reused from MarketViewModel)
fileprivate final class ErrorTracker {
    fileprivate let error = BehaviorSubject<String?>(value: nil)
    
    func asDriver() -> Driver<String?> {
        return error.asDriver(onErrorJustReturn: nil)
    }
}
