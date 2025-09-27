//
//  PeriodPillView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct PeriodPillView: View {
    let period: TimePeriod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(period.displayText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.white : Color.gray.opacity(0.2))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PeriodPillView(
        period: .oneDay,
        isSelected: true,
        onTap: {
            print("tapped")
        }
    )
}
