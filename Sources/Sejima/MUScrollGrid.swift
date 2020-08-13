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

    public init(_ axis: Axis.Set = .vertical, itemsCount: Int = 1, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        girdItems = Array(repeating: GridItem(.flexible()), count: itemsCount)
        self.content = content
    }

    public var body: some View {
        ScrollView(axis) {
            MUGrid(axis, girdItems: girdItems) {
                content()
            }
        }
    }
}
