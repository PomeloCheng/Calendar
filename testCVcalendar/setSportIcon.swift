//
//  setSportIcon.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/9/6.
//

import HealthKit
import UIKit

extension smallRecordContentVC {
    
    //MARK: 判斷運動類型
    func setCellIcon(for workout: HKWorkout) -> UIImage? {
        let activityType = workout.workoutActivityType
        let isIndoorWorkout = isIndoorWorkout(workout: workout)
        var symbolName: String
        
        switch activityType {
        case .americanFootball:
            symbolName = "figure.american.football"
        case .archery:
            symbolName = "figure.archery"
        case .australianFootball:
            symbolName = "figure.australian.football"
        case .badminton:
            symbolName = "figure.badminton"
        case .barre:
            symbolName = "figure.barre"
        case .baseball:
            symbolName = "figure.baseball"
        case .basketball:
            symbolName = "figure.basketball"
        case .bowling:
            symbolName = "figure.bowling"
        case .boxing:
            symbolName = "figure.boxing"
        case .climbing:
            symbolName = "figure.climbing"
        case .cooldown:
            symbolName = "figure.cooldown"
        case .coreTraining:
            symbolName = "figure.core.training"
        case .cricket:
            symbolName = "figure.cricket"
        case .crossCountrySkiing:
            symbolName = "figure.skiing.crosscountry"
        case .curling:
            symbolName = "figure.curling"
        case .cycling:
            if isIndoorWorkout {
            symbolName = "figure.indoor.cycle"
            }
            symbolName = "figure.outdoor.cycle"
        case .discSports:
            symbolName = "figure.disc.sports"
        case .downhillSkiing:
            symbolName = "figure.skiing.downhill"
        case .elliptical:
            symbolName = "figure.elliptical"
        case .equestrianSports:
            symbolName = "figure.equestrian.sports"
        case .fencing:
            symbolName = "figure.fencing"
        case .fishing:
            symbolName = "figure.fishing"
        case .flexibility:
            symbolName = "figure.flexibility"
        case .functionalStrengthTraining:
            symbolName = "figure.strengthtraining.functional"
        case .golf:
            symbolName = "figure.golf"
        case .gymnastics:
            symbolName = "figure.gymnastics"
        case .handCycling:
            symbolName = "figure.hand.cycling"
        case .handball:
            symbolName = "figure.handball"
        case .highIntensityIntervalTraining:
            symbolName = "figure.highintensity.intervaltraining"
        case .hiking:
            symbolName = "figure.hiking"
        case .hockey:
            symbolName = "figure.hockey"
        case .hunting:
            symbolName = "figure.hunting"
        case .jumpRope:
            symbolName = "figure.jumprope"
        case .kickboxing:
            symbolName = "figure.kickboxing"
        case .lacrosse:
            symbolName = "figure.lacrosse"
        case .martialArts:
            symbolName = "figure.martial.arts"
        case .mindAndBody:
            symbolName = "figure.mind.and.body"
        case .mixedCardio:
            symbolName = "figure.mixed.cardio"
        
        case .pickleball:
            symbolName = "figure.pickleball"
        case .pilates:
            symbolName = "figure.pilates"
        case .play:
            symbolName = "figure.play"
       
        case .racquetball:
            symbolName = "figure.racquetball"
       
        case .rugby:
            symbolName = "figure.rugby"
        case .running:
            symbolName = "figure.run"
        case .sailing:
            symbolName = "figure.sailing"
        case .skatingSports:
            symbolName = "figure.skating"
        case .snowSports:
            symbolName = "figure.snowboarding"
        case .snowboarding:
            symbolName = "figure.snowboarding"
        case .soccer:
            symbolName = "figure.soccer"
        case .socialDance:
            symbolName = "figure.socialdance"
        case .softball:
            symbolName = "figure.softball"
        case .squash:
            symbolName = "figure.squash"
        case .stairClimbing:
            symbolName = "figure.stairs"
        case .stairs:
            symbolName = "figure.stairs"
            
        case .stepTraining:
            symbolName = "figure.step.training"
            
        case .surfingSports:
            symbolName = "figure.surfing"
        case .swimming:
            if isIndoorWorkout {
                symbolName = "figure.pool.swim"
            }
            symbolName = "figure.open.water.swim"
        case .tableTennis:
            symbolName = "figure.table.tennis"
        case .taiChi:
            symbolName = "figure.taichi"
        case .tennis:
            symbolName = "figure.tennis"
        case .trackAndField:
            symbolName = "figure.track.and.field"
        case .traditionalStrengthTraining:
            symbolName = "figure.strengthtraining.traditional"
        case .volleyball:
            symbolName = "figure.volleyball"
        case .walking:
            symbolName = "figure.walk"
        case .waterFitness:
            symbolName = "figure.water.fitness"
        case .waterPolo:
            symbolName = "figure.waterpolo"
        
        case .wheelchairRunPace:
            symbolName = "figure.roll.runningpace"
        case .wheelchairWalkPace:
            symbolName = "figure.roll.runningpace"
        case .wrestling:
            symbolName = "figure.wrestling"
        case .yoga:
            symbolName = "figure.yoga"
       
        case .other:
            symbolName = "figure.stand"
        default:
            symbolName = "figure.stand"
        }
        
       return UIImage(systemName: symbolName)
    }

    func isIndoorWorkout(workout: HKWorkout) -> Bool {
        if let metadata = workout.metadata,
           let indoorValue = metadata[HKMetadataKeyIndoorWorkout] as? Bool {
            return indoorValue
        }
        return false // 默认为室外活动
    }

    
}
