//
//  HealthStat.swift
//  MoveNLoose
//
//  Created by Vincent Palma on 2021-12-21.
//

import Foundation
import HealthKit

struct HealthStat : Identifiable
{
    let id = UUID()
    let stat: HKQuantity?
    let date: Date
}
