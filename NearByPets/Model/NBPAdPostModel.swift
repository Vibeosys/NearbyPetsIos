//
//  NBPAdPostModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 23/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

import EVReflection
import ObjectMapper


class NBPAdPostModel: NBPBaseModel {
    
    
    var dataObject : NBPAdPostInfo?
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
        dataObject = NBPAdPostInfo(json: data)
        
    }
    
    
}

class NBPAdPostInfo: EVObject {
    // For drop Down
    var title : String = ""
    var categoryId  = 0
    
    var address : String = ""
    var displayAddress : String = ""
    var latitude = ""
    var longitude = ""
    var typeId = 1
    var price = ""
    var userId = ""
    var images = [NBPImageInfo]()
    var descriptionIos : String    = ""
    var city  = ""
    var isDisplayFullAddress = true
    var isAddress = 1
    var selectedTypeIndex = 1
    var proTitle = ""
    var proDiscription = ""
    
}

class NBPImageInfo: EVObject {
    var imageId = 0
    var imageFileName : String = ""
    var imageData : String = ""

}

class NBPAddToFavoriteModel: EVObject {
    // For drop Down
    var adId = ""
    var userId = ""

    
}

