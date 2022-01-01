//
//  Date.swift
//  MoveNLoose
//
//  Created by Vincent Palma on 2021-12-22.
//

import Foundation

extension Date {
    static func mondayAt12Am() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    static func firstDayOfWeek() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
    }
}

