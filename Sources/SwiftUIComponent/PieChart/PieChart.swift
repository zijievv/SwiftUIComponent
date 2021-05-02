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

struct PieChart: View {
    @State private var selected = false
    @State private var selectedID: Int = -1

    private let manager: PieChartManager
    private let pieChartAnimation: Animation?
    private let selectedIDAnimation: Animation?

    init(
        manager: PieChartManager,
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
                        .fill(
                            AngularGradient(
                                gradient: Gradient(colors: [sector.startColor, sector.endColor]),
                                center: .center,
                                startAngle: sector.startAngle,
                                endAngle: sector.endAngle
                            )
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

        @StateObject var manager = PieChartManager(sectors: data.map { ($0.0, $0.2) })
        @StateObject var m2 = PieChartManager(values: data.map { $0.0 },
                                              startColor: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), endColor: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)))

        var description: String {
            if manager.selectedID == -1 {
                return "Not selected"
            } else {
                return Self.data[manager.selectedID].1
            }
        }

        var d2: String {
            if m2.selectedID == -1 {
                return "Not selected"
            } else {
                return Self.data[m2.selectedID].1
            }
        }

        var body: some View {
            VStack {
                Text(description)
                    .font(Font.system(.largeTitle, design: .rounded).weight(.semibold))
                    .padding()
                PieChart(manager: manager)
                    .squareFrame(350)

                Text(d2)
                    .font(Font.system(.largeTitle, design: .rounded).weight(.semibold))
                    .padding()
                PieChart(manager: m2, pieChartAnimation: Animation.interactiveSpring())
                    .squareFrame(350)
            }
        }
    }

    static var previews: some View {
        PCP()
    }
}
