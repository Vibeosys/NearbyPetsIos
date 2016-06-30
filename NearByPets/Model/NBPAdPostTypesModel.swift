//
//  NBPAdPostTypesModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 19/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//


import EVReflection
import ObjectMapper


class NBPAdPostTypesModel: NBPBaseModel {
    
    
    var dataObject : [NBPAdPostTypesInfo]?
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
        dataObject = [NBPAdPostTypesInfo](json: data)
        
    }
    
    
}

class NBPAdPostTypesInfo: EVObject {
    
    var typeTitle : String = ""
    var typeId  = 0
    
}
