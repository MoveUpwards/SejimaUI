//
//  SegmentedPicker.swift
//  
//
//  Created by Loïc GRIFFIE on 31/07/2020.
//

import SwiftUI

struct SizeAwareViewModifier: ViewModifier {
    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .readSize(onChange: { if self.viewSize != $0 { self.viewSize = $0 } })
    }
}

public struct MUSegmentedPickerConfiguration {
    public let activeSegmentColor: Color
    public let backgroundColor: Color
    public let shadowColor: Color
    public let textColor: Color
    public let selectedTextColor: Color

    public let textFont: Font

    public let segmentCornerRadius: CGFloat
    public let shadowRadius: CGFloat
    public let segmentXPadding: CGFloat
    public let segmentYPadding: CGFloat
    public let pickerPadding: CGFloat

    public let animationDuration: Double

    public init(activeSegmentColor: Color = .orange,
                backgroundColor: Color = .black,
                shadowColor: Color = Color.black.opacity(0.2),
                textColor: Color = .white,
                selectedTextColor: Color = .accentColor,
                textFont: Font = .caption,
                segmentCornerRadius: CGFloat = 12,
                shadowRadius: CGFloat = 4,
                segmentXPadding: CGFloat = 16,
                segmentYPadding: CGFloat = 8,
                pickerPadding: CGFloat = 4,
                animationDuration: Double = 0.1) {
        self.activeSegmentColor = activeSegmentColor
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.textFont = textFont
        self.segmentCornerRadius = segmentCornerRadius
        self.shadowRadius = shadowRadius
        self.segmentXPadding = segmentXPadding
        self.segmentYPadding = segmentYPadding
        self.pickerPadding = pickerPadding
        self.animationDuration = animationDuration
    }
}

public struct MUSegmentedPicker: View {
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
            RoundedRectangle(cornerRadius: configuration.segmentCornerRadius - configuration.pickerPadding / 2)
                .foregroundColor(configuration.activeSegmentColor)
                .shadow(color: configuration.shadowColor, radius: configuration.shadowRadius)
                .frame(width: segmentSize.width, height: segmentSize.height)
                .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
                .animation(Animation.linear(duration: configuration.animationDuration))
                .eraseToAnyView()
    }
    
    @Binding private var selection: Int
    private let items: [String]
    
    public init(configuration: MUSegmentedPickerConfiguration = .init(), items: [String], selection: Binding<Int>) {
        self.configuration = configuration
        self._selection = selection
        self.items = items
    }
    
    public var body: some View {
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
        CGFloat(selection) * (segmentSize.width + configuration.pickerPadding * 2)
    }

    // Gets text view for the segment
    private func getSegmentView(for index: Int) -> some View {
        guard index < items.count else { return EmptyView().eraseToAnyView() }
        
        let isSelected = selection == index
        return
            Text(LocalizedStringKey(items[index]))
                .font(configuration.textFont)
                .foregroundColor(isSelected ? configuration.selectedTextColor: configuration.textColor)
                .lineLimit(1)
                .padding(.vertical, configuration.segmentYPadding)
                .padding(.horizontal, configuration.segmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity)
                .modifier(SizeAwareViewModifier(viewSize: $segmentSize))
                .onTapGesture { onItemTap(index: index) }
                .eraseToAnyView()
    }

    // On tap to change the selection
    private func onItemTap(index: Int) {
        guard index < items.count else { return }
        selection = index
    }
}

struct MUSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        MUSegmentedPicker(items:  ["M", "T", "W", "T", "F"], selection: .constant(3))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
