//
//  healthManager.swift
//  testHealthKit
//
//  Created by YuCheng on 2023/8/26.
//

import Foundation
import HealthKit
import UIKit

class HealthManager {
    let healthStore: HKHealthStore
    var stepType: HKQuantityType
    var activeEnergyType: HKQuantityType
    var stepDistance: HKQuantityType
    var activeTime: HKQuantityType
    
    
    
    init() {
            guard HKHealthStore.isHealthDataAvailable() else {
                fatalError("Your device can't use HealthKit")
            }
            
            healthStore = HKHealthStore()
        
            if let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
               let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
               let stepDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
               let activeTime = HKObjectType.quantityType(forIdentifier: .appleMoveTime){
                    self.stepType = stepType
                    self.activeEnergyType = activeEnergyType
                    self.stepDistance = stepDistance
                    self.activeTime = activeTime
    
                } else {
                    fatalError("Invalid step count or active energy identifier")
                }
            
        }
    
    
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [stepType,activeEnergyType,.activitySummaryType(),stepDistance,activeTime]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
    func setPredicate(for date: Date) -> NSPredicate{
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let predicvate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        return predicvate
    }
    
    func readStepCount(for date: Date, completion: @escaping (Double?) -> Void) {
        let predicate = setPredicate(for: date)

        let stepQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error fetching step count: \(error.localizedDescription)")
                    completion(nil)
                }
                return
            }
            
            let steps = sum.doubleValue(for: HKUnit.count())
            completion(steps)
            
        }
        healthStore.execute(stepQuery)
    }
    
    func readCalories(for date: Date, completion: @escaping (Double?,Double?) -> Void) {
        
        let predicate = setPredicate(for: date)

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
            
            
            //print("日期：\(dateString), 卡路里總和：\(calories), 目標： \(goalValue)")
            completion(calories,progress)
            
        }
            healthStore.execute(caloriesSummary)
        }
    
    
    func setQuery(type: HKQuantityType, predicate: NSPredicate, completion: @escaping (HKStatisticsQuery,HKStatistics?,Error?) -> Void) -> HKStatisticsQuery{
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            completion(query,result,error)
        }
        return query
        }
    
    func readStepDistance(for date: Date, completion: @escaping (Double?) -> Void){
        let predicate = setPredicate(for: date)

        let stepQuery = setQuery(type: stepDistance, predicate: predicate) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error fetching step count: \(error.localizedDescription)")
                    completion(nil)
                }
                return
            }
            let distance = sum.doubleValue(for: HKUnit.meter()) / 1000.0
            completion(distance)
        }
        healthStore.execute(stepQuery)
    }
    
    func readActiveTime(for date: Date, completion: @escaping (Double?) -> Void){
        
    }
        
    }


extension UIViewController {
    
    
    func showHealthKitAuthorizationAlert() {
            let alertController = UIAlertController(title: "需要 HealthKit 授权", message: "此应用需要访问您的健康数据。请点击“设置”以授权。", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "设置", style: .default) { (_) in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
}



