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
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    var tapGesture: UITapGestureRecognizer?
    
    override func viewWillAppear(_ animated: Bool) {
        calendarManager.share.FSCalendar = calendarView
        calendarViewHeight.constant = 200
        calendarManager.share.setConfig()
        calendarManager.share.delegate = self
        updateDateTitle(todayDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        calendarManager.share.selectTodayWeekdayLabel()
    }
    
    
    @IBOutlet weak var ringView: RingProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // Do any additional setup after loading the view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture!)
        
        calendarView.scope = .week
        ringView.startColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
        ringView.endColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
        ringView.gradientImageScale = 0.5
        ringView.ringWidth = 15
        ringView.progress = 0.0
        ringView.shadowOpacity = 0.0
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     self.calendarViewHeight.constant = bounds.height
    self.view.layoutIfNeeded()
    }
}
    
