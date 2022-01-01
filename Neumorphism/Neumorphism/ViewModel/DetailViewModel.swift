//
//  DetailViewModel.swift
//  Neumorphism
//
//  Created by Vincent Palma on 2021-12-27.
//

import Foundation
import HealthKit
import CoreImage


final class DetailViewModel: ObservableObject {
    var activity : Activity
    var repository : HKRepository
    
    @Published var stats = [HealthStat]()
    /*
     @Published is one of the most useful property wrappers in SwiftUI, allowing us to create observable objects that automatically announce when changes occur. SwiftUI will automatically monitor for such changes, and re-invoke the body property of any views that rely on the data.

     In practical terms, that means whenever an object with a property marked @Published is changed, all views using that object will be reloaded to reflect those changes.
     */
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
    
    init(activity: Activity, repository: HKRepository){
        self.activity = activity
        self.repository = repository
        repository.requestHealthStat(by: activity.id){hStats in
            self.stats = hStats
        }
        
        let measurementFormatter = MeasurementFormatter()
        
        
        func value(from stat: HKQuantity?) -> (value: Int, desc: String){
            guard let stat = stat else{ return (0,"")}
            
            measurementFormatter.unitStyle = .long
            
            if stat.is(compatibleWith: .kilocalorie()){
                let value = stat.doubleValue(for: .kilocalorie())
                return (Int(value), stat.description)
            } /*else if stat.is(compatibleWith: .meter()){
                let value = stat.doubleValue(for: .mile())
                let unit = Measurement(value: value, unit: UnitLength.miles)
                return (Int(value), measurementFormatter.string(from: unit))
            }*/ else if stat.is(compatibleWith: .count()){
                let value = stat.doubleValue(for: .count())
                return(Int(value),stat.description)
            } else if stat.is(compatibleWith: .minute()){
                let value = stat.doubleValue(for: .minute())
                return (Int(value),stat.description)
                
            }
            return(0,"")
        }
    }
}
