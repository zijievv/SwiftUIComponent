//
//  Collection+Extension.swift
//
//
//  Created by zijie vv on 02/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

public extension Collection {
    func overallRange<Value>() -> Range<Value>
        where Element == Range<Value>, Value: AdditiveArithmetic {
        guard !isEmpty else { return Range<Value>(uncheckedBounds: (.zero, .zero)) }
        let lower = self.lazy.map { $0.lowerBound }.min()!
        let upper = self.lazy.map { $0.upperBound }.max()!
        return lower..<upper
    }
}
