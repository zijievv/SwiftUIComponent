//
//  Rang+Extension.swift
//
//
//  Created by zijie vv on 02/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

public extension Range where Bound: BinaryFloatingPoint {
    var magnitude: Bound { upperBound - lowerBound }
}
