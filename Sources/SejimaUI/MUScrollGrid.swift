//
//  MUScrollGrid.swift
//  
//
//  Created by Mac on 13/08/2020.
//

import SwiftUI

public struct MUScrollGrid<Content: View>: View {
    @Binding var gridSize: CGSize

    private let content: () -> Content
    private let axis: Axis.Set
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let girdItems: [GridItem]
    private let spacing: CGFloat?

    public init(_ axis: Axis.Set = .vertical,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                itemsCount: Int = 1,
                spacing: CGFloat? = nil,
                gridSize: Binding<CGSize> = .constant(.zero),
                @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.girdItems = Array(repeating: GridItem(.flexible()), count: itemsCount)
        self.spacing = spacing
        self.content = content
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self._gridSize = gridSize
    }

    public var body: some View {
        ScrollView(axis, showsIndicators: false) {
            MUGrid(axis,
                   verticalAlignment: verticalAlignment,
                   horizontalAlignment: horizontalAlignment,
                   girdItems: girdItems,
                   spacing: spacing) {
                content()
                    .readSize { newSize in gridSize = newSize }
            }
        }
    }
}
