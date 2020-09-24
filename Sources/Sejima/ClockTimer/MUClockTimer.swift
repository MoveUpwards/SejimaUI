//
//  MUClockTimer.swift
//  
//
//  Created by Mac on 16/09/2020.
//

import SwiftUI

public struct MUClockTimer: View {
    @ObservedObject private var viewModel: MUClockTimerViewModel

    public init(with viewModel: MUClockTimerViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Text(viewModel.label)
    }
}

struct ClockTimer_Previews: PreviewProvider {
    static let vmStart = MUClockTimerViewModel(with: "mm:ss")
    static let vmInitValue = MUClockTimerViewModel(with: "mm:ss.SSS", at: 23.877)
    static let vmEmpty = MUClockTimerViewModel()

    static var previews: some View {
        Group {
            MUClockTimer(with: vmStart).onAppear {
                vmStart.start()
            }.previewLayout(.fixed(width: 100, height: 50))
            MUClockTimer(with: vmInitValue).onTapGesture {
                vmInitValue.toggleTimer()
            }.previewLayout(.fixed(width: 100, height: 50))
            MUClockTimer(with: vmEmpty).previewLayout(.fixed(width: 100, height: 50))
        }
    }
}
