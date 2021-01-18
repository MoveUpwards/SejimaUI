//
//  MUColor.swift
//  
//
//  Created by Damien Noël Dubuisson on 14/01/2021.
//

import SwiftUI

extension Color {
    public static var random: Color {
        return Color(red: Double(Int.random(in: 0...255))/255.0,
                     green: Double(Int.random(in: 0...255))/255.0,
                     blue: Double(Int.random(in: 0...255))/255.0)
    }
}
