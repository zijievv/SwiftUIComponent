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

public struct BarChart<T>: View where T: View {
    @Binding var selectedID: Int
    let ranges: [Range<Double>]
    let indicator: Double?
    let overallRange: Range<Double>
    let spacingScale: CGFloat
    let style: BarChartCell.Style
    let chartAnimation: Animation?
    let transition: AnyTransition
    let foreground: T

    public init(
        selectedID: Binding<Int>,
        ranges: [Range<Double>],
        indicator: Double? = nil,
        barSpacingScale: CGFloat = 0.0083,
        barStyle: BarChartCell.Style = .capsule(),
        animation: Animation? = .default,
        transition: AnyTransition = .slide,
        foreground: @escaping () -> T
    ) {
        self.ranges = ranges
        self.indicator = indicator
        self.overallRange = Self.overallRange(of: ranges, indicator: indicator)
        self._selectedID = selectedID
        self.spacingScale = barSpacingScale
        self.style = barStyle
        self.chartAnimation = animation
        self.transition = transition
        self.foreground = foreground()
    }

    public init(
        selectedID: Binding<Int>,
        ranges: [Range<Double>],
        indicator: Double? = nil,
        barSpacingScale: CGFloat = 0.0083,
        barStyle: BarChartCell.Style = .capsule(),
        animation: Animation? = .default,
        transition: AnyTransition = .slide,
        foreground: T
    ) {
        self.ranges = ranges
        self.indicator = indicator
        self.overallRange = Self.overallRange(of: ranges, indicator: indicator)
        self._selectedID = selectedID
        self.spacingScale = barSpacingScale
        self.style = barStyle
        self.chartAnimation = animation
        self.transition = transition
        self.foreground = foreground
    }

    public init(
        selectedID: Binding<Int>,
        origin: Double = 0,
        floatingIntervals intervals: [Double],
        indicator: Double? = nil,
        barSpacingScale: CGFloat = 0.0083,
        barStyle: BarChartCell.Style = .capsule(),
        animation: Animation? = .default,
        transition: AnyTransition = .slide,
        foreground: @escaping () -> T
    ) {
        self.ranges = Self.floatingRanges(origin: origin, adding: intervals)
        self.indicator = indicator
        self.overallRange = Self.overallRange(of: ranges, indicator: indicator)
        self._selectedID = selectedID
        self.spacingScale = barSpacingScale
        self.style = barStyle
        self.chartAnimation = animation
        self.transition = transition
        self.foreground = foreground()
    }

    public init(
        selectedID: Binding<Int>,
        origin: Double = 0,
        floatingIntervals intervals: [Double],
        indicator: Double? = nil,
        barSpacingScale: CGFloat = 0.0083,
        barStyle: BarChartCell.Style = .capsule(),
        animation: Animation? = .default,
        transition: AnyTransition = .slide,
        foreground: T
    ) {
        self.ranges = Self.floatingRanges(origin: origin, adding: intervals)
        self.indicator = indicator
        self.overallRange = Self.overallRange(of: ranges, indicator: indicator)
        self._selectedID = selectedID
        self.spacingScale = barSpacingScale
        self.style = barStyle
        self.chartAnimation = animation
        self.transition = transition
        self.foreground = foreground
    }

    public init(
        selectedID: Binding<Int>,
        values: [Double],
        indicator: Double? = nil,
        barSpacingScale: CGFloat = 0.0083,
        barStyle: BarChartCell.Style = .capsule(),
        animation: Animation? = .default,
        transition: AnyTransition = .slide,
        foreground: @escaping () -> T
    ) {
        self.ranges = values.map { 0..<$0 }
        self.indicator = indicator
        self.overallRange = Self.overallRange(of: ranges, indicator: indicator)
        self._selectedID = selectedID
        self.spacingScale = barSpacingScale
        self.style = barStyle
        self.chartAnimation = animation
        self.transition = transition
        self.foreground = foreground()
    }

    public init(
        selectedID: Binding<Int>,
        values: [Double],
        indicator: Double? = nil,
        barSpacingScale: CGFloat = 0.0083,
        barStyle: BarChartCell.Style = .capsule(),
        animation: Animation? = .default,
        transition: AnyTransition = .slide,
        foreground: T
    ) {
        self.ranges = values.map { 0..<$0 }
        self.indicator = indicator
        self.overallRange = Self.overallRange(of: ranges, indicator: indicator)
        self._selectedID = selectedID
        self.spacingScale = barSpacingScale
        self.style = barStyle
        self.chartAnimation = animation
        self.transition = transition
        self.foreground = foreground
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
//                Rectangle()
//                    .foregroundColor(.clear)
                if !ranges.isEmpty {
                    if indicator != nil {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 1)
                            .offset(x: 0, y: indicatorYOffset(with: geometry))
                            .transition(transition)
                    }

                    HStack(spacing: geometry.size.width * spacingScale) {
                        ForEach(Array(ranges.enumerated()), id: \.offset) { offset, range in
                            BarChartCell(
                                id: offset,
                                height: geometry.size.height,
                                range: range,
                                overallRange: overallRange,
                                style: style
                            )
                            .transition(transition)
                            .animation(chartAnimation)
                            .opacity(!selecting || selectedID == offset ? 1 : 0.33)
                        }
                    }
                }
            } //: ZStack
            .foreground(content: foreground)
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onChanged { value in
                        let new = Int(
                            value.location.x / geometry.size.width * CGFloat(ranges.count)
                        )
                        if new != selectedID {
                            selectedID = new
                        }
                    }
                    .onEnded { _ in
                        selectedID = -1
                    }
            )
        }
    }

    private var selecting: Bool {
        Range<Int>(uncheckedBounds: (0, ranges.count)).contains(selectedID)
    }

    private func indicatorYOffset(with geometry: GeometryProxy) -> CGFloat {
        let overall = overallRange
        let numerator = indicator! - overall.lowerBound
        let denominator = overall.magnitude
        return geometry.size.height * CGFloat(0.5 - numerator / denominator)
    }

    private static func overallRange(of ranges: [Range<Double>],
                                     indicator: Double?) -> Range<Double> {
        let all = ranges.overallRange()
        if let indicator = indicator {
            return Range(uncheckedBounds: (min(all.lowerBound, indicator),
                                           max(all.upperBound, indicator)))
        } else {
            return all
        }
    }

    private static func floatingRanges(origin: Double,
                                       adding intervals: [Double]) -> [Range<Double>] {
        var bounds = [origin]
        for value in intervals {
            bounds.append(bounds.last! + value)
        }
        var ranges: [Range<Double>] = []
        ranges.reserveCapacity(intervals.count)
        for i in Range(uncheckedBounds: (0, bounds.count - 1)) {
            if bounds[i] < bounds[i+1] {
                ranges.append(Range(uncheckedBounds: (bounds[i], bounds[i+1])))
            } else {
                ranges.append(Range(uncheckedBounds: (bounds[i+1], bounds[i])))
            }
        }
        return ranges
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChartPreview()
    }
}

fileprivate struct BarChartPreview: View {
    @State var id: Int = -1
    let values: [Range<Double>] = [
        -1..<1, -6..<3, 1..<5, -7..<6, -6..<7, 0..<9, 0..<14,
    ]
    var body: some View {
        VStack {
//            BarChart(selectedID: $id, ranges: values, indicator: 6, f)
            BarChart(selectedID: $id, ranges: values, indicator: 7) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.red, Color.yellow]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            }
            .squareFrame(350)
            .background(Color.white.shadow(radius: 5))
        }
    }
}
