//
//  MarketStatisticsView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI
import RxSwift
import RxCocoa

struct MarketStatisticsView: View {
    let viewModel: MarketViewModel
    @State private var selectedFilter = "24 hrs"
    @State private var markets: [Market] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let disposeBag = DisposeBag()
    
    let filters = ["24 hrs", "Hot", "Profit", "Rising", "Loss", "Top Gain"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("Market Statistics")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Filter Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        FilterTabView(
                            title: filter,
                            isSelected: selectedFilter == filter
                        ) {
                            selectedFilter = filter
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Crypto List
            LazyVStack(spacing: 12) {
                if isLoading && markets.isEmpty {
                    // Loading State
                    ForEach(0..<5, id: \.self) { _ in
                        CoinRowSkeletonView()
                            .padding(.horizontal, 20)
                    }
                } else {
                    ForEach(markets.prefix(10), id: \.id) { market in
                        CoinRowView(market: market)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.top, 10)
        }
        .onAppear {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        // Bind markets data
        viewModel.markets
            .drive(onNext: { [self] marketList in
                self.markets = marketList
            })
            .disposed(by: disposeBag)
        
        // Bind loading state
        viewModel.isLoading
            .drive(onNext: { [self] loading in
                self.isLoading = loading
            })
            .disposed(by: disposeBag)
        
        // Bind error state
        viewModel.errorMessage
            .drive(onNext: { [self] error in
                self.errorMessage = error
            })
            .disposed(by: disposeBag)
    }
}

struct FilterTabView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.white : Color.gray.opacity(0.2)
                )
                .cornerRadius(20)
        }
    }
}

struct CoinRowSkeletonView: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 16)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 12)
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 20)
                .cornerRadius(4)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    let container = AppDependencyContainer.shared
    let viewModel = container.makeMarketViewModel()
    
    return MarketStatisticsView(viewModel: viewModel)
        .background(Color.black)
}
