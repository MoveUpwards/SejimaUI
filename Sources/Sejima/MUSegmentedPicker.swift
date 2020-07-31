//
//  SegmentedPicker.swift
//  
//
//  Created by Loïc GRIFFIE on 31/07/2020.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

struct SizeAwareViewModifier: ViewModifier {
    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

struct MUSegmentedPickerConfiguration {
    let activeSegmentColor: Color = .orange
    let backgroundColor: Color = .black
    let shadowColor: Color = Color.black.opacity(0.2)
    let textColor: Color = .white
    let selectedTextColor: Color = .accentColor

    let textFont: Font = .caption
    
    let segmentCornerRadius: CGFloat = 12
    let shadowRadius: CGFloat = 4
    let segmentXPadding: CGFloat = 16
    let segmentYPadding: CGFloat = 8
    let pickerPadding: CGFloat = 4
    
    let animationDuration: Double = 0.1
}

struct MUSegmentedPicker: View {
    let configuration: MUSegmentedPickerConfiguration
    
    // Stores the size of a segment, used to create the active segment rect
    @State private var segmentSize: CGSize = .zero
    // Rounded rectangle to denote active segment
    private var activeSegmentView: AnyView {
        // Don't show the active segment until we have initialized the view
        // This is required for `.animation()` to display properly, otherwise the animation will fire on init
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        
        return
            RoundedRectangle(cornerRadius: configuration.segmentCornerRadius)
                .foregroundColor(configuration.activeSegmentColor)
                .shadow(color: configuration.shadowColor, radius: configuration.shadowRadius)
                .frame(width: segmentSize.width, height: segmentSize.height)
                .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
                .animation(Animation.linear(duration: configuration.animationDuration))
                .eraseToAnyView()
    }
    
    @Binding private var selection: Int
    private let items: [String]
    
    init(configuration: MUSegmentedPickerConfiguration, items: [String], selection: Binding<Int>) {
        self.configuration = configuration
        self._selection = selection
        self.items = items
    }
    
    var body: some View {
        // Align the ZStack to the leading edge to make calculating offset on activeSegmentView easier
        ZStack(alignment: .leading) {
            // activeSegmentView indicates the current selection
            activeSegmentView
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    getSegmentView(for: index)
                }
            }
        }
        .padding(configuration.pickerPadding)
        .background(configuration.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: configuration.segmentCornerRadius))
    }

    // Helper method to compute the offset based on the selected index
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(selection) * (segmentSize.width + configuration.segmentXPadding / 2)
    }

    // Gets text view for the segment
    private func getSegmentView(for index: Int) -> some View {
        guard index < items.count else { return EmptyView().eraseToAnyView() }
        
        let isSelected = selection == index
        return
            Text(items[index])
                // Dark test for selected segment
                .foregroundColor(isSelected ? configuration.selectedTextColor: configuration.textColor)
                .lineLimit(1)
                .padding(.vertical, configuration.segmentYPadding)
                .padding(.horizontal, configuration.segmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity)
                // Watch for the size of the
                .modifier(SizeAwareViewModifier(viewSize: $segmentSize))
                .onTapGesture { onItemTap(index: index) }
                .eraseToAnyView()
    }

    // On tap to change the selection
    private func onItemTap(index: Int) {
        guard index < items.count else { return }
        self.selection = index
    }
}


struct PreviewView: View {
    @State var selection: Int = 0
    private let items: [String] = ["M", "T", "W", "T", "F"]
    
    var body: some View {
        MUSegmentedPicker(configuration: MUSegmentedPickerConfiguration(), items:items, selection: $selection)
            .padding()
    }
}
