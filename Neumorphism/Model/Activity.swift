//
//  Activity.swift
//  MoveNLoose
//
//  Created by Vincent Palma on 2021-12-21.
//

import Foundation
import HealthKit

struct Activity: Identifiable
{
    var id: String
    var name: String
    var image : String
    
    static func allActivities() ->[Activity]
    {
        return [
        Activity(id: "activeEnergyBurned", name: "ABC", image: "😅"),
        Activity(id: "dietaryEnergyConsumed", name: "Eaten Calories", image: "🍞"),
        Activity(id: "basalEnergyConsumed", name: "Resting Energy Consume", image: "🧘🏻"),
        Activity(id: "stepCount", name: "Step Count", image: "🚶")
        ]
    }
}


/*
 .basalEnergyBurned)
 HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
 */

