//
//  ViewController.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/24.
//

import UIKit
import FSCalendar
import MKRingProgressView
import HealthKit

var configindex : Int?
var darkGreen = UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1)
var lightGreen = UIColor(red: 232/255, green: 246/255, blue: 245/255, alpha: 1)

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, CalendarManagerDelegate {
    
    
    @IBOutlet weak var activeTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caroLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var recordView: UIView!
    var isFirstTime = true
    @IBOutlet weak var calendarView: FSCalendar!
    var todayDate: Date = Date() // 保存今天的日期
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    var tapGesture: UITapGestureRecognizer?
    let healthManager = HealthManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarManager.share.FSCalendar = calendarView
        calendarViewHeight.constant = 200
        calendarManager.share.setConfig()
        calendarManager.share.delegate = self
        
        
        updateDateTitle(todayDate)
        if !isFirstTime {
        calendarManager.share.selectTodayWeekdayLabel()
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    if isFirstTime {
        isFirstTime = false
        calendarManager.share.selectTodayWeekdayLabel()
    }
       
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        calendarManager.share.resetSelectedState()
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
        ringView.startColor = darkGreen
        ringView.endColor = darkGreen
        ringView.gradientImageScale = 0.3
        ringView.ringWidth = 25
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
        updateProgress(date: date)
    }
    
    
    func updateProgress(date:Date) {
        healthManager.readStepDistance(for: date) { distance in
            guard let distance = distance else {
                return
            }
            
            DispatchQueue.main.async {
                self.distanceLabel.text = String(format: "%.1f 公里",distance)
            }
            
        }
        
        healthManager.readStepCount(for: date) { step in
            guard let step = step else {
                return
            }
            
            DispatchQueue.main.async {
                self.stepLabel.text = String(format: "%.0f 步",step)
            }
            
        }
        healthManager.readCalories(for: date) { calories,progress in
            guard let progress = progress,let calories = calories else {
                return
            }
            
                DispatchQueue.main.async {
                    //更新畫面的程式
                    self.caroLabel.text = String(format: "%.0f 大卡",calories)
                    
                    if progress >= 1.0 {

                        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                            self.ringView.progress = 1.0
                        })
                            
                        
                    } else {
                        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                            self.ringView.progress = progress
                        })
                    }
                }
        }
    }
    

    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     self.calendarViewHeight.constant = bounds.height
    self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if let identifier = segue.identifier, identifier == "fullCalendar",
           let nextVC = segue.destination as? FSCViewController {
            nextVC.VC = self
        }
        
    }
    
    
}
    
