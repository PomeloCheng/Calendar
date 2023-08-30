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
    
    @IBOutlet weak var bigCalendar: FSCalendar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigCalendar.calendarWeekdayView.isHidden = true
        bigCalendar.delegate = self
        bigCalendar.dataSource = self
        bigCalendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        bigCalendar.scrollDirection = .vertical
        bigCalendar.pagingEnabled = false
        bigCalendar.appearance.headerSeparatorColor = .clear
        
        // Do any additional setup after loading the view.
        bigCalendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            configindex = 1
            let cell = calendar.dequeueReusableCell(withIdentifier: "CustomCalendarCell", for: date, at: position) as! CustomCalendarCell
            
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
    
    
}
