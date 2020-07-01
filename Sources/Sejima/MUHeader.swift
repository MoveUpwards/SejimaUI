//
//  MUHeader.swift
//  
//
//  Created by Loïc GRIFFIE on 01/07/2020.
//

import SwiftUI

public struct MUHeaderConfiguration {
    public let alignment: TextAlignment

    public let title: MUHeaderTextConfiguration
    public let subtitle: MUHeaderTextConfiguration

    public let spacing: CGFloat

    public static var shared: MUHeaderConfiguration {
        .init()
    }

    public init(alignment: TextAlignment = .leading,
                title: MUHeaderTextConfiguration = .init(font: .title),
                subtitle: MUHeaderTextConfiguration = .init(font: .subheadline),
                spacing: CGFloat = 8) {
        self.alignment = alignment
        self.title = title
        self.subtitle = subtitle
        self.spacing = spacing
    }

    internal var titleAlignment: HorizontalAlignment {
        switch alignment {
        case .center:
            return .center
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }

    internal var subtitleAlignment: TextAlignment {
        switch alignment {
        case .center:
            return .center
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

public struct MUHeaderTextConfiguration {
    public let color: Color
    public let font: Font

    public init(color: Color = .black, font: Font) {
        self.color = color
        self.font = font
    }
}

public struct MUHeader: View {
    public let title: String
    public let subtitle: String

    public let configuration: MUHeaderConfiguration

    public init(title: String = "", subtitle: String = "", configuration: MUHeaderConfiguration = .shared) {
        self.title = title
        self.subtitle = subtitle

        self.configuration = configuration
    }

    public var body: some View {
        VStack(alignment: configuration.titleAlignment) {
            if !title.isEmpty {
                Text(title)
                    .foregroundColor(configuration.title.color)
                    .font(configuration.title.font)
                    .lineLimit(1)
                    .padding(.bottom, title.isEmpty || subtitle.isEmpty ? 0 : configuration.spacing)
            }

            if !subtitle.isEmpty {
                Text(subtitle)
                    .foregroundColor(configuration.subtitle.color)
                    .font(configuration.subtitle.font)
                    .lineLimit(nil)
                    .multilineTextAlignment(configuration.subtitleAlignment)
            }
        }
    }
}

struct MUHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUHeader(title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.",
                     configuration: MUHeaderConfiguration(alignment: .center,
                                                          title: MUHeaderTextConfiguration(color: .green, font: .title),
                                                          subtitle: MUHeaderTextConfiguration(color: .blue, font: .subheadline),
                                                          spacing: 0)).previewLayout(.sizeThatFits)

            MUHeader(title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.",
                     configuration: MUHeaderConfiguration(alignment: .leading)).previewLayout(.sizeThatFits)

            MUHeader(title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.",
                     configuration: MUHeaderConfiguration(alignment: .trailing)).previewLayout(.sizeThatFits)

            MUHeader(title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit.",
                     configuration: MUHeaderConfiguration(alignment: .center)).previewLayout(.sizeThatFits)

            MUHeader(title: "Lorem ipsum dolor",
                     subtitle: "",
                     configuration: MUHeaderConfiguration(alignment: .center)).previewLayout(.sizeThatFits)

            MUHeader(title: "",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.",
                     configuration: MUHeaderConfiguration(alignment: .center)).previewLayout(.sizeThatFits)

            MUHeader().previewLayout(.sizeThatFits)
        }
    }
}
