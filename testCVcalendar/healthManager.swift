//
//  healthManager.swift
//  testHealthKit
//
//  Created by YuCheng on 2023/8/26.
//

import Foundation
import HealthKit

class HealthManager {
    let healthStore: HKHealthStore
    var stepType: HKQuantityType
    var activeEnergyType: HKQuantityType
    
    
    
    init() {
            guard HKHealthStore.isHealthDataAvailable() else {
                fatalError("Your device can't use HealthKit")
            }
            
            healthStore = HKHealthStore()
        
            if let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
               let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
                    self.stepType = stepType
                    self.activeEnergyType = activeEnergyType
    
                } else {
                    fatalError("Invalid step count or active energy identifier")
                }
            
        }
    
    
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [stepType,activeEnergyType,.activitySummaryType()]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
    
    func readStepCount(for date: Date, completion: @escaping (Double?) -> Void) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let stepQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error fetching step count: \(error.localizedDescription)")
                }
                return
            }
            
//            let steps = sum.doubleValue(for: HKUnit.count())
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let dateString = dateFormatter.string(from: date)
            
            //print("日期：\(dateString), 步數總和：\(steps)")
            
        }
        
        let caloriesSummary = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            if let error = error {
                print("Error fetching active energy burned goal: \(error.localizedDescription)")
                return
            }
            
            guard let summaries = summaries,
                let summary = summaries.first else {
                return
            }
            
            let activeEnergyBurned = summary.activeEnergyBurned
            let calories = activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
            let activeEnergyBurnedGoal = summary.activeEnergyBurnedGoal
            let goalValue = activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
            
            let progress = calories / goalValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            //print("日期：\(dateString), 卡路里總和：\(calories), 目標： \(goalValue)")
            completion(progress)
            
        }
            healthStore.execute(stepQuery)
            healthStore.execute(caloriesSummary)
           
        }
        
    }
