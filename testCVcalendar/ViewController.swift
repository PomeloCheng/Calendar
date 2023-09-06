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
import Lottie

var configindex: Int?

//var darkGreen = UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1)
var darkGreen = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
var lightGreen = UIColor(red: 232/255, green: 246/255, blue: 245/255, alpha: 1)
var redColor = UIColor(red: 239/255, green: 115/255, blue: 110/255, alpha: 1)
var todayDate = Date() // 保存今天的日期


class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, CalendarManagerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var isGoalLabel: UILabel!
    @IBOutlet weak var cancelAnimation: LottieAnimationView!
    @IBOutlet weak var checkAnimation: LottieAnimationView!
    @IBOutlet weak var activeTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caroLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var recordView: UIView!
    var isFirstTime = true
    var isFirstRead = true
    @IBOutlet weak var calendarView: FSCalendar!
    
    var selectData: Date?
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    var tapGesture: UITapGestureRecognizer?
    let healthManager = HealthManager.shared
    
    
    
    @IBOutlet weak var healthTitleLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstRead {
            calendarManager.shared.FSCalendar = calendarView
            calendarViewHeight.constant = 200
            calendarManager.shared.setConfig()
            calendarManager.shared.delegateMainVC = self
            
            updateDateTitle(todayDate)
//            if !isFirstTime {
//                calendarManager.shared.selectTodayWeekdayLabel()
//            }
//
            isFirstRead = false // 设置为 false，以确保不再执行此部分代码
        } else {
            if let selectData = selectData {
                calendarManager.shared.dateToWeekday(selectData)
            }
        }
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    if isFirstTime {
        isFirstTime = false
        calendarManager.shared.selectTodayWeekdayLabel()
    }
       
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        calendarManager.shared.resetSelectedState()
    }
    
    
    @IBOutlet weak var ringView: RingProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // Do any additional setup after loading the view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
        
        calendarView.scope = .week
        ringView.startColor = darkGreen
        ringView.endColor = darkGreen
        ringView.gradientImageScale = 0.3
        ringView.ringWidth = 25
        ringView.progress = 0.0
        ringView.shadowOpacity = 0.0
        checkAnimation.isHidden = true
        cancelAnimation.isHidden = true
        isGoalLabel.isHidden = true
        healthTitleLabel.isHidden = true
        
        
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        calendarManager.shared.weekdayLabelTapped(sender)
    }
    
    func updateDateTitle(_ date: Date) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "Y 年 M 月 d 日"
            let dateString = dateFormatter.string(from: date)
        navigationItem.title = dateString
        updateProgress(date: date)
        selectData = date
        healthManager.readWorkData(for: date) { exerciseDatas in
            if let exerciseDatas = exerciseDatas {
                
                if !exerciseDatas.isEmpty {
                    DispatchQueue.main.async {
                        self.healthTitleLabel.isHidden = true
                    }
                }else{
                    DispatchQueue.main.async {
                        self.healthTitleLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    
    func updateProgress(date:Date) {
        if date > Date() {
            setDefaultData()
            
        } else {
            self.ringView.layer.opacity = 1.0
            setHealthData(date)
        }
        
        
    }
    
    func setDefaultData(){
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                self.ringView.progress = 0
            })
            self.checkAnimation.isHidden = true
            self.cancelAnimation.isHidden = true
            self.isGoalLabel.isHidden = true
            self.ringView.layer.opacity = 0.2
            self.activeTimeLabel.text = " -- 分鐘"
            self.distanceLabel.text = " -- 公里"
            self.stepLabel.text = " -- 步"
            self.caroLabel.text = " -- 大卡"
    }
    
    func setHealthData(_ date: Date){
        healthManager.readStepDistance(for: date) { activeTime in
            guard let activeTime = activeTime else {
                return
            }
            
            DispatchQueue.main.async {
                self.activeTimeLabel.text = String(format: "%.0f 分鐘",activeTime)
            }
            
        }
        healthManager.readStepDistance(for: date) { distance in
            guard let distance = distance else {
                return
            }
            
            DispatchQueue.main.async {
                self.distanceLabel.text = String(format: "%.2f 公里",distance)
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
                
                DispatchQueue.main.async {
                //更新畫面的程式
                    self.checkAnimation.isHidden = true
                    self.cancelAnimation.isHidden = false
                    self.ringView.progress = 0
                    self.ringView.layer.opacity = 0.2
                }
                

                return
            }
            
            
            DispatchQueue.main.async {
                //更新畫面的程式
                self.caroLabel.text = String(format: "%.0f 大卡",calories)
                
                if progress >= 1.0 {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.ringView.progress = 1.0
                    })
                    self.checkAnimation.isHidden = false
                    self.cancelAnimation.isHidden = true
                    self.isGoalLabel.isHidden = false
                    self.isGoalLabel.text = "已達成目標"
                    self.isGoalLabel.textColor = darkGreen
                    let anim = LottieAnimation.named("check.json")
                    self.checkAnimation.animation = anim
                    self.checkAnimation.contentMode = .scaleAspectFill
                    self.checkAnimation.play()
                    
                } else {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.ringView.progress = progress
                    })
                    self.checkAnimation.isHidden = true
                    self.cancelAnimation.isHidden = false
                    self.isGoalLabel.isHidden = false
                    self.isGoalLabel.text = "尚未達成目標"
                    self.isGoalLabel.textColor = redColor
                    
                    let anim = LottieAnimation.named("undone.json")
                    self.cancelAnimation.animation = anim
                    self.cancelAnimation.contentMode = .scaleAspectFill
                    self.cancelAnimation.play()
                }
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     self.calendarViewHeight.constant = bounds.height
    self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     

        
        if segue.identifier == "fullCalendar",
           let nextVC = segue.destination as? FSCViewController {
            nextVC.bigCalendarVC = self
        }
        
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}
    
