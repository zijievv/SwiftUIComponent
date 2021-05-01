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
    let startColor: Color
    let endColor: Color
}

final class PieChartManager<Value>: ObservableObject where Value: BinaryFloatingPoint {
    @Published var sectors: [SectorModel]
    @Published var selectedID: Int

    init(sectors: [(value: Value, color: Color)]) {
        let values: [Value] = sectors.map { $0.value }
        let angles: [Angle] = Self.angles(from: values)

        self.sectors = sectors.enumerated().map { sector in
            let idx = sector.offset
            return SectorModel(id: idx,
                               startAngle: angles[idx],
                               endAngle: angles[idx + 1],
                               startColor: sector.element.color,
                               endColor: sector.element.color)
        }

        self.selectedID = -1
    }

    init(values: [Value], startColor: Color, endColor: Color) {
        let angles = Self.angles(from: values)

        self.sectors = values.enumerated().map { item in
            let idx = item.offset
            return SectorModel(id: idx,
                               startAngle: angles[idx],
                               endAngle: angles[idx + 1],
                               startColor: startColor,
                               endColor: endColor)
        }
        self.selectedID = -1
    }

    private static func angles(from values: [Value]) -> [Angle] {
        var accumulations: [Value] = [0] + values

        for i in 1..<accumulations.count {
            accumulations[i] += accumulations[i-1]
        }

        let sum: Value = accumulations.last!
        return accumulations.map { ($0 / sum * 360).degrees }
    }
}
