//
//  PieChart.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

struct PieChart<Value>: View where Value: BinaryFloatingPoint {
    @State private var selected = false
    @State private var selectedID: Int = -1

    private let manager: PieChartManager<Value>
    private let pieChartAnimation: Animation?
    private let selectedIDAnimation: Animation?

    init(
        manager: PieChartManager<Value>,
        pieChartAnimation: Animation? = .default,
        selectedIDAnimation: Animation? = nil
    ) {
        self.manager = manager
        self.pieChartAnimation = pieChartAnimation
        self.selectedIDAnimation = selectedIDAnimation
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(manager.sectors, id: \.id) { sector in
                    Sector(startAngle: sector.startAngle, endAngle: sector.endAngle)
                        .foregroundColor(
                            sector.color
                                .reduceOpaque(selected ? (selectedID == sector.id ? 0 : 0.3) : 0)
                        )
                        .grayscale(selected ? (selectedID == sector.id ? 0 : 0.5) : 0)
                        .scaleEffect(selectedID == sector.id ? 1.05 : 1)
                        .shadow(color: .black, radius: selectedID == sector.id ? 5 : 0, x: 0, y: 0)
                        .onTapGesture {
                            if selectedID == sector.id {
                                withAnimation(pieChartAnimation) {
                                    selectedID = -1
                                    selected = false
                                }

                                withAnimation(selectedIDAnimation) {
                                    manager.selectedID = -1
                                }
                            } else {
                                withAnimation(pieChartAnimation) {
                                    selectedID = sector.id
                                    selected = true
                                }

                                withAnimation(selectedIDAnimation) {
                                    manager.selectedID = sector.id
                                }
                            }
                        }
                }
            }
            .rotationEffect(-90.degrees)
            .padding(16)
            .squareFrame(geometry.minimum)
        }
    }
}

struct PieChart_Previews: PreviewProvider {
    private struct PCP: View {
        static let data: [(Double, String, Color)] = [
            (55, "Blue", .blue),
            (30, "Green", .green),
            (15, "Red", .red),
        ]

        @StateObject var manager = PieChartManager<Double>(sectors: data.map { ($0.0, $0.2) })

        var description: String {
            if manager.selectedID == -1 {
                return "Not selected"
            } else {
                return Self.data[manager.selectedID].1
            }
        }

        var body: some View {
            VStack {
                Text(description)
                    .font(Font.system(.largeTitle, design: .rounded).weight(.semibold))
                    .padding()
                PieChart(manager: manager)
            }
        }
    }

    static var previews: some View {
        PCP()
    }
}
