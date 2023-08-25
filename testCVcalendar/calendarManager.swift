//
//  calendarManager.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/25.
//

import Foundation
import FSCalendar

protocol CalendarManagerDelegate: AnyObject {
    func updateDateTitle(_ date: Date)
}

class calendarManager {
    var FSCalendar : FSCalendar!
    var selectedWeekdayLabel: UILabel?
    var circleView: UIView?
    var todayDate: Date = Date() // 保存今天的日期
    weak var delegate: CalendarManagerDelegate?
    
    static let share = calendarManager()
    private init() {}
    
    
    func setConfig(){
        FSCalendar.locale = .init(identifier: "zh-tw")
        FSCalendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        FSCalendar.scope = .week
        FSCalendar.firstWeekday = 2
        FSCalendar.weekdayHeight = 40
        
        FSCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 0) // Hide the title
        FSCalendar.headerHeight = 0
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
    
    func selectTodayWeekdayLabel() {
        
        
        let weekdayIndex = Calendar.current.component(.weekday, from: todayDate) - 2 // 轉換成 0-6 的索引
        let todayWeekdayLabel = FSCalendar.calendarWeekdayView.weekdayLabels[weekdayIndex]
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
    
    func calculateSelectedDate(weekdayIndex: Int) -> Date {
        let calendar = Calendar.current
        let currentDate = FSCalendar.currentPage // 當前頁面的日期
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        let daysToAdd = weekdayIndex - currentWeekday + 2
        return calendar.date(byAdding: .day, value: daysToAdd, to: currentDate) ?? currentDate
    }
    
    @objc func weekdayLabelTapped(_ sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: FSCalendar)
        
        for (index, weekdayLabel) in FSCalendar.calendarWeekdayView.weekdayLabels.enumerated() {
            
            let labelFrame = weekdayLabel.frame
            if labelFrame.contains(tapLocation) {
                // 在這裡處理點擊星期標籤的邏輯，切換到對應日期
                // 例如，根據點擊的星期標籤，計算並設置日曆顯示的日期範圍
                
                // 取消上一次選取的效果（如果有）
                resetSelectedState()
                
                // 更新選取的標籤外觀
                selectedWeekdayLabel = weekdayLabel
                
                selectedWeekdayLabel?.textColor = .white // 選取的顏色
                
                // 更新日期標籤
                let selectedDate = calculateSelectedDate(weekdayIndex: index)
                delegate?.updateDateTitle(selectedDate) // 通知代理
                
                if Calendar.current.isDateInToday(selectedDate) {
                    setSelection(labelFrame: labelFrame, weekdayLabel: weekdayLabel, color: .red)
                } else {
                    setSelection(labelFrame: labelFrame, weekdayLabel: weekdayLabel, color: .gray)
                }
                
                
                break
            }
        }
    }
    
    
    
    
    func calendarCurrentPageDidChange() {
        
            if let selectedWeekdayLabel = selectedWeekdayLabel {
                // 使用選取的星期標籤索引計算日期
                if let weekdayIndex = FSCalendar.calendarWeekdayView.weekdayLabels.firstIndex(of: selectedWeekdayLabel) {
                    let selectedDate = calculateSelectedDate(weekdayIndex: weekdayIndex)
                    delegate?.updateDateTitle(selectedDate) // 通知代理
                }
            }
        }
}

extension Date {
    func addDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
}
