//
//  MUTextField.swift
//  
//
//  Created by Loïc GRIFFIE on 01/07/2020.
//

import SwiftUI

public struct MUTextFieldConfiguration {
    public let title: MUTextConfiguration
    public let placeholder: MUTextConfiguration
    public let text: MUTextConfiguration
    public let line: MUTextFieldLineConfiguration
    public let spacing: CGFloat

    public init(title: MUTextConfiguration = .init(font: .title),
                placeholder: MUTextConfiguration = .init(font: .subheadline),
                text: MUTextConfiguration = .init(font: .subheadline),
                line: MUTextFieldLineConfiguration = .init(),
                spacing: CGFloat = 8) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.line = line
        self.spacing = spacing
    }
}

public struct MUTextFieldLineConfiguration {
    public let thickness: CGFloat
    public let color: Color

    public init(thickness: CGFloat = 1.0, color: Color = .black) {
        self.thickness = thickness
        self.color = color
    }
}

public struct MUTextField: View {
    public let configuration: MUTextFieldConfiguration
    
    public let title: String
    public let placeholder: String
    public let text: Binding<String>

    public init(with title: String, placeholder: String, text: Binding<String>, configuration: MUTextFieldConfiguration = .init()) {
        self.title = title
        self.placeholder = placeholder
        self.text = text

        self.configuration = configuration
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(configuration.title.font)
                .fontWeight(configuration.title.fontWeight)
                .foregroundColor(configuration.title.color)
                .padding(.bottom, configuration.spacing)

            Text(placeholder)
                .font(configuration.placeholder.font)
                .fontWeight(configuration.placeholder.fontWeight)
                .foregroundColor(configuration.placeholder.color)

            Rectangle()
                .frame(height: configuration.line.thickness)
                .foregroundColor(configuration.line.color)
        }.padding()
    }
}

struct MUTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUTextField(with: "Numéro de série",
                        placeholder: "0001-0178",
                        text: .constant(""),
                        configuration: .init(title: .init(color: .black),
                                             placeholder: .init(color: .green)))
                .colorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
