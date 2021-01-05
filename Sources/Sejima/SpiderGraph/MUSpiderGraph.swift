//
//  SpiderGraph.swift
//  tibtop-b2b
//
//  Created by Loïc GRIFFIE on 03/09/2020.
//  Copyright © 2020 VBKAM. All rights reserved.
//

import SwiftUI

public struct MUSpiderGraph: View {
    public struct DataSet: Identifiable, Equatable {
        public let id = UUID()
        public let color: Color
        public let values: [Double]

        public init(values: [Double], color: Color) {
            self.values = values
            self.color = color
        }
    }

    private let mainColor: Color
    private let showLabel: Bool
    private let labelColor: Color
    private let labelWidth: CGFloat
    private let width: CGFloat
    private let padding: CGFloat
    private let dividerCount: Int
    private let maxValue: Double
    private let dimensions: [String]
    private let datas: [DataSet]
    private var center: CGPoint { CGPoint(x: width / 2, y: width / 2) }

    @State private var controlPoints: [MUSpiderGraphAnimatableVector]

    public init(width: CGFloat,
                padding: CGFloat = 16,
                mainColor: Color = .white,
                showLabel: Bool = true,
                labelColor: Color = Color.white.opacity(0.7),
                labelWidth: CGFloat = 70,
                dividers: Int = 5,
                maxValue: Double = 10.0,
                dimensions: [String],
                capacity: Int = 0,
                datas: [DataSet]) {
        self.width = width
        self.padding = padding
        self.mainColor = mainColor
        self.showLabel = showLabel
        self.labelColor = labelColor
        self.labelWidth = showLabel ? labelWidth : 0
        self.dividerCount = dividers
        self.maxValue = maxValue
        self.dimensions = dimensions
        self.datas = datas

        let points = Array(repeating: MUSpiderGraphAnimatableVector(count: dimensions.count * 2),
                           count: max(datas.count, capacity))
        _controlPoints = State(wrappedValue: points)
    }

    @State private var showLabels = false

    private func drawLabels() -> some View {
       ForEach(0..<dimensions.count) {
            Text(dimensions[$0])
                .font(.system(size: 10))
                .foregroundColor(labelColor)
                .frame(width: labelWidth)
                .rotationEffect(
                    .degrees(
                        (CGFloat.degAngleFromFraction(numerator: $0, denominator: dimensions.count) > 90 &&
                            CGFloat.degAngleFromFraction(numerator: $0, denominator: dimensions.count) < 270) ? 180 : 0
                    ))
                .background(Color.clear)
                .offset(x: (width - (padding)) / 2)
                .rotationEffect(
                    .radians(
                        Double(CGFloat.radAngleFromFraction(numerator: $0, denominator: dimensions.count))
                    )
                )
        }
    }

    private func computePosition(at index: Int) -> CGPoint {
        let angle = CGFloat.radAngleFromFraction(numerator: index, denominator: dimensions.count)
        return .init(x: (width - (padding + labelWidth)) / 2 * cos(angle),
                     y: (width - (padding + labelWidth)) / 2 * sin(angle))
    }

    private func drawBranches(style: StrokeStyle) -> some View {
        Path { path in
            (0..<dimensions.count).forEach { idx in
                let point = computePosition(at: idx)
                path.move(to: center)
                path.addLine(to: CGPoint(x: center.x + point.x, y: center.y + point.y))
            }
        }
        .stroke(mainColor, style: style)
    }

    private func drawBorder(style: StrokeStyle) -> some View {
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
        .stroke(mainColor, style: style)
    }

    private func drawDividers(style: StrokeStyle) -> some View {
        ForEach(0..<dividerCount) { index in
            Path { path in
                (0..<dimensions.count + 1).forEach { idx in
                    let angle = CGFloat.radAngleFromFraction(numerator: idx, denominator: dimensions.count)
                    let size = ((width - (padding + labelWidth)) / 2 * (CGFloat(index + 1) / CGFloat(dividerCount + 1)))
                    let position = CGPoint(x: size * cos(angle), y: size * sin(angle))

                    if idx == 0 {
                        path.move(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + position.x, y: center.y + position.y))
                    }
                }
            }
            .stroke(mainColor, style: style)
        }
    }

    private func computeControlPoints(at index: Int) {
        var pointValues = [Double]()
        (0..<datas[index].values.count).forEach { idx in
            let width = (self.width - (padding + labelWidth)) / 2
            let angle = CGFloat.radAngleFromFraction(numerator: idx == dimensions.count ? 0 : idx,
                                                     denominator: dimensions.count)
            let size = (width * (CGFloat(datas[index].values[idx]) / CGFloat(maxValue)))
            pointValues.append(Double(size * cos(angle)))
            pointValues.append(Double(size * sin(angle)))
        }
        controlPoints[index] = MUSpiderGraphAnimatableVector(with: pointValues)
    }

    private func drawPolygon(for data: DataSet, style: StrokeStyle) -> some View {
        guard let index = datas.firstIndex(of: data) else { return EmptyView().eraseToAnyView()}
        let path = MUSpiderGraphPolygonShape(center: center, controlPoints: controlPoints[index])
        return AnyView(
            ZStack {
                path.stroke(datas[index].color, style: style)
                path.foregroundColor(datas[index].color).opacity(0.2)
            }
        )
    }

    public var body: some View {
        ZStack {
            Group {
                drawBranches(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                drawBorder(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                drawDividers(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                
                if showLabel { drawLabels() }
            }

            ForEach(datas) {
                drawPolygon(for: $0, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            }
        }
        .onChange(of: datas) { _ in
            datas.indices.forEach { computeControlPoints(at: $0) }
        }
        .onAppear {
            datas.indices.forEach { computeControlPoints(at: $0) }
        }
        .frame(width: width, height: width)
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
        MUSpiderGraph.DataSet(values: dimensions.map { _ in
            Double.random(in: 0..<10)
        }, color: .green)
    ]

    static var previews: some View {
        MUSpiderGraph(width: 370,
                    mainColor: .accentColor,
                    labelColor: .accentColor,
                    dividers: 5,
                    maxValue: 10,
                    dimensions: dimensions,
                    datas: datas)
            .previewLayout(.sizeThatFits)
    }
}
