//
//  NBPSettingModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import ObjectMapper
import EVReflection

class NBPSettingModel: EVObject , Mappable {
    
    
    var configKey : String?
    var configValue : String?
    
    required init?(_ map: Map) {
        
    }
    
    required init(){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        configKey    <- (map["configKey"])
        configValue    <- (map["configValue"])
    }
    


    required init(coder aDecoder: NSCoder) {
        self.configKey = aDecoder.decodeObjectForKey("configKey") as? String
        self.configValue = aDecoder.decodeObjectForKey("configValue") as? String
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.configKey, forKey: "configKey")
        aCoder.encodeObject(self.configValue, forKey: "configValue")
    }
    
}



class NBPUpdateSettingModel : EVObject{
    
    var userId : String = ""
    var radiusInKm : String = ""
    
}


