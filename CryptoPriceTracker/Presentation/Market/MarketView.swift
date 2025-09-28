//
//  MarketView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI
import RxSwift
import RxCocoa

struct MarketView: View {
    private var viewModel: MarketViewModel
    @State private var searchText = ""
    @State private var showingRewards = true

    init(viewModel: MarketViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            // Bg Color
            Color.black.ignoresSafeArea()

            // ScrollView
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Portfolio Header
                    PortfolioHeaderView()
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                    // My Portfolio Section
                    MyPortfolioView()
                        .padding(.horizontal, 20)
                        .padding(.top, 30)

                    // Refer Rewards Banner Section
                    if showingRewards {
                        ReferRewardsBanner(isShowing: $showingRewards)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }

                    // Market Statistics Section
                    MarketStatisticsView(viewModel: viewModel)
                        .padding(.top, 30)
                }
            }
            .refreshable {
                viewModel.refresh()
            }
        }
        .onAppear {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        // Bind search text changes
        viewModel.search(query: searchText)
    }
}

#Preview {
    let container = AppDependencyContainer.shared
    let viewModel = container.makeMarketViewModel()
    return MarketView(viewModel: viewModel)
}
