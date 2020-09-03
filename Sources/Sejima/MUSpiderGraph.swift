//
//  SpiderGraph.swift
//  tibtop-b2b
//
//  Created by Loïc GRIFFIE on 03/09/2020.
//  Copyright © 2020 VBKAM. All rights reserved.
//

import SwiftUI

public enum RayCase: String, CaseIterable {
    case intelligence = "Intelligence"
    case funny = "Funny"
    case empathy = "Empathy"
    case veracity = "Veracity"
    case selflessness = "Selflessness"
    case authenticity = "Authenticity"
    case boldness = "Boldness"
}

public struct Ray: Identifiable {
    public let id = UUID()
    public let label: String
    public let maxValue: Double
    public let rayCase: RayCase

    public init(maxValue: Double, rayCase: RayCase) {
        self.rayCase = rayCase
        self.label = rayCase.rawValue
        self.maxValue = maxValue
    }
}

public struct RayEntry {
    public let rayCase: RayCase
    public let value: Double

    public init(rayCase: RayCase, value: Double) {
        self.rayCase = rayCase
        self.value = value
    }
}

public struct DataPoint: Identifiable {
    public let id = UUID()
    public let entries: [RayEntry]
    public let color: Color

    public init(entries: [RayEntry], color: Color) {
        self.entries = entries
        self.color = color
    }
}

public struct MUSpiderGraph: View {
    public let mainColor: Color
    public let labelColor: Color
    public let center: CGPoint
    public let labelWidth: CGFloat = 70
    public let size: CGFloat
    public let dividers: Int
    public let dimensions: [Ray]
    public let datas: [DataPoint]

    public init(width: CGFloat,
                mainColor: Color = .white,
                labelColor: Color = Color.white.opacity(0.7),
         dividers: Int,
         dimensions: [Ray],
         datas: [DataPoint]) {
        self.size = width
        self.center = CGPoint(x: width / 2, y: width / 2)
        self.mainColor = mainColor
        self.labelColor = labelColor
        self.dividers = dividers
        self.dimensions = dimensions
        self.datas = datas
    }

    @State private var showLabels = false
    @State private var padding = CGFloat(50)

    private func drawLabels() -> some View {
       ForEach(0..<dimensions.count) {
            Text(dimensions[$0].rayCase.rawValue)
                .font(.system(size: 10))
                .foregroundColor(labelColor)
                .frame(width: labelWidth)
                .rotationEffect(
                    .degrees(
                        (CGFloat.degAngleFromFraction(numerator: $0, denominator: dimensions.count) > 90 &&
                            CGFloat.degAngleFromFraction(numerator: $0, denominator: dimensions.count) < 270) ? 180 : 0
                    ))
                .background(Color.clear)
                .offset(x: (size - (padding)) / 2)
                .rotationEffect(
                    .radians(
                        Double(CGFloat.radAngleFromFraction(numerator: $0, denominator: dimensions.count))
                    )
                )
        }
    }

    private func computePosition(at index: Int) -> CGPoint {
        let angle = CGFloat.radAngleFromFraction(numerator: index, denominator: dimensions.count)
        return .init(x: (size - (padding + labelWidth)) / 2 * cos(angle),
                     y: (size - (padding + labelWidth)) / 2 * sin(angle))
    }

    private func drawBranches(color: Color, style: StrokeStyle) -> some View {
        Path { path in
            (0..<dimensions.count).forEach { idx in
                let point = computePosition(at: idx)
                path.move(to: center)
                path.addLine(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
            }
        }
        .stroke(color, style: style)
    }

    private func drawBorder(color: Color, style: StrokeStyle) -> some View {
        Path { path in
            (0..<dimensions.count + 1).forEach { idx in
                let point = computePosition(at: idx)

                if idx == 0 {
                    path.move(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
                } else {
                    path.addLine(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
                }
            }
        }
        .stroke(color, style: style)
    }

    private func drawDividers(color: Color, style: StrokeStyle) -> some View {
        ForEach(0..<dividers) { index in
            Path { path in
                (0..<dimensions.count + 1).forEach { idx in
                    let angle = CGFloat.radAngleFromFraction(numerator: idx, denominator: dimensions.count)
                    let width = (self.size - (padding + labelWidth)) / 2
                    let size = (width * (CGFloat(index + 1) / CGFloat(dividers + 1)))
                    let position = CGPoint(x: size * cos(angle), y: size * sin(angle))

                    if idx == 0 {
                        path.move(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    }
                }
            }
            .stroke(color, style: style)
        }
    }

    private func drawPolygon(_ data: DataPoint, style: StrokeStyle) -> some View {
        ForEach(0..<data.entries.count) { _ -> AnyView in
            let path = Path { path in
                (0..<dimensions.count + 1).forEach { idx in
                    let dimension = dimensions[idx == dimensions.count ? 0 : idx]
                    let value: Double = {
                        for ray in data.entries where dimension.rayCase == ray.rayCase { return ray.value }
                        return 0
                    }()

                    let width = (self.size - (padding + labelWidth)) / 2
                    let angle = CGFloat.radAngleFromFraction(numerator: idx == dimensions.count ? 0 : idx,
                                                             denominator: dimensions.count)
                    let size = (width * (CGFloat(value) / CGFloat(dimension.maxValue)))
                    let position = CGPoint(x: size * cos(angle), y: size * sin(angle))

                    if idx == 0 {
                        path.move(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    }
                }
            }

            return AnyView(
                ZStack {
                    path.stroke(data.color, style: style)
                    path.foregroundColor(data.color).opacity(0.2)
                }
            )
        }
    }

    public var body: some View {
        ZStack {
            Group {
                drawBranches(color: mainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                drawBorder(color: mainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                drawDividers(color: mainColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                drawLabels()
            }

            ForEach(datas) { data in
                drawPolygon(data, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
    }
}

struct SpiderGraph_Previews: PreviewProvider {
    static let dimensions = [
        Ray(maxValue: 10, rayCase: .authenticity),
        Ray(maxValue: 10, rayCase: .boldness),
        Ray(maxValue: 10, rayCase: .empathy),
        Ray(maxValue: 10, rayCase: .intelligence),
        Ray(maxValue: 10, rayCase: .funny),
        Ray(maxValue: 10, rayCase: .selflessness)
    ]

    static let datas = [
        DataPoint(entries: dimensions.map {
            RayEntry(rayCase: $0.rayCase, value: Double.random(in: 0..<10))
        }, color: .green)
    ]

    static var previews: some View {
        MUSpiderGraph(width: 370,
                    mainColor: .accentColor,
                    labelColor: .accentColor,
                    dividers: 5,
                    dimensions: dimensions,
                    datas: datas)
            .previewLayout(.sizeThatFits)
    }
}
