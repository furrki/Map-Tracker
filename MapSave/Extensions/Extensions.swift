//
//  Extensions.swift
//  MapSave
//
//  Created by Admin on 23.12.2018.
//  Copyright © 2018 furrki. All rights reserved.
//

import Foundation
extension Double {
    func round(to: Double) -> Double{
        let divisor = pow(10, to)
        return (self * divisor).rounded() / divisor
    }
}
extension Int {
    func formatTimeDurationToString() -> String {
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
            }
        }
    }
}
