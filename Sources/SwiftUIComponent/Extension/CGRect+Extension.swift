//
//  CGRect+Extension.swift
//
//
//  Created by zijie vv on 01/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

extension CGRect {
    var minimum: CGFloat { min(width, height) }
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}
