//
//  calendarManager.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/25.
//

import Foundation
import FSCalendar

class calendarManager {
    var selectedWeekdayLabel: UILabel?
    var circleView: UIView?
    var todayDate: Date = Date() // 保存今天的日期
    
    static let share = calendarManager()
    private init() {}
    
    
    func setConfig(FScalendar: FSCalendar){
        FScalendar.locale = .init(identifier: "zh-tw")
        FScalendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        FScalendar.scope = .week
        FScalendar.firstWeekday = 2
        FScalendar.weekdayHeight = 40
        
        FScalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 0) // Hide the title
        FScalendar.headerHeight = 0
    }
    
    
    func setSelection(labelFrame: CGRect,weekdayLabel: UILabel,color: UIColor) {
        // 添加紅色圓圈
        let circleRadius: CGFloat = 15.0
        let circleYOffset: CGFloat = 0 // 調整Y的偏移量，根據需要調整
        let circleFrame = CGRect(x: labelFrame.midX - circleRadius, y: labelFrame.midY - circleYOffset - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
        circleView = UIView(frame: circleFrame)
        circleView?.backgroundColor = color // 填滿紅色
        
        
        // 設定圓角半徑以達到圓形效果
        circleView?.layer.cornerRadius = circleRadius
        circleView?.clipsToBounds = true
        
        if let superView = weekdayLabel.superview, let circleView = circleView {
                        superView.insertSubview(circleView, belowSubview: weekdayLabel)
                    }
        
        // 添加動畫效果
        circleView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
           UIView.animate(withDuration: 0.2) {
               self.circleView?.transform = CGAffineTransform.identity
           }
    }
    
    func selectTodayWeekdayLabel(FScalendar: FSCalendar) {
        
        
        let weekdayIndex = Calendar.current.component(.weekday, from: todayDate) - 2 // 轉換成 0-6 的索引
        let todayWeekdayLabel = FScalendar.calendarWeekdayView.weekdayLabels[weekdayIndex]
        let labelFrame = todayWeekdayLabel.frame
        selectedWeekdayLabel = todayWeekdayLabel
        todayWeekdayLabel.textColor = .white
        setSelection(labelFrame: labelFrame, weekdayLabel: todayWeekdayLabel, color: .red)
    }
    
    func resetSelectedState() {
        selectedWeekdayLabel?.textColor = .blue // 還原為初始顏色
        

            // 移除圓圈的 UIView
            circleView?.removeFromSuperview()
            circleView = nil
        
        }
    
    func calculateSelectedDate(FScalendar:FSCalendar, weekdayIndex: Int) -> Date {
        let calendar = Calendar.current
        let currentDate = FScalendar.currentPage // 當前頁面的日期
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        let daysToAdd = weekdayIndex - currentWeekday + 2
        return calendar.date(byAdding: .day, value: daysToAdd, to: currentDate) ?? currentDate
    }
    
}


