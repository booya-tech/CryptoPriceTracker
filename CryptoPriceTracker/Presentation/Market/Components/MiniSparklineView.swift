//
//  MiniSparklineView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct MiniSparklineView: View {
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height

                // Create a simple wavy line
                path.move(to: CGPoint(x: 0, y: height * 0.8))

                path.addCurve(
                    to: CGPoint(x: width * 0.25, y: height * 0.4),
                    control1: CGPoint(x: width * 0.1, y: height * 0.6),
                    control2: CGPoint(x: width * 0.15, y: height * 0.5)
                )

                path.addCurve(
                    to: CGPoint(x: width * 0.5, y: height * 0.6),
                    control1: CGPoint(x: width * 0.35, y: height * 0.3),
                    control2: CGPoint(x: width * 0.4, y: height * 0.5)
                )

                path.addCurve(
                    to: CGPoint(x: width * 0.75, y: height * 0.3),
                    control1: CGPoint(x: width * 0.6, y: height * 0.7),
                    control2: CGPoint(x: width * 0.65, y: height * 0.4)
                )

                path.addCurve(
                    to: CGPoint(x: width, y: height * 0.2),
                    control1: CGPoint(x: width * 0.85, y: height * 0.2),
                    control2: CGPoint(x: width * 0.9, y: height * 0.1)
                )
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
}

#Preview {
    MiniSparklineView(color: .green)
}
