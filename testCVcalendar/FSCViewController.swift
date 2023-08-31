//
//  FSCViewController.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/26.
//

import UIKit
import FSCalendar
import MKRingProgressView
class FSCViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    @IBOutlet weak var monthLabel: UILabel!
    
    
    
    @IBOutlet weak var SunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var TueLabel: UILabel!
    @IBOutlet weak var WenLabel: UILabel!
    @IBOutlet weak var ThuLabel: UILabel!
    @IBOutlet weak var FriLabel: UILabel!
    @IBOutlet weak var SatLabel: UILabel!
    
    @IBOutlet weak var bigCalendar: FSCalendar!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月"
        let currentMonthString = dateFormatter.string(from: today)
        monthLabel.text = currentMonthString
        bigCalendar.delegate = self
        bigCalendar.dataSource = self
        
        bigCalendar.scrollDirection = .vertical
        bigCalendar.firstWeekday = 2
        bigCalendar.appearance.headerDateFormat = "M月"
        bigCalendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 18)
        
        bigCalendar.appearance.headerSeparatorColor = .clear
        
       
        bigCalendar.pagingEnabled = false
        bigCalendar.placeholderType = .none
        bigCalendar.clipsToBounds = false
        // Do any additional setup after loading the view.
        bigCalendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        bigCalendar.appearance.headerTitleAlignment = .left
        
        
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            configindex = 1
            let cell = calendar.dequeueReusableCell(withIdentifier: "CustomCalendarCell", for: date, at: position) as! CustomCalendarCell
            
            configureCustomView(cell.customView, for: date)
            
            
            return cell
        }
        
    
    
        
        func configureCustomView(_ customView: RingProgressView, for date: Date) {
            if date > Date() {
                customView.layer.opacity = 0.2
            } else {
                customView.layer.opacity = 1
            }
        }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            let currentPage = calendar.currentPage
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年M月"
            let currentMonthString = dateFormatter.string(from: currentPage)
            monthLabel.text = currentMonthString
            // 將 currentMonthString 設定給你的 label
            // 例如：yourLabel.text = currentMonthString
        
        }
    
    func calendar(_ calendar: FSCalendar, titleForHeaderFor date: Date) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M月"
            return dateFormatter.string(from: date)
        }
    
    func updateHeaderTitleOffset(for date: Date) {
        let dayLabels: [UILabel] = [
            monLabel, ThuLabel, WenLabel,
            ThuLabel, FriLabel, SatLabel, SunLabel
        ]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        var components = calendar.dateComponents([.year, .month], from: date)
        components.day = 1
        let firstDayOfMonth = calendar.date(from: components)!
        
        var weekday = calendar.component(.weekday, from: firstDayOfMonth) - 2
        
        if weekday < 0  {
            weekday = 6 // 假設 weekday 介於 1 到 7 之間，如果不是則返回
        }
        
        let labelIndex = weekday // 因為陣列索引從 0 開始，所以要減 1
        let xOffset = dayLabels[labelIndex].frame.origin.x + dayLabels[labelIndex].frame.size.width / 2 - 4
        DispatchQueue.main.async {
                    self.bigCalendar.appearance.headerTitleOffset = CGPoint(x: xOffset, y: 0)
                }
    }
 
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
           if monthPosition == .current {
               updateHeaderTitleOffset(for: date)
           }
       }
}


extension Date {
    func startOfMonth() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        var components = calendar.dateComponents([.year, .month], from: self)
        components.day = 1
        return calendar.date(from: components)!
    }
}
