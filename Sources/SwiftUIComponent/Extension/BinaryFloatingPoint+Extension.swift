//
//  BinaryFloatingPoint+Extension.swift
//
//
//  Created by zijie vv on 29/04/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

extension BinaryFloatingPoint {
    @inlinable var degrees: Angle { Angle.degrees(Double(self)) }
    @inlinable var radians: Angle { Angle.radians(Double(self)) }
}
