//
//  smallRecordContentVC.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/31.
//

import UIKit
import HealthKit


class smallRecordContentVC: UIViewController, UITableViewDataSource, UITableViewDelegate,CalendarManagerDelegate {
    func updateDateTitle(_ date: Date) {
        
        healthManager.readWorkData(for: date) { exerciseDatas in
            if let exerciseDatas = exerciseDatas {
                self.exerciseData = exerciseDatas
                
                    DispatchQueue.main.async {
                        self.recordTable.reloadData()
                    }
            } 
        }
        
    }
    

    @IBOutlet weak var recordTable: UITableView!
    
    var exerciseData: [HKWorkout] = []
    let healthManager = HealthManager.shared
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !exerciseData.isEmpty {
            return exerciseData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordItemCell") as! recordTableCell
        
        
        cell.recordItemView.layer.cornerRadius = 18
        
        cell.recordItemView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.recordItemView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.recordItemView.layer.shadowOpacity = 0.2
        
        
        //
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替換 "Main" 為你的故事板名稱
            if let targetVC = storyboard.instantiateViewController(withIdentifier: "TargetViewController") as? TargetViewController {
                // 在這裡可以設定目標視圖控制器的屬性或傳遞數據，如果需要的話
                // 例如：targetVC.propertyName = value
                targetVC.indexPath = indexPath
                // 使用導航控制器將目標視圖控制器推送到堆疊中
                navigationController?.pushViewController(targetVC, animated: true)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarManager.shared.delegateTableVC = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTable.dataSource = self
        recordTable.delegate = self
        view.backgroundColor = .white
        recordTable.separatorStyle = .none
        recordTable.backgroundColor = .white
       
        
    }

}
