//
//  NBPBaseModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import ObjectMapper

class NBPBaseModel: Mappable {

    var error : NBPErrorModel?
    var setting : Array<NBPSettingModel>?
    var data : String?
    
    required init?(_ map: Map) {
        
    }
    
    init(){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        error       <- map["error"]
        setting     <- map["settings"]
        
        if setting != nil{
            saveSetting(setting!)
        }

    }
    
    
    func saveSetting(setting : [NBPSettingModel])
    {
        let data  = NSKeyedArchiver.archivedDataWithRootObject(setting)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey:"SettingArray" )
    }
    
    
}
