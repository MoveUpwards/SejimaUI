//
//  MUSpiderGraphPolygonShape.swift
//  tibtop-b2b
//
//  Created by Loïc GRIFFIE on 07/09/2020.
//  Copyright © 2020 VBKAM. All rights reserved.
//

import Foundation
import SwiftUI

struct MUSpiderGraphPolygonShape: Shape {
    let center: CGPoint

    var controlPoints: MUSpiderGraphAnimatableVector
    var animatableData: MUSpiderGraphAnimatableVector {
        get { controlPoints }
        set { controlPoints = newValue }
    }

    func point(posX: Double, posY: Double) -> CGPoint {
        CGPoint(x: Double(center.x) + posX, y: Double(center.y) + posY)
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            let first = point(posX: controlPoints.values[0], posY: controlPoints.values[1])
            path.move(to: first)

            var idx = 2
            while idx < controlPoints.values.count - 1 {
                path.addLine(to: point(posX: controlPoints.values[idx], posY: controlPoints.values[idx + 1]))
                idx += 2
            }

            path.addLine(to: first)
        }
    }
}
