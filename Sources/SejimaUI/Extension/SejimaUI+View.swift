//
//  SejimaUI+View.swift
//  
//
//  Created by Loïc GRIFFIE on 27/08/2020.
//

import SwiftUI

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - FillParent view modifier

public enum FillParent { case horizontally, vertically, fill }

public extension View {
    func fillParent(_ orientation: FillParent = .fill) -> some View {
        switch orientation {
        case .horizontally:
            return modifier(FillHorizontallyModifier()).eraseToAnyView()
        case .vertically:
            return modifier(FillVerticallyModifier()).eraseToAnyView()
        case .fill:
            return modifier(FillParentModifier()).eraseToAnyView()
        }
    }
}

private struct FillHorizontallyModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

private struct FillVerticallyModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
    }
}

private struct FillParentModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                content
                Spacer()
            }
            Spacer()
        }
    }
}
