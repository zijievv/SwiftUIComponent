//
//  BarChart.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

struct BarChart: View {
    @State private var selectedID: Int = -1
    @State private var selected: Bool = false

    private let manager: BarChartManager
    private let spacingRatio: CGFloat
    private let barChartAnimation: Animation?
    private let selectedIDAnimation: Animation?

    init(
        manager: BarChartManager,
        barSpacingRatio: CGFloat = 0.0083,
        barChartAnimation: Animation? = .default,
        selectedIDAnimation: Animation? = nil
    ) {
        self.manager = manager
        self.spacingRatio = barSpacingRatio
        self.barChartAnimation = barChartAnimation
        self.selectedIDAnimation = selectedIDAnimation
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if manager.indicator != nil {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 1)
                        .offset(x: 0, y: yOffsetIndicator(with: geometry))
                        .transition(.slide)
                }

                HStack(spacing: geometry.size.width * spacingRatio) {
                    ForEach(Array(manager.ranges.enumerated()), id: \.offset) { idx, range in
                        BarChartCell(id: idx,
                                     height: geometry.size.height,
                                     range: range,
                                     overallRange: manager.overallRange)
                            .transition(.slide)
                            .animation(.ripple(index: idx))
                            .opacity(selected ? (selectedID == idx ? 1 : 0.33) : 1)
                    }
                } //: HStack
            } //: ZStack
        }
    }

    private func yOffsetIndicator(with geometry: GeometryProxy) -> CGFloat {
        -geometry.minimum * CGFloat(manager.indicator! / manager.overallRange.magnitude)
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        let values: [Double] = [1, 3, 7, 5, 11, 4, 6, 9, 2]
        let manager = BarChartManager(values: values, indicator: 5)
        return BarChart(manager: manager, barSpacingRatio: 0.02)
            .frame(width: 350, height: 350)
    }
}
