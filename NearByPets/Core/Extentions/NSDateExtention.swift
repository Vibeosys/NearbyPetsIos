//
//  NSDateExtention.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 24/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

extension NSDate  {

    class func getDateString(date:NSDate)->String
    {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.stringFromDate(date)
        return strDate
    }
    
    
}




extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
