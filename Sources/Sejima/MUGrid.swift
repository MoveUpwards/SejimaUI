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

    public init(_ axis: Axis.Set = .vertical, girdItems: [GridItem], @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.girdItems = girdItems
        self.content = content
    }

    public var body: some View {
        if axis == .horizontal {
            return LazyHGrid(rows: girdItems, spacing: 16, content: content).padding(.vertical).eraseToAnyView()
        } else {
            return LazyVGrid(columns: girdItems, spacing: 16, content: content).padding(.horizontal).eraseToAnyView()
        }
    }
}
