//
//  Collection+Extension.swift
//
//
//  Created by zijie vv on 02/05/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

extension Collection {
    func overallRange<T>() -> Range<T> where Element == Range<T>, T: AdditiveArithmetic {
        guard let lower = self.lazy.map(\.lowerBound).min(),
              let upper = self.lazy.map(\.upperBound).max() else {
            return Range<T>(uncheckedBounds: (.zero, .zero))
        }
        return Range(uncheckedBounds: (lower, upper))
    }
}
