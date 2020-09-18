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
        Text(viewModel.time)
    }
}

struct ClockTimer_Previews: PreviewProvider {
    static let vm = MUClockTimerViewModel()

    static var previews: some View {
        MUClockTimer(with: vm).onAppear {
            vm.start()
        }.previewLayout(.fixed(width: 300, height: 200))
    }
}
