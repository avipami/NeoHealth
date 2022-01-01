//
//  HKRepository.swift
//  Neumorphism
//
//  Created by Vincent Palma on 2021-12-27.
//

import Foundation
import HealthKit



final class HKRepository{
    
    var healthStore : HKHealthStore?
    
    let allTypes = Set([
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
    ])
    
    //repository creation
    
    var query : HKStatisticsCollectionQuery?
    
    var dailyQuery : HKStatisticsQuery?
    
    
    
    
    init(){
        healthStore = HKHealthStore()
    }
    
    
    func requestAuthorization(completion:@escaping (Bool)->Void){
        guard let store = healthStore else {
            return
        }
        
        
        store.requestAuthorization(toShare: [], read: allTypes) {success,error in
            completion(success)
        }
    }
    
    func requestHealthStat (by category: String, completion: @escaping ([HealthStat]) -> Void){
        
        guard let store = healthStore, let type = HKObjectType.quantityType(forIdentifier: typeByCategory(category: category)) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()   // Date from 1 day prior until now
        
        let endDate = Date() // Now now
        
        let anchorDate = Date.mondayAt12Am() // Day start at 12 am
        
        let daily = DateComponents(day: 1)  // Calculate it daily
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        var healthStats = [HealthStat]()  // Create an array of health stats
        
        query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query?.initialResultsHandler = { query, statistics, error in
            statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, end in
                let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
                healthStats.append(stat)
            })
            
            completion(healthStats)
        }
        
        guard let query = query else {
            return
        }
        
        store.execute(query)
        
    }
    
    
    /*
     Helper to identify type of data
     */
     func typeByCategory(category:String) -> HKQuantityTypeIdentifier{
        
        switch category{
        case "activeEnergyBurned":
            return .activeEnergyBurned
            
        case"stepCount":
            return .stepCount
            
        default:
            return .stepCount
            
        }
        
    }
    
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void){
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! // Interested in taking out stepCount
        
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())   // Date from 10 day prior until now
        
        let anchorDate = Date.mondayAt12Am() // Day start at 12 am
        
        let daily = DateComponents(day: 1)  // Calculate it daily
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = {query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        if let healthStore = healthStore , let query = self.query {
            healthStore.execute(query)
        }
    }
    
    
    
    
}
