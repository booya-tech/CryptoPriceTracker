//
//  PriceChartView.swift
//  CryptoPriceTracker
//
//  Created by Panachai Sulsaksakul on 9/27/25.
//

import SwiftUI

struct PriceChartView: View {
    let chartData: [ChartPoint]
    let isLoading: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                // Loading skeleton
                ChartSkeletonView()
            } else if chartData.isEmpty {
                // Empty state
                ChartEmptyView()
            } else {
                // Actual chart
                LineChartView(data: chartData)
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
    }
}

struct LineChartView: View {
    let data: [ChartPoint]
    
    private var minPrice: Double {
        data.map(\.price).min() ?? 0
    }
    
    private var maxPrice: Double {
        data.map(\.price).max() ?? 0
    }
    
    private var priceRange: Double {
        maxPrice - minPrice
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                
                // Chart line with gradient
                Path { path in
                    let points = normalizedPoints(in: geometry.size)
                    
                    guard let firstPoint = points.first else { return }
                    path.move(to: firstPoint)
                    
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.green, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                )
                
                // Gradient fill under the line
                Path { path in
                    let points = normalizedPoints(in: geometry.size)
                    
                    guard let firstPoint = points.first else { return }
                    path.move(to: CGPoint(x: firstPoint.x, y: geometry.size.height))
                    path.addLine(to: firstPoint)
                    
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    
                    if let lastPoint = points.last {
                        path.addLine(to: CGPoint(x: lastPoint.x, y: geometry.size.height))
                    }
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.3),
                            Color.blue.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
    
    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard data.count > 1, priceRange > 0 else { return [] }
        
        let chartWidth = size.width - 24 // Account for padding
        let chartHeight = size.height - 24
        
        return data.enumerated().map { index, point in
            let x = Double(index) / Double(data.count - 1) * chartWidth + 12
            let y = (1 - (point.price - minPrice) / priceRange) * chartHeight + 12
            return CGPoint(x: x, y: y)
        }
    }
}

struct ChartSkeletonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                VStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(.white)
                    
                    Text("Loading chart...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            )
    }
}

struct ChartEmptyView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.1))
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.gray)
                    
                    Text("No chart data available")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            )
    }
}

#Preview {
    let sampleData = [
        ChartPoint(timestamp: Date(), price: 100),
        ChartPoint(timestamp: Date(), price: 120),
        ChartPoint(timestamp: Date(), price: 110),
        ChartPoint(timestamp: Date(), price: 140),
        ChartPoint(timestamp: Date(), price: 135),
        ChartPoint(timestamp: Date(), price: 160),
        ChartPoint(timestamp: Date(), price: 155)
    ]
    
    return VStack(spacing: 20) {
        PriceChartView(chartData: sampleData, isLoading: false)
        PriceChartView(chartData: [], isLoading: true)
        PriceChartView(chartData: [], isLoading: false)
    }
    .background(Color.black)
    .padding()
}
