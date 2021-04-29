//
//  RingProgressView.swift
//
//
//  Created by zijie vv on 29/04/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

struct RingProgressView: View {
    private let progress: Double
    private let colors: [Color]
    private let backgroundColor: Color
    private let lineWidth: CGFloat
    private let startAngle: Angle
    private let clockwise: Bool

    /// Creates a ring progress view.
    ///
    /// - Parameters:
    ///   - progress: The progress.
    ///   - startColor: The color at the beginning of the angula gradient.
    ///   - endColor: The color at the end of the angula gradient.
    ///   - backgroundColor: The color of the background ring of the ring progress view.
    ///   - lineWidth: The width of the ring.
    ///   - startAngle: The start angle of the progress arc.
    ///   - clockwise: The clockwise.
    init(
        progress: Double,
        startColor: Color,
        endColor: Color,
        backgroundColor: Color,
        lineWidth: CGFloat,
        startAngle: Angle = -90.degrees,
        clockwise: Bool = false
    ) {
        self.progress = progress
        self.colors = [startColor, endColor]
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
        self.startAngle = startAngle
        self.clockwise = clockwise
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background ring
                Circle()
                    .stroke(backgroundColor.opacity(0.1), style: strokeStyle)
                // The progress arc
                Circle()
                    .trim(to: CGFloat(progress != 0 ? progress : .leastNonzeroMagnitude))
                    .stroke(strokeGradient(with: geometry), style: strokeStyle)

                endCover(with: geometry)
                    .opacity(progress > 0.55 ? 1 : 0)
            }
            .padding(lineWidth / 2)
        }
        .rotation3DEffect(clockwise ? 180.degrees : 0.degrees, axis: (1, 0, 0))
        .rotationEffect(startAngle)
    }

    private var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: lineWidth, lineCap: .round)
    }

    private func radius(with geometry: GeometryProxy) -> CGFloat {
        (min(geometry.size.width, geometry.size.height) - lineWidth) / 2
    }

    private func strokeGradient(with geometry: GeometryProxy) -> AngularGradient {
        let declination: Angle = progress > 0.2 ?
            0.degrees : asin(lineWidth / 2 / radius(with: geometry)).radians * 2

        return AngularGradient(gradient: Gradient(colors: colors),
                               center: .center,
                               startAngle: 0.degrees - declination,
                               endAngle: (progress * 360).degrees + declination)
    }

    private func endCover(with geometry: GeometryProxy) -> some View {
        let shadowCircleDiameter = lineWidth * 0.75
        let rotation: Angle = (progress * 360).degrees - 180.degrees

        return Group {
            // The circle generating shadow
            Circle()
                .trim(from: 0.5, to: 1)
                .squareFrame(shadowCircleDiameter)
                .foregroundColor(colors[1])
                .shadow(color: Color.black.opacity(0.5), radius: shadowCircleDiameter * 0.1,
                        x: 0, y: -shadowCircleDiameter / 2 * 0.6)
            Circle()
                .trim(from: 0.23, to: 0.77)
                .rotationEffect(90.degrees)
                .foregroundColor(colors[1])
                .squareFrame(lineWidth)
        }
        .offset(x: -radius(with: geometry), y: 0)
        .rotationEffect(rotation)
    }
}

struct RingProgressView_Previews: PreviewProvider {
    private struct RPV: View {
        @State var p: Double = 0
        var body: some View {
            VStack {
                Text(formatter.string(from: p as NSNumber)!)
                RingProgressView(progress: p,
                                 startColor: Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
                                 endColor: Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
                                 backgroundColor: .blue,
                                 lineWidth: 50,
                                 startAngle: -90.degrees,
                                 clockwise: false)
                    .frame(width: 300, height: 300, alignment: .center)
                Button(action: {
                    withAnimation { p += 0.05 }
                }) {
                    Text("Plus")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
            }
        }

        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            return formatter
        }()
    }

    static var previews: some View {
        RPV(p: 0)
    }
}
