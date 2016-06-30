//
//  NBPErrorModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import ObjectMapper

class NBPErrorModel: Mappable {
    
    var errorCode : NSInteger?
    var errorMsg : String?
    
    required init?(_ map: Map) {
        
    }
    
    init(){
        
    }
    
    // Mappable
    func mapping(map: Map) {

        errorCode    <- (map["errorCode"])
        errorMsg    <- (map["message"])
    }

    

}
