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
    private let startAngle: Angle
    private let endAngle: Angle
    private let clockwise: Bool

    public init(startAngle: Angle, endAngle: Angle, clockwise: Bool = false) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.clockwise = clockwise
    }

    public func path(in rect: CGRect) -> Path {
        let radius = rect.minimum / 2
        let center = rect.center

        let path = Path { path in
            path.move(to: center)
            path.addLine(to: center)
            path.addArc(center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: clockwise)
            path.closeSubpath()
        }

        return path
    }
}

struct Sector_Previews: PreviewProvider {
    static var previews: some View {
        Sector(startAngle: 0.degrees, endAngle: -90.degrees, clockwise: true)
    }
}
