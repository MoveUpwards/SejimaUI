//
//  MUClockTimerViewModel.swift
//  
//
//  Created by Mac on 16/09/2020.
//

import Foundation
import Combine

public class MUClockTimerViewModel: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    private var startDate: Date?
    private let formatter = DateFormatter()

    @Published public var time: String = ""

    public init() {
        time = " 00:00:00 "
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        Timer.publish(every: 1.0, tolerance: 0.2, on: RunLoop.current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.tick(date: date)
            }
            .store(in: &disposables)
    }

    public var isStarted: Bool {
        return startDate == nil ? false : true
    }

    public var currentTime: TimeInterval {
        guard let start = startDate?.timeIntervalSince1970 else { return 0 }
        return Date().timeIntervalSince1970 - start
    }

    public func toggleTimer() {
        if isStarted {
            stop()
        } else {
            start()
        }
    }

    public func start(with format: String = "HH:mm:ss") { // "HH:mm:ss.SSS"
        startDate = .init()
        formatter.dateFormat = format
    }

    public func stop() {
        startDate = nil
    }

    // MARK: Private functions

    private func tick(date: Date) {
        guard let start = startDate?.timeIntervalSince1970 else {
            return
        }
        time = formatter.string(from: Date(timeIntervalSinceReferenceDate: date.timeIntervalSince1970 - start))
    }
}
