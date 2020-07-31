//
//  MUButton.swift
//  
//
//  Created by Loic Griffie on 07/07/2020.
//

import SwiftUI

public struct MUButtonConfiguration {
    public let title: MUTextConfiguration
    public let cornerRadius: CGFloat
    public let color: Color

    public init(title: MUTextConfiguration = .init(font: .callout),
                cornerRadius: CGFloat = 4,
                color: Color = .orange) {
        self.title = title
        self.cornerRadius = cornerRadius
        self.color = color
    }
}

public struct MUButton: View {
    public let configuration: MUButtonConfiguration
    public let action: () -> Void

    public init(configuration: MUButtonConfiguration = .init(), action: @escaping () -> Void) {
        self.configuration = configuration
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            Spacer()
            Text(configuration.title.text.uppercased())
                .font(configuration.title.font)
                .fontWeight(configuration.title.fontWeight)
                .foregroundColor(configuration.title.color)
                .padding(10)
            Spacer()
        })
        .background(configuration.color)
        .cornerRadius(configuration.cornerRadius)
    }
}

struct MUButton_Previews: PreviewProvider {
    static var previews: some View {
        MUButton(configuration: .init(), action: {})
    }
}
