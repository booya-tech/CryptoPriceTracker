//
//  LoadingView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text("Loading...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    LoadingView()
}
