//
//  NBPLocationInfo.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 12/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import EVReflection

class NBPLocationInfo :EVObject{
    
    var latitude : String = "18.5487939"
    var longitude : String = "73.7894986"
    var sortOption : String = "0"
    var sortChoice : String = "DESC"
    var pageNumber : Int = 0
    var userId : String = ""
    var categoryId = "0"
    var search = ""
    var userid : String = ""
    
}


class NBPRequestProductModel :EVObject{
    
    var adId : String = ""
    
}
