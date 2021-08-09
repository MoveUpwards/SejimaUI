//
//  MUHeader.swift
//  
//
//  Created by Loïc GRIFFIE on 01/07/2020.
//

import SwiftUI

public struct MUHeaderConfiguration {
    public let alignment: TextAlignment

    public let title: MUTextConfiguration
    public let subtitle: MUTextConfiguration

    public let spacing: CGFloat

    public init(alignment: TextAlignment = .leading,
                title: MUTextConfiguration = .init(font: .title),
                subtitle: MUTextConfiguration = .init(font: .subheadline),
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

public struct MUHeader: View {
    public let configuration: MUHeaderConfiguration
    public let title: String
    public let subtitle: String
    
    public init(configuration: MUHeaderConfiguration = .init(), title: String = "", subtitle: String = "") {
        self.configuration = configuration
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: configuration.titleAlignment) {
            if !title.isEmpty {
                Text(LocalizedStringKey(title))
                    .foregroundColor(configuration.title.color)
                    .font(configuration.title.font)
                    .lineLimit(1)
                    .padding(.bottom, title.isEmpty || subtitle.isEmpty ? 0 : configuration.spacing)
            }

            if !subtitle.isEmpty {
                Text(LocalizedStringKey(subtitle))
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
            MUHeader(
                configuration: MUHeaderConfiguration(alignment: .center,
                                                     title: .init(color: .green, font: .title),
                                                     subtitle: .init(color: .blue, font: .subheadline),
                                                     spacing: 0),
                title: "Lorem ipsum dolor",
                subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.").previewLayout(.sizeThatFits)
            
            MUHeader(configuration: .init(),
                     title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.").previewLayout(.sizeThatFits)
            
            MUHeader(configuration: .init(alignment: .trailing),
                     title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.").previewLayout(.sizeThatFits)
            
            MUHeader(configuration: .init(alignment: .center),
                     title: "Lorem ipsum dolor",
                     subtitle: "Lorem ipsum dolor sit.").previewLayout(.sizeThatFits)
            
            MUHeader(configuration: .init(alignment: .center),
                     title: "Lorem ipsum dolor",
                     subtitle: "").previewLayout(.sizeThatFits)
            
            MUHeader(configuration: .init(alignment: .center),
                     title: "",
                     subtitle: "Lorem ipsum dolor sit, consectetur adipiscing elit. Fusce faucibus sit amet lectus vitae porttitor.").previewLayout(.sizeThatFits)
            
            MUHeader().previewLayout(.sizeThatFits)
        }
    }
}
