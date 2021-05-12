//
//  Color+Extension.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

extension Color {
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, o: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self)
            .getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }

    func reduceOpaque(_ value: Double = 0.5) -> Color {
        let rgbo = components
        return Color(red: rgbo.r.double,
                     green: rgbo.g.double,
                     blue: rgbo.b.double,
                     opacity: rgbo.o.double - value)
    }
}
