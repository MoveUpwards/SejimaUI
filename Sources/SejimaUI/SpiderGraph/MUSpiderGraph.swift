//
//  SpiderGraph.swift
//  tibtop-b2b
//
//  Created by Loïc GRIFFIE on 03/09/2020.
//  Copyright © 2020 VBKAM. All rights reserved.
//

import SwiftUI

public struct SpiderGraphDataSet: Identifiable, Equatable {
    public let id = UUID()
    public let color: Color
    public let values: [Double]

    public init(values: [Double], color: Color) {
        self.values = values
        self.color = color
    }
}

public struct MUSpiderGraph<Content: View>: View {
    private let score: () -> Content

    private let mainColor: Color
    private let padding: CGFloat
    private let dividerCount: Int
    private let maxValue: Double
    private let dimensions: [AnyView]
    private let dimensionsPadding: CGFloat
    private let datas: [SpiderGraphDataSet]

    private func isLeft(at idx: Int) -> Bool {
        (
            CGFloat.degAngleFromFraction(numerator: idx, denominator: dimensions.count) > 90 &&
                CGFloat.degAngleFromFraction(numerator: idx, denominator: dimensions.count) < 270
        )
    }

    public init(datas: [SpiderGraphDataSet],
                padding: CGFloat = 0,
                mainColor: Color = .white,
                dividers: Int = 3,
                maxValue: Double = 1.0,
                dimensions: [AnyView],
                dimensionsPadding: CGFloat = 0,
                capacity: Int = 1,
                @ViewBuilder score: @escaping () -> Content) {
        self.padding = padding
        self.mainColor = mainColor

        self.score = score

        self.dividerCount = dividers
        self.maxValue = maxValue
        self.dimensions = dimensions
        self.dimensionsPadding = dimensionsPadding
        self.datas = datas
    }

    private func drawBranches(style: StrokeStyle, size: CGSize, center: CGPoint) -> some View {
        Path { path in
            (0..<dimensions.count).forEach { idx in
                let point = computePosition(at: idx, size: size)
                path.move(to: center)
                path.addLine(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
            }
        }
        .stroke(mainColor.opacity(0.2), style: style)
    }

    private func drawName(size: CGSize) -> some View {
        ForEach(Array(dimensions.enumerated()), id: \.offset) { idx, element in
            element
                .offset(x: isLeft(at: idx) ? -dimensionsPadding : dimensionsPadding)
                .rotationEffect(.degrees(isLeft(at: idx) ? 180 : 0))
                .offset(x: (size.width - (padding)) / 2)
                .rotationEffect(
                    .radians(
                        Double(CGFloat.radAngleFromFraction(numerator: idx, denominator: dimensions.count))
                    )
                )
         }
    }

    private func drawBorder(style: StrokeStyle, size: CGSize, center: CGPoint) -> some View {
        Path { path in
            (0..<dimensions.count + 1).forEach { idx in
                let point = computePosition(at: idx, size: size)

                if idx == 0 {
                    path.move(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
                } else {
                    path.addLine(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
                }
            }
        }
        .stroke(mainColor.opacity(0.6), style: style)
    }

    private func drawDividers(style: StrokeStyle, size: CGSize, center: CGPoint) -> some View {
        ForEach(0..<dividerCount) { index in
            Path { path in
                (0..<dimensions.count + 1).forEach { idx in
                    let angle = CGFloat.radAngleFromFraction(numerator: idx, denominator: dimensions.count)
                    let size = ((size.width - padding) / 2 * (CGFloat(index + 1) / CGFloat(dividerCount + 1)))
                    let position = CGPoint(x: size * cos(angle), y: size * sin(angle))

                    if idx == 0 {
                        path.move(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    }
                }
            }
            .stroke(mainColor.opacity(0.2), style: style)
        }
    }

    private func computePosition(at index: Int, size: CGSize) -> CGPoint {
        let angle = CGFloat.radAngleFromFraction(numerator: index, denominator: dimensions.count)
        return .init(x: (size.width - padding) / 2 * cos(angle),
                     y: (size.height - padding) / 2 * sin(angle))
    }

    private func computeControlPoints(at index: Int, size: CGSize) -> MUSpiderGraphAnimatableVector {
        var pointValues = [Double]()
        (0..<datas[index].values.count).forEach { idx in
            let width = (size.width - padding) / 2
            let angle = CGFloat.radAngleFromFraction(numerator: idx == dimensions.count ? 0 : idx,
                                                     denominator: dimensions.count)
            let size = (width * (CGFloat(datas[index].values[idx]) / CGFloat(maxValue)))
            pointValues.append(Double(size * cos(angle)))
            pointValues.append(Double(size * sin(angle)))
        }

        return MUSpiderGraphAnimatableVector(with: pointValues)
    }

    private func drawPolygon(for data: SpiderGraphDataSet,
                             style: StrokeStyle,
                             size: CGSize,
                             center: CGPoint) -> some View {
        guard let index = datas.firstIndex(of: data) else { return EmptyView().eraseToAnyView()}
        let path = MUSpiderGraphPolygonShape(center: center, controlPoints: computeControlPoints(at: index, size: size))
        return AnyView(
            ZStack {
                path.stroke(datas[index].color, style: style)
                path.foregroundColor(datas[index].color).opacity(0.2)
            }
        )
    }

    public var body: some View {
        GeometryReader { geometry in
            let dimension = min(geometry.size.width, geometry.size.height)
            let size = CGSize(width: dimension, height: dimension)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            VStack {
                ZStack {
                    Group {
                        drawBranches(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round),
                                     size: size,
                                     center: center)
                        drawBorder(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round),
                                   size: size,
                                   center: center)
                        drawDividers(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round),
                                     size: size,
                                     center: center)
                    }

                    ForEach(datas) {
                        drawPolygon(
                            for: $0,
                            style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round),
                            size: size,
                            center: center
                        )
                    }

                    drawName(size: size)
                    score()
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
    }
}

struct SpiderGraph_Previews: PreviewProvider {
    static let dimensions = [
        "Intelligence",
        "Funny",
        "Empathy",
        "Veracity",
        "Selflessness",
        "Authenticity",
        "Boldness"
    ]

    static var datas = [
        SpiderGraphDataSet(values: dimensions.map { _ in
            Double.random(in: 0..<10)
        }, color: .green)
    ]

    static var previews: some View {
        MUSpiderGraph(
            datas: datas,
            mainColor: .accentColor,
            dividers: 5,
            maxValue: 10,
            dimensions: [],
            score: { EmptyView() }
        )
        .previewLayout(.sizeThatFits)
    }
}
