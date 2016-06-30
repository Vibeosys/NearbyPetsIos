//
//  UIColorExtensions.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 12/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(rgb: UInt, withAlpha: Float) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(withAlpha)
        )
    }
    
}



extension NSDate {
    var timeInterval:Double {
        return self.timeIntervalSinceReferenceDate
    }
    
    var age:Int {
        return NSCalendar.currentCalendar()
            .components(NSCalendarUnit.Year,
                fromDate: self,
                toDate: NSDate(),
                options: NSCalendarOptions(rawValue: 0)).year
    }
    
    
    func stringFromDate ()-> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    func localTimeStringFromDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.locale = NSLocale.currentLocale()
        return dateFormatter.stringFromDate(self)
        
    }
    
    func timeStringFromDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(self)

    }
    func stringForReportFromDate ()-> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    func shortDayString ()-> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.stringFromDate(self)
    }
    
    func getDayOfWeek(today:String)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Sun"
            case 2:
                return "Mon"
            case 3:
                return "Tue"
            case 4:
                return "Wed"
            case 5:
                return "Thu"
            case 6:
                return "Fri"
            case 7:
                return "Sat"
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }

}
