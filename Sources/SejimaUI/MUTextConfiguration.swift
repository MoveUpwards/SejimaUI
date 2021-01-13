//
//  MUTextConfiguration.swift
//  
//
//  Created by Loic Griffie on 07/07/2020.
//

import SwiftUI

public struct MUTextConfiguration {
    public let text: String
    public let color: Color
    public let font: Font
    public let fontWeight: Font.Weight

    public init(text: String = "",
                color: Color = .black,
                font: Font = .headline,
                fontWeight: Font.Weight = .regular) {
        self.text = text
        self.color = color
        self.font = font
        self.fontWeight = fontWeight
    }
}
