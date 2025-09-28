//
//  WelcomeView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer()
                // 3D Phone Hero Illustration
                Image("welcome-hero-phone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 320)
                    .padding(.horizontal, 40)

                Spacer().frame(height: 60)

                // Title and Subtitle
                VStack(spacing: 16) {
                    Text("Your personal crypto wallet")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)

                    Text("Its secure and support near about hundred crypto currencies")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 20)
                }

                Spacer()

                // Get Started Button
                NavigationLink(destination: {
                    let container = AppDependencyContainer.shared
                    let marketViewModel = container.makeMarketViewModel()
                    MarketView(viewModel: marketViewModel)
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.teal)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer().frame(height: 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
        }
    }
}

#Preview {
    WelcomeView()
}
