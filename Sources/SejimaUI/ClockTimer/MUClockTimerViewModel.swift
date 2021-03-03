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
    private var delta: TimeInterval = 0.0
    private var startDate: Date?
    private let formatter = DateFormatter()

    @Published public var label: String = ""

    public init(with format: String = "HH:mm:ss", at startTime: TimeInterval = 0.0) {
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if startTime > 0.0 { delta += startTime }
        updateLabel(with: delta)
        label += " " // See to remove " " trick, fix for longer string width on large number

        Timer.publish(every: 1.0, tolerance: 0.2, on: RunLoop.current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.tick(date: date)
            }
            .store(in: &disposables)
    }

    public var isStarted: Bool {
        startDate == nil ? false : true
    }

    public var currentTime: TimeInterval {
        guard let start = startDate?.timeIntervalSince1970 else { return 0 }
        return Date().timeIntervalSince1970 - start + delta
    }

    public func toggleTimer() {
        isStarted ? stop() : start()
    }

    public func start() {
        startDate = .init()
    }

    public func stop() {
        delta = currentTime
        startDate = nil
    }

    public func reset() {
        delta = 0.0
        updateLabel(with: delta)
        guard startDate != nil else { return }
        start()
    }

    public func add(_ time: TimeInterval) {
        delta += time
        updateLabel(with: delta)
    }

    // MARK: Private functions

    private func tick(date: Date) {
        guard let start = startDate?.timeIntervalSince1970 else { return }
        updateLabel(with: date.timeIntervalSince1970 - start + delta)
    }

    private func updateLabel(with time: TimeInterval) {
        label = formatter.string(from: Date(timeIntervalSinceReferenceDate: time))
    }
}
