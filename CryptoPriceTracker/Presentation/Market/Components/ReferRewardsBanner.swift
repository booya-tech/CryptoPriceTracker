//
//  ReferRewardsBanner.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI

struct ReferRewardsBanner: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Refer Rewards")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)

                Text("Earn 5$ rewards on every\nsuccessful refers")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Banner icon positioned to the right
            Image("banner-icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(.trailing, 8)

            // Close button in top-right corner
            VStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowing = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                }
                Spacer()
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.95, blue: 0.8),
                    Color(red: 0.1, green: 0.8, blue: 0.95),
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
    }
}

#Preview {
    @Previewable @State var isShowing = true
    
    return ReferRewardsBanner(isShowing: $isShowing)
        .background(Color.black)
        .padding()
}
