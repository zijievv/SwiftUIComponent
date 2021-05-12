//
//  View+Extension.swift
//
//
//  Created by zijie vv on 29/04/2021.
//  Copyright © 2021 zijie vv. All rights reserved.
//
//  ================================================================================================
//

import SwiftUI

extension View {
    @inlinable
    func squareFrame(_ size: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: size, height: size, alignment: alignment)
    }

    func foreground<V: View>(_ content: V) -> some View {
        self.foregroundColor(.clear)
            .overlay(content.mask(self))
    }

    @ViewBuilder func `if`<V>(
        _ condition: @autoclosure () -> Bool,
        transform: (Self) -> V
    ) -> some View where V: View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
