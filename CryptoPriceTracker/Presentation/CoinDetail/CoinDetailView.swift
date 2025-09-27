//
//  CoinDetailView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI
import RxSwift
import RxCocoa

struct CoinDetailView: View {
    private let viewModel: CoinDetailViewModel
    @State private var coinDetail: CoinDetail?
    @State private var chartData: [ChartPoint] = []
    @State private var isLoading = false
    @State private var isFavorite = false
    @State private var selectedTimePeriod: TimePeriod = .oneWeek
    @State private var errorMessage: String?
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isLoading && coinDetail == nil {
                // Loading View
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        // Coin Detail Header
                        CoinDetailHeaderView(
                            coinDetail: coinDetail,
                            isFavorite: isFavorite,
                            onFavoriteToggle: {
                                viewModel.toggleFavorite()
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        // Coin Stats Pill
                        
                        // Time Period Selector
                        
                        // Chart
                        
                        // Transfer Button
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isFavorite ? .red : .white)
                }
            }
        }
        .onAppear() {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        // Bind coin detail
        viewModel.coinDetail
            .drive(onNext: { [self] detail in
                self.coinDetail = detail
            })
            .disposed(by: disposeBag)
        // Bind chart data
        viewModel.chartData
            .drive(onNext: { [self] data in
                self.chartData = data
            })
            .disposed(by: disposeBag)
        // Bind loading state
        viewModel.isLoading
            .drive(onNext: { [self] loading in
                self.isLoading = loading
            })
            .disposed(by: disposeBag)
        // Bind favorite state
        viewModel.isFavorite
            .drive(onNext: { [self] favorite in
                self.isFavorite = favorite
            })
            .disposed(by: disposeBag)
        // Bind selected time period
        viewModel.selectedTimePeriod
            .drive(onNext: { [self] period in
                self.selectedTimePeriod = period
            })
            .disposed(by: disposeBag)
        // Bind error message
        viewModel.errorMessage
            .drive(onNext: { [self] error in
                self.errorMessage = error
            })
            .disposed(by: disposeBag)
    }
}

#Preview {
    let container = AppDependencyContainer.shared
    let viewModel = container.makeCoinDetailViewModel(coinId: "cardano")
    
    CoinDetailView(viewModel: viewModel)
}
