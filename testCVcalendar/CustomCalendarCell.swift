//
//  cell.swift
//  testFSCalender
//
//  Created by YuCheng on 2023/8/22.
//

import FSCalendar
import MKRingProgressView
import HealthKit

class CustomCalendarCell: FSCalendarCell {
    var customView: RingProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the custom view below the contentView
        if configindex == 0 {
            self.titleLabel.isHidden = true
        } else {
            self.titleLabel.isHidden = false
            }
            
        customView = RingProgressView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        customView.startColor = darkGreen
        customView.endColor = lightGreen
        customView.gradientImageScale = 0.5
        customView.ringWidth = 5
        customView.progress = 0.0
        customView.shadowOpacity = 0.0
        
        self.contentView.addSubview(customView)
        
        
    }

    required init!(coder aDecoder: NSCoder!) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if configindex == 1 {
            if let calendar = self.calendar {
                        calendar.calendarWeekdayView.isHidden = true
                    }
            
            let titleHeight: CGFloat = self.bounds.size.height * 4.1 / 5
            var diameter: CGFloat = min(self.bounds.size.height * 5.2 / 15, self.bounds.size.width)
            diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter) * 0.5) : diameter
            shapeLayer.frame = CGRect(x: (bounds.size.width - diameter) / 2,
                                      y: (titleHeight - diameter) / 2,
                                      width: diameter, height: diameter)
            
            let path = UIBezierPath(roundedRect: shapeLayer.bounds, cornerRadius: shapeLayer.bounds.width * 0.5 * appearance.borderRadius).cgPath
            if shapeLayer.path != path {
                shapeLayer.path = path
                
            }
            setCustomView(OffsetY: 12)
        } else {
            setCustomView(OffsetY: 5)
        }
        
        
        
    }
    
    func setCustomView(OffsetY:CGFloat) {
        
        // Calculate the position for customView
                let customViewSize = customView.frame.size
                let cellSize = self.bounds.size
                let customViewX = (cellSize.width - customViewSize.width) / 2

        let customViewY = cellSize.height - customViewSize.height + OffsetY // Adjust vertical position as needed
                // Set the frame for customView
                customView.frame = CGRect(x: customViewX, y: customViewY, width: customViewSize.width, height: customViewSize.height)
        
    }
    
        
}
