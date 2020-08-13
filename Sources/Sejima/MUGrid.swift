//
//  MUGrid.swift
//  
//
//  Created by Mac on 13/08/2020.
//

import SwiftUI

public struct MUGrid<Content: View>: View {
    private let content: () -> Content
    private let axis: Axis.Set
    private let girdItems: [GridItem]
    private let spacing: CGFloat?

    public init(_ axis: Axis.Set = .vertical, girdItems: [GridItem], spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.girdItems = girdItems
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        if axis == .horizontal {
            return LazyHGrid(rows: girdItems, spacing: spacing, content: content).padding(.vertical).eraseToAnyView()
        } else {
            return LazyVGrid(columns: girdItems, spacing: spacing, content: content).padding(.horizontal).eraseToAnyView()
        }
    }
}
