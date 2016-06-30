//
//  NBPLoginModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 12/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//


import ObjectMapper
import EVReflection

class NBPLoginModel: NBPBaseModel {
    
 var dataObject : NBPUserInfoModel?
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map)
        data    <- map["data"]
        dataObject = NBPUserInfoModel(json: data)
        
    }
    
    
}


class NBPForgotPasswordModel : EVObject{
    
    var email : String = ""
    
}


