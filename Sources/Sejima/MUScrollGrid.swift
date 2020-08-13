//
//  MUScrollGrid.swift
//  
//
//  Created by Mac on 13/08/2020.
//

import SwiftUI

public struct MUScrollGrid<Content: View>: View {
    private let content: () -> Content
    private let axis: Axis.Set
    private let girdItems: [GridItem]
    private let spacing: CGFloat?

    public init(_ axis: Axis.Set = .vertical, itemsCount: Int = 1, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.girdItems = Array(repeating: GridItem(.flexible()), count: itemsCount)
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        ScrollView(axis, showsIndicators: false) {
            MUGrid(axis, girdItems: girdItems, spacing: spacing) {
                content()
            }
        }
    }
}
