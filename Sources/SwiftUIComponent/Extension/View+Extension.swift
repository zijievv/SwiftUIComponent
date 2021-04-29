//
//  SwiftUIView.swift
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
}
