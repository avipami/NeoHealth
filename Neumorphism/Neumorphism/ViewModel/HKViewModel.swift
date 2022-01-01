//
//  HKRepository.swift
//  EatNLoose
//
//  Created by Vincent Palma on 2021-12-16.
//

import Foundation
import HealthKit




final class HKViewModel{
    var healthStore: HKHealthStore?
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable(){
        healthStore = HKHealthStore()
        }else{
            // Something ?
        }
    }
    
    // The data that we want to get from the healthKit
    let typesOfDataToAskFor = Set([
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!
    ])
    
    var query: HKStatisticsCollectionQuery?
    /*
     the HKStatisticsQuery which is used to perform statistical calculations on sets of matching samples.
     */
    

    func requestAuthorization(completion: @escaping (Bool) -> Void)
    {
        guard let healthStore = self.healthStore else {return completion(false)}
        
        healthStore.requestAuthorization(toShare: []/*Only to write data*/, read: typesOfDataToAskFor) { (success, error) in
            completion(success)
            /*Requests permission to save and read the specified data types.*/
        }
    }
    
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void){
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! // Interested in taking out stepCount
        
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())   // Date from 1 day prior until now
        
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



