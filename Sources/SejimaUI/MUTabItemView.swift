//
//  MUTabItemView.swift
//  
//
//  Created by Damien Noël Dubuisson on 14/01/2021.
//

import SwiftUI

public struct MUTabItemView<Content: View> {
    public let action: (Int) -> Void
    public let item: () -> Content

    public init(action: @escaping (Int) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.item = content
    }
}

extension MUTabItemView {
    public func action(at index: Int) {
        action(index)
    }

    public func toView() -> AnyView {
        item().eraseToAnyView()
    }
}
