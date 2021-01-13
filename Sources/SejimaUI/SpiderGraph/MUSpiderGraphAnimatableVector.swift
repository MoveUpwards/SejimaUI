//
//  MUSpiderGraphAnimatableVector.swift
//  tibtop-b2b
//
//  Created by Loïc GRIFFIE on 07/09/2020.
//  Copyright © 2020 VBKAM. All rights reserved.
//

import SwiftUI

public struct MUSpiderGraphAnimatableVector: VectorArithmetic {
    var values: [Double]

    init(count: Int) {
        self.values = [Double](repeating: 0.0, count: count)
    }

    init(with values: [Double]) {
        self.values = values
    }

    // MARK: VectorArithmetic

    /// squared magnitude of the vector
    public var magnitudeSquared: Double {
        values.map({ pow($0, 2) }).reduce(0.0, +)
    }

    public mutating func scale(by rhs: Double) {
        for index in 0..<values.count {
            values[index].scale(by: rhs)
        }
    }

    // MARK: AdditiveArithmetic

    // zero is identity element for aditions
    // = all values are zero
    public static var zero: MUSpiderGraphAnimatableVector = .init(count: 100)

    public static func + (lhs: MUSpiderGraphAnimatableVector,
                          rhs: MUSpiderGraphAnimatableVector) -> MUSpiderGraphAnimatableVector {
        var retValues = [Double]()
        for index in 0..<min(lhs.values.count, rhs.values.count) {
            retValues.append(lhs.values[index] + rhs.values[index])
        }
        return .init(with: retValues)
    }

    public static func += (lhs: inout MUSpiderGraphAnimatableVector, rhs: MUSpiderGraphAnimatableVector) {
        for index in 0..<min(lhs.values.count, rhs.values.count) {
            lhs.values[index] += rhs.values[index]
        }
    }

    public static func - (lhs: MUSpiderGraphAnimatableVector,
                          rhs: MUSpiderGraphAnimatableVector) -> MUSpiderGraphAnimatableVector {
        var retValues = [Double]()
        for index in 0..<min(lhs.values.count, rhs.values.count) {
            retValues.append(lhs.values[index] - rhs.values[index])
        }
        return .init(with: retValues)
    }

    public static func -= (lhs: inout MUSpiderGraphAnimatableVector, rhs: MUSpiderGraphAnimatableVector) {
        for index in 0..<min(lhs.values.count, rhs.values.count) {
            lhs.values[index] -= rhs.values[index]
        }
    }
}
