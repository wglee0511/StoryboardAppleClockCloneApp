//
//  Date+Util.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/18/24.
//

import Foundation

extension Date {
    private static var lastMinute: Int? = nil
    
    var isMinuteChanged: Bool {
        guard let lastMinute = Self.lastMinute else {
            Self.lastMinute = Calendar.current.component(.minute, from: .now)
            return true
        }
        
        let currentMinute = Calendar.current.component(.minute, from: .now)
        
        if lastMinute != currentMinute {
            Self.lastMinute = currentMinute
            return true
        }
        
        return false
    }
}
