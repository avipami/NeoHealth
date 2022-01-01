//
//  HKData.swift
//  Neumorphism
//
//  Created by Vincent Palma on 2021-12-25.
//

import Foundation


struct HealthData: Identifiable {
  var id = UUID()
  var name: String
  var calories: Int
  var stepCount: Int
  var caloriesEaten: Int
  var weight: Int
}
