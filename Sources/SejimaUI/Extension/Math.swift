//
//  Math.swift
//  tibtop-b2b
//
//  Created by Loïc GRIFFIE on 03/09/2020.
//  Copyright © 2020 VBKAM. All rights reserved.
//

import SwiftUI

public extension CGFloat {
    var deg2rad: CGFloat {
        self * .pi / 180
    }

    static func radAngleFromFraction(numerator: Int, denominator: Int) -> CGFloat {
        360 * (CGFloat((numerator)) / CGFloat(denominator)).deg2rad
    }

    static func degAngleFromFraction(numerator: Int, denominator: Int) -> CGFloat {
        360 * (CGFloat((numerator)) / CGFloat(denominator))
    }
}
