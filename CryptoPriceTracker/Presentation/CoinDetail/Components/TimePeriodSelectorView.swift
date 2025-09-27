//
//  TimePeriodSelectorView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct TimePeriodSelectorView: View {
    let selectedPeriod: TimePeriod
    let onPeriodSelected: (TimePeriod) -> Void
    
    private let periods: [TimePeriod] = [.oneHour, .oneDay, .oneWeek, .oneMonth, .oneYear, .all]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(periods, id: \.self) { period in
                    PeriodPillView(
                        period: period,
                        isSelected: period == selectedPeriod,
                        onTap: {
                            onPeriodSelected(period)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TimePeriodSelectorView(
        selectedPeriod: .oneWeek,
        onPeriodSelected: { _ in }
    )
    .background(Color.black)
    .padding()
}
