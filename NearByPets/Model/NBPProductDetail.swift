//
//  NBPProductDetail.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 13/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import EVReflection
import ObjectMapper


class NBPProductModel: NBPBaseModel {

    
     var dataObject : [NBPProductDetail]?
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
        dataObject = [NBPProductDetail](json: data)
        
    }
    
    
}


class NBPProductDetail: EVObject {

    
    var adid : String = ""
    var name : String = ""
    var price : String = ""
    var distance : Float = 0.0
    var roleid : Int = 0
    var image : String = ""
    var date : NSDate?
    var postedDate : NSDate?
    var displayAddress = ""
    var adAddress = ""
    var adTitle = ""
    var phone = ""
    var images = []
    var longitude =  0.0
    var email = ""
    var productDesc = ""
    var postedDateString = ""
    override var description : String {
        return ""
    }
    
    
}

class NBPProductDetailModel: NBPBaseModel {
    
    
    var dataObject : NBPProductDetailInfo?
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
        dataObject = NBPProductDetailInfo(json: data)
        
    }
    
    
}

class NBPProductDetailInfo: EVObject {
    
    var adId : String = ""
    var name : String = ""
    var price : String = ""
    var distance : Float = 0.0
    var roleid : Int = 0
    var image : String = ""
    var date : NSDate?
    var postedDate : NSDate?
    var displayAddress = ""
    var adAddress = ""
    var adTitle = ""
    var phone = ""
    var images = []
    var longitude =  0.0
    var latitude = 0.0
    var email = ""
    var isAddress = 0
    var adViews = 0
    var productDesc = ""
    var userId = ""
    override var description : String {
        return ""
    }
    
    
}


class NBPDateSortedProduct : EVObject{
    
    var dateString = ""
    var date : NSDate?
    var products  : [NBPProductDetail]?
    
}


