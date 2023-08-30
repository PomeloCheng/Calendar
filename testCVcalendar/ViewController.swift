//
//  ViewController.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/24.
//

import UIKit
import FSCalendar
import MKRingProgressView

var configindex : Int?

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, CalendarManagerDelegate {
    
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    var todayDate: Date = Date() // 保存今天的日期
    var tapGesture: UITapGestureRecognizer?
    
    override func viewWillAppear(_ animated: Bool) {
        calendarManager.share.FSCalendar = calendarView
        calendarManager.share.setConfig()
        calendarManager.share.delegate = self
        updateDateTitle(todayDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        calendarManager.share.selectTodayWeekdayLabel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarView.dataSource = self
        // Do any additional setup after loading the view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture!)
    }

    @IBAction func btnPressed(_ sender: Any) {
        guard let tapGesture = tapGesture else {
            return
        }
        view.removeGestureRecognizer(tapGesture)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        calendarManager.share.weekdayLabelTapped(sender)
    }
    
    func updateDateTitle(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y 年 M 月 d 日"
        let dateString = dateFormatter.string(from: date)
        navigationItem.title = dateString
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarManager.share.calendarCurrentPageDidChange()
    }
}
    
