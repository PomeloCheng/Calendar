//
//  smallRecordContentVC.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/31.
//

import UIKit

class smallRecordContentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var recordTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return 2
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTable.dataSource = self
        recordTable.delegate = self
        view.backgroundColor = .white
        recordTable.separatorStyle = .none
        recordTable.backgroundColor = .white
        
    }
    
}
