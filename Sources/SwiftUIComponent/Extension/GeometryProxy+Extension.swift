//
//  GeometryProxy+Extension.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

public extension GeometryProxy {
    @inlinable
    var minimum: CGFloat {
        min(self.size.width, self.size.height)
    }

    var center: CGPoint {
        let rect = frame(in: .local)
        return CGPoint(x: rect.midX, y: rect.midY)
    }
}
