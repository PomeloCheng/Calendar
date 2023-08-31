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

    @IBOutlet weak var bigCalendar: FSCalendar!
    
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
        bigCalendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 24)
        
        bigCalendar.appearance.headerSeparatorColor = .clear
        
        let headerX = self.view.bounds.width
        bigCalendar.appearance.headerTitleOffset = CGPoint(x: headerX / 3 + 36, y: 0)
        bigCalendar.pagingEnabled = false
        bigCalendar.placeholderType = .none
        bigCalendar.clipsToBounds = false
        // Do any additional setup after loading the view.
        bigCalendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        
        
        
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

}



