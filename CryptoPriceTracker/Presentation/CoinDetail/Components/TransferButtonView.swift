//
//  TransferButtonView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct TransferButtonView: View {
    let onTransferTapped: () -> Void
    
    var body: some View {
        Button(action: onTransferTapped) {
            HStack(spacing: 12) {
                Text("Transfer")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.teal,
                        Color.cyan
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        TransferButtonView(
            onTransferTapped: {}
        )
        
        TransferButtonView(
            onTransferTapped: {}
        )
    }
    .background(Color.black)
    .padding()
}
