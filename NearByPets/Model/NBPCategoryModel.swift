//
//  NBPCategoryModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 18/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import EVReflection
import ObjectMapper


class NBPCategoryModel: NBPBaseModel {
    
    
    var dataObject : [NBPCategoryInfo]?
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
        dataObject = [NBPCategoryInfo](json: data)
        
    }
    
    
}

class NBPCategoryInfo: EVObject {
    // For drop Down
    var categoryTitle : String = ""
    var categoryId  = 0
    
    
    //For Display Categories
    var title : String = ""
    var image : String = ""
    var products  = 0
    

}
