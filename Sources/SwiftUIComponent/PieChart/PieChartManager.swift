//
//  PieChartManager.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

struct SectorModel: Identifiable {
    let id: Int
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
}

final class PieChartManager<Value>: ObservableObject where Value: BinaryFloatingPoint {
    @Published var sectors: [SectorModel]
    @Published var selectedID: Int

    init(sectors: [(value: Value, color: Color)]) {
        let values: [Value] = sectors.map { $0.value }
        var accumulations: [Value] = [0] + values

        for i in 1..<accumulations.count {
            accumulations[i] += accumulations[i-1]
        }

        let sum: Value = accumulations.last!
        let angles: [Angle] = accumulations.map { ($0 / sum * 360).degrees }

        self.sectors = sectors.enumerated().map { sector in
            let idx = sector.offset
            return SectorModel(id: idx,
                               startAngle: angles[idx],
                               endAngle: angles[idx + 1],
                               color: sector.element.color)
        }

        self.selectedID = -1
    }
}
