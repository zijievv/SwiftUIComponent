//
//  BarChartManager.swift
//
//
//  Created by zijie vv on 02/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

final class BarChartManager: ObservableObject {
    @Published var selectedID: Int
    var ranges: [Range<Double>]
    var overallRange: Range<Double>
    var indicator: Double?

    init(ranges: [Range<Double>], indicator: Double? = nil) {
        self.selectedID = -1
        self.ranges = ranges
        self.indicator = indicator

        guard !ranges.isEmpty else {
            self.overallRange = 0..<0
            return
        }

        if let indicator = indicator {
            let temp = ranges.overallRange()
            self.overallRange = min(temp.lowerBound, indicator)..<max(temp.upperBound, indicator)
        } else {
            self.overallRange = ranges.overallRange()
        }
    }

    init(floatingValues: [Double], origin: Double = 0, indicator: Double? = nil) {
        self.selectedID = -1
        let tempRanges = Self.floatingRanges(from: origin, to: floatingValues)
        self.ranges = tempRanges
        self.indicator = indicator

        guard !tempRanges.isEmpty else {
            self.overallRange = 0..<0
            return
        }

        if let indicator = indicator {
            let temp = tempRanges.overallRange()
            self.overallRange = min(temp.lowerBound, indicator)..<max(temp.upperBound, indicator)
        } else {
            self.overallRange = tempRanges.overallRange()
        }
    }

    init(values: [Double], indicator: Double? = nil) {
        self.selectedID = -1
        let tempRanges = values.map { 0..<$0 }
        self.ranges = tempRanges
        self.indicator = indicator

        guard !values.isEmpty else {
            self.overallRange = 0..<0
            return
        }

        let lower = 0.0
        let upper = values.max()!

        if let indicator = indicator {
            let lowerBound = min(lower, indicator)
            let upperBound = max(upper, indicator)
            self.overallRange = lowerBound..<upperBound
        } else {
            self.overallRange = lower..<upper
        }
    }

    private static func floatingRanges(from origin: Double,
                                       to values: [Double]) -> [Range<Double>] {
        var bounds = [origin]

        for value in values {
            bounds.append(bounds.last! + value)
        }

        var ranges: [Range<Double>] = []
        ranges.reserveCapacity(values.count)

        for i in 0..<bounds.count-1 {
            if bounds[i+1] < bounds[i] {
                ranges.append(bounds[i+1]..<bounds[i])
            } else {
                ranges.append(bounds[i]..<bounds[i+1])
            }
        }

        return ranges
    }
}
