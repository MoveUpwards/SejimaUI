//
//  MUGrid.swift
//  
//
//  Created by Mac on 13/08/2020.
//

import SwiftUI

public struct MUGrid<Content: View>: View {
    private let content: () -> Content
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let axis: Axis.Set
    private let girdItems: [GridItem]
    private let spacing: CGFloat?

    public init(_ axis: Axis.Set = .vertical,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                girdItems: [GridItem],
                spacing: CGFloat? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.girdItems = girdItems
        self.spacing = spacing
        self.content = content
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
    }

    public var body: some View {
        if axis == .horizontal {
            return LazyHGrid(rows: girdItems, alignment: verticalAlignment, spacing: spacing, content: content)
                .eraseToAnyView()
        } else {
            return LazyVGrid(columns: girdItems, alignment: horizontalAlignment, spacing: spacing, content: content)
                .eraseToAnyView()
        }
    }
}
