//
//  Date+Additions.swift
//  RedditClient
//
//  Created by Olexandr Rutenko on 4/21/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

extension Date {
    func timeLeft(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                         from: date, to: self)
        //Better use NSLocalizedString + plurals rule
        if let year = components.year, year > 0 {
            return "\(year) years ago"
        }
        if let month = components.month, month > 0 {
            return "\(month) months ago"
        }
        if let day = components.day, day > 0 {
            return "\(day) days ago"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour) hours ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute) minutes ago"
        }
        if let second = components.second, second > 0 {
            return "\(second) seconds ago"
        }
        return ""
    }
}
