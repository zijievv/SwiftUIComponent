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

public struct BarChartCell: View {
    public enum Style {
        case capsule(
            roundedCornerStyle: RoundedCornerStyle = .circular,
            strokeStyle: StrokeStyle? = nil
        )
        case ellipse(strokeStyle: StrokeStyle? = nil)
        case roundedRectangle(
            cornerRadius: CGFloat = 0,
            roundedCornerStyle: RoundedCornerStyle = .circular,
            strokeStyle: StrokeStyle? = nil
        )
    }

    let id: Int
    let height: CGFloat
    let range: Range<Double>
    let overallRange: Range<Double>
    let style: Style

    public init(
        id: Int,
        height: CGFloat,
        range: Range<Double>,
        overallRange: Range<Double>,
        style: Style = .capsule()
    ) {
        self.id = id
        self.height = height
        self.range = range
        self.overallRange = overallRange
        self.style = style
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .opacity(.leastNonzeroMagnitude)
            style.view
                .frame(height: barHeight)
                .offset(x: 0, y: yOffset)
        }
        .frame(height: height)
    }

    private var barHeight: CGFloat {
        height * CGFloat(range.magnitude / overallRange.magnitude)
    }

    private var yOffset: CGFloat {
        let overallMagnitude = overallRange.magnitude
        let downMoveRatio = (overallMagnitude - range.magnitude) / 2
        let upMoveRatio = overallRange.lowerBound - range.lowerBound
        return CGFloat((downMoveRatio + upMoveRatio) / overallMagnitude) * height
    }
}

struct BarChartCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Group {
                BarChartCell(id: 0, height: 350, range: 0..<0, overallRange: 0..<10)
                BarChartCell(id: 1, height: 350, range: -1..<1, overallRange: -1..<9)
                BarChartCell(id: 2, height: 350, range: 0..<2, overallRange: 0..<10)
                BarChartCell(id: 3, height: 350, range: 0..<3, overallRange: 0..<10)
                BarChartCell(id: 4, height: 350, range: 1..<4, overallRange: 0..<10)
                BarChartCell(id: 5, height: 350, range: 5..<5, overallRange: 0..<10)
                BarChartCell(id: 6, height: 350, range: 0..<6, overallRange: 0..<10,
                             style: .ellipse())
                BarChartCell(id: 7, height: 350, range: 5..<7, overallRange: 0..<10,
                             style: .ellipse())
                BarChartCell(id: 8, height: 350, range: 5..<8, overallRange: 0..<10,
                             style: .roundedRectangle())
                BarChartCell(id: 9, height: 350, range: 1..<9, overallRange: 0..<10,
                             style: .capsule(strokeStyle: StrokeStyle(lineWidth: 2)))
            }
        }
        .frame(width: 350, height: 350)
        .padding()
        .background(Color.white.shadow(radius: 10))
    }
}

extension BarChartCell.Style {
    @ViewBuilder fileprivate var view: some View {
        switch self {
        case let .capsule(roundedCornerStyle: roundedCornerStyle, strokeStyle: strokeStyle):
            Capsule(style: roundedCornerStyle)
                .if(strokeStyle != nil) { capsule in
                    capsule.stroke(style: strokeStyle!)
                }
        case let .ellipse(strokeStyle: strokeStyle):
            Ellipse()
                .if(strokeStyle != nil) { ellipse in
                    ellipse.stroke(style: strokeStyle!)
                }
        case let .roundedRectangle(cornerRadius: radius,
                                   roundedCornerStyle: roundedCornerStyle,
                                   strokeStyle: strokeStyle):
            RoundedRectangle(cornerRadius: radius, style: roundedCornerStyle)
                .if(strokeStyle != nil) { roundedRectangle in
                    roundedRectangle.stroke(style: strokeStyle!)
                }
        }
    }
}
