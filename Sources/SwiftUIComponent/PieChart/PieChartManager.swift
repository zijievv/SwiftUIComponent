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
    let start: Angle
    let end: Angle
    let startColor: Color
    let endColor: Color

    var colors: [Color] { [startColor, endColor] }
}

final class PieChartManager {
    let sectors: [SectorModel]

    init(sectors: [(value: Double, color: Color)]) {
        let values: [Double] = sectors.map(\.value)
        let angles: [Angle] = Self.angles(from: values)
        self.sectors = sectors.lazy.enumerated().map { offset, sector in
            SectorModel(
                id: offset,
                start: angles[offset],
                end: angles[offset+1],
                startColor: sector.color,
                endColor: sector.color
            )
        }
    }

    init(values: [Double], startColor: Color, endColor: Color) {
        let angles = Self.angles(from: values)
        self.sectors = values.lazy.enumerated().map { offset, _ in
            SectorModel(
                id: offset,
                start: angles[offset],
                end: angles[offset+1],
                startColor: startColor,
                endColor: endColor
            )
        }
    }

    private static func angles(from values: [Double]) -> [Angle] {
        var accumulations: [Double] = [0]
        for value in values {
            accumulations.append(accumulations.last! + value)
        }
        let sum: Double = accumulations.last!
        return accumulations.map { Angle(degrees: $0 / sum * 360) }
    }
}
