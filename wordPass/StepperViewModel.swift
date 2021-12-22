//
//  SwiftUIView.swift
//  wordPass
//
//  Created by Carl Raabe on 20.12.21.
//

import SwiftUI

class StepperViewModel: ObservableObject {
    
    private var step_value: Int
    @Published var min_value: Int
    @Published var max_value: Int
    
    @Published var value: Int = 0
    @Published var running: Bool = false
    @Published var increase: Bool = true
    
    private var timer: Timer?
    
    public init(start_val: Int = 0, min_value: Int, max_value: Int, by step_value: Int = 1) {
        self.value = start_val
        self.min_value = min_value
        self.max_value = max_value
        self.step_value = step_value
    }
    
    func start() {
        if !running {
            running.toggle()
            startTimer()
        }
    }
    
    func stop() {
        timer?.invalidate()
        running = false
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] _ in
            self.increaseValue()
        })
    }
    
    func increaseValue() {
        let new_val = value + (increase ? step_value : -step_value)
        if new_val == min_value || new_val == max_value {
            stop()
        } else {
            value = new_val
        }
    }
}
