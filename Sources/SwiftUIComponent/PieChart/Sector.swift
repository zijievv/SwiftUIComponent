//
//  Sector.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

public struct Sector: Shape {
    private let start: Angle
    private let end: Angle
    private let clockwise: Bool

    public init(from startAngle: Angle, to endAngle: Angle, clockwise: Bool = false) {
        start = startAngle
        end = endAngle
        self.clockwise = clockwise
    }

    public func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let path = Path { path in
            path.move(to: center)
            path.addLine(to: center)
            path.addArc(
                center: center,
                radius: min(rect.width, rect.height) / 2,
                startAngle: start,
                endAngle: end,
                clockwise: clockwise
            )
            path.closeSubpath()
        }
        return path
    }
}

struct Sector_Previews: PreviewProvider {
    static var previews: some View {
        Sector(from: Angle(degrees: 0), to: Angle(degrees: -90), clockwise: true)
    }
}
