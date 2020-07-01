//
//  MUTag.swift
//  
//
//  Created by Loïc GRIFFIE on 01/07/2020.
//

import SwiftUI

public struct MUTagConfiguration {
    public let cornerRadius: CGFloat
    public let lineWidth: CGFloat
    public let borderColor: Color
    public let backgroundColor: Color

    public let title: MUTagTitleConfiguration

    public static var shared: MUTagConfiguration {
        .init()
    }

    public init(cornerRadius: CGFloat = 4,
                lineWidth: CGFloat = 2,
                backgroundColor: Color = .orange,
                borderColor: Color = .green,
                title: MUTagTitleConfiguration = .init()) {
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.title = title
    }
}

public struct MUTagTitleConfiguration {
    public let color: Color
    public let font: Font
    public let fontWeight: Font.Weight
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat

    public init(color: Color = .black,
                font: Font = .caption2,
                fontWeight: Font.Weight = .semibold,
                horizontalPadding: CGFloat = 8,
                verticalPadding: CGFloat = 4) {
        self.color = color
        self.font = font
        self.fontWeight = fontWeight
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
}

struct MUTag: View {
    public let action: (() -> Void)?
    public let title: String

    public let configuration: MUTagConfiguration

    public init(action: (() -> Void)? = nil, title: String = "", configuration: MUTagConfiguration = .shared) {
        self.title = title
        self.action = action

        self.configuration = configuration
    }

    var body: some View {
        Button(action: {
            action?()
        }) {
            Text(title)
                .fontWeight(configuration.title.fontWeight)
                .font(configuration.title.font)
                .foregroundColor(configuration.title.color)
                .padding([.leading, .trailing], configuration.title.horizontalPadding)
                .padding([.top, .bottom], configuration.title.verticalPadding)
                .background(configuration.backgroundColor)
                .cornerRadius(configuration.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .stroke(configuration.borderColor, lineWidth: configuration.lineWidth)
                )
        }.padding(2)
    }
}

struct MUTag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUTag(action: {
                print("Tag tapped1")
            }, title: "my label").previewLayout(.sizeThatFits)
            MUTag(title: "my label".uppercased(), configuration: MUTagConfiguration(backgroundColor: .clear, borderColor: .orange)).previewLayout(.sizeThatFits)
        }
    }
}
