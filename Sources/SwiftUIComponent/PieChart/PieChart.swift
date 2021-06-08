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

public struct PieChart: View {
    @Binding var selectedID: Int
    private let manager: PieChartManager
    private let selectedAnimation: Animation?

    public init(
        selectedID: Binding<Int>,
        sectors: [(Double, Color)],
        selectedAnimation: Animation? = .default
    ) {
        self._selectedID = selectedID
        self.manager = PieChartManager(sectors: sectors)
        self.selectedAnimation = selectedAnimation
    }

    public init(
        selectedID: Binding<Int>,
        values: [Double],
        startColor: Color,
        endColor: Color,
        selectedAnimation: Animation? = .default
    ) {
        self._selectedID = selectedID
        self.manager = PieChartManager(values: values, startColor: startColor, endColor: endColor)
        self.selectedAnimation = selectedAnimation
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(manager.sectors, id: \.id) { sector in
                    Sector(from: sector.start, to: sector.end)
                        .fill(
                            AngularGradient(
                                gradient: Gradient(colors: sector.colors),
                                center: .center,
                                startAngle: sector.start,
                                endAngle: sector.end
                            )
                        )
                        .grayscale(!selecting || selectedID == sector.id ? 0 : 0.5)
                        .scaleEffect(selectedID == sector.id ? 1.05 : 1)
                        .shadow(color: .black, radius: selectedID == sector.id ? 5 : 0, x: 0, y: 0)
                        .onTapGesture {
                            if selectedID == sector.id {
                                withAnimation(selectedAnimation) {
                                    selectedID = -1
                                }
                            } else {
                                withAnimation(selectedAnimation) {
                                    selectedID = sector.id
                                }
                            }
                        }
                }
            } //: ZStack
            .rotationEffect(Angle(degrees: -90))
            .padding(16)
            .squareFrame(min(geometry.size.width, geometry.size.height))
        }
    }

    private var selecting: Bool {
        Range<Int>(uncheckedBounds: (0, manager.sectors.count)).contains(selectedID)
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChartPreview()
    }
}

fileprivate struct PieChartPreview: View {
    @State var selectedID: Int = 5
    let values: [Double] = [6, 7, 9]
    let colors: [Color] = [.blue, .red, .yellow]

    var body: some View {
        VStack {
            Text(pieDescription)
            PieChart(selectedID: $selectedID, sectors: Array(zip(values, colors)))
                .squareFrame(350)
        }
    }

    private var pieDescription: String {
        guard selectedID >= 0 else {
            return "Nil"
        }
        return "\(values[selectedID]) -- \(colors[selectedID].description)"
    }
}
