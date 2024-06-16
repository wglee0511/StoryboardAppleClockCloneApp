//
//  TimeZone+Util.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import Foundation

fileprivate let formatter = DateFormatter()
fileprivate let offsetFormatter = DateComponentsFormatter()

extension TimeZone {
    var currentTime: String? {
        formatter.timeZone = self
        formatter.dateFormat = "h:mm"
        
        return formatter.string(from: .now)
    }
    
    var timePeriod: String? {
        formatter.timeZone = self
        formatter.dateFormat = "a"
        
        return formatter.string(from: .now)
    }
    
    var city: String? {
        let timeZoneString = "\(self.identifier)"
        let timeZoneStringList = timeZoneString.split(separator: "/")
        
        return "\(timeZoneStringList[1])"
    }
    
    var timeOffset: String? {
        let offset = secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let time = Date(timeIntervalSinceNow: TimeInterval(offset))
        
        let components = DateComponents(second: offset)
        
        if offset.isMultiple(of: 3600) {
            offsetFormatter.allowedUnits = .hour
            offsetFormatter.unitsStyle = .full
        } else {
            offsetFormatter.allowedUnits = [.hour, .minute]
            offsetFormatter.unitsStyle = .positional
        }
        
        let offsetString = offsetFormatter.string(from: components) ?? "\(offset / 3600)"
        
        
        let calendar = Calendar.current
        let isPositive = offset >= 0
        let unitValue = isPositive ? "+" : ""
            
        if calendar.isDateInToday(time) {
            return "오늘, \(unitValue + offsetString)"
        } else if calendar.isDateInYesterday(time) {
            return "어제, \(unitValue + offsetString)"
        } else if calendar.isDateInTomorrow(time) {
            return "네일, \(unitValue + offsetString)"
        }
        
        return nil
    }
}
