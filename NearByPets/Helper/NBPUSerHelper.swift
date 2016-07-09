//
//  NBPUSerHelper.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 12/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPUserHelper: NSObject {

//    var settingArray : []?
    

    class var sharedInstance: NBPUserHelper {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NBPUserHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NBPUserHelper()
        }
        return Static.instance!
    }
    
    class func getFacebookPlaementId()->String{
        
       let placementIds = ["1715459422041023_1715460668707565" , "1715459422041023_1722420624678236", "1715459422041023_1722420858011546", "1715459422041023_1733073733612925", "1715459422041023_1733075816946050", "1715459422041023_1733076470279318", "1715459422041023_1733091376944494", "1715459422041023_1733091443611154" , "1715459422041023_1733091633611135", "1715459422041023_1733091776944454", "1715459422041023_1733091816944450"]
        
        let random = Int(arc4random_uniform(UInt32(placementIds.count)))
        print("Placement ID -"  + placementIds[random])
        return placementIds[random]
    }
    
    
    
   class func facebookAdAfterRow() ->Int {
        
        var facebookAdCount = 0
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("SettingArray") as? NSData
        {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [NBPSettingModel]
            
            
            let sortFace = decodedTeams.filter() { $0.configKey! == "FacebookAdPageSize"}
            
            if sortFace.count > 0 {
                
                let settingModel = sortFace[0]
                facebookAdCount = Int(settingModel.configValue!)!
            }

            
            
        }
        
        return facebookAdCount
    }
    
    
    func userInfo() -> NBPUserInfoModel?{
        
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("LoggedInUserInfo") as? NSData
        {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NBPUserInfoModel
            return decodedTeams
        }
        
        return nil
    }
    

}
