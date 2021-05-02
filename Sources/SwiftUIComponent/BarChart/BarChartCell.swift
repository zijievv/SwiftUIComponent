//
//  BarChartCell.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

struct BarChartCell: View {
    let id: Int
    let height: CGFloat
    let range: Range<Double>
    let overallRange: Range<Double>
    let backgroundOpacity: Double = 0.001

    init(
        id: Int,
        height: CGFloat,
        range: Range<Double>,
        overallRange: Range<Double>
    ) {
        self.id = id
        self.height = height
        self.range = range
        self.overallRange = overallRange
    }

    var body: some View {
        Capsule()
            .frame(height: barHeight)
            .offset(x: 0, y: yOffset)
            .frame(height: height)
    }

    private var barHeight: CGFloat {
        height * CGFloat(range.magnitude / overallRange.magnitude)
    }

    private var yOffset: CGFloat {
        let downMoveRatio = (overallRange.magnitude - range.magnitude) / 2
        let upMoveRatio = overallRange.lowerBound - range.lowerBound
        return CGFloat((downMoveRatio + upMoveRatio) / overallRange.magnitude) * height
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Group {
                BarChartCell(id: 0, height: 350, range: 0..<10, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: 0..<7, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: 0..<5, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: 0..<3, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: 3..<5, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: 5..<7, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: 3..<7, overallRange: 0..<10)
            }
            .frame(width: 20)
        }
        .squareFrame(350)
        .background(Color.white.shadow(radius: 10))
    }
}
