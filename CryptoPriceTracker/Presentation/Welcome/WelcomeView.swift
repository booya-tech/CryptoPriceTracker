//
//  WelcomeView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/25/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
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
            Button("Get Started") {
                // TODO: Navigate to Market screen
                print("Navigate to Market screen")
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.9, blue: 0.7),
                        Color(red: 0.2, green: 0.8, blue: 0.9),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.trailing, 20)
                }
            )
            .padding(.horizontal, 24)

            Spacer().frame(height: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView()
}
