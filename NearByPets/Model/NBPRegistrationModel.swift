//
//  NBPRegistrationModel.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import ObjectMapper
import EVReflection

class NBPRegistrationModel: NBPBaseModel {
    
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


class NBPUserInfoModel : EVObject{
    
    var email : String = ""
    var fname : String = ""
    var lname : String = ""
    var phone : String = ""
    var pwd : String = ""
    var roleid : Int64 = 0
    var token : String = ""
    var userid : String = ""
    var source : String = ""
    var radiusInKm : Int = 0
    
    var userId : String = ""
    
    
    
    required init(coder aDecoder: NSCoder) {
        self.email = (aDecoder.decodeObjectForKey("email") as? String)!
        self.userid = (aDecoder.decodeObjectForKey("userid") as? String)!
        
        if aDecoder.decodeObjectForKey("pwd") != nil {
            self.pwd = (aDecoder.decodeObjectForKey("pwd") as? String)!
        }
        
        if aDecoder.decodeObjectForKey("token") != nil {
            self.token = (aDecoder.decodeObjectForKey("token") as? String)!
        }
        
        if aDecoder.decodeObjectForKey("fname") != nil {
            self.fname = (aDecoder.decodeObjectForKey("fname") as? String)!
        }
        
        if aDecoder.decodeObjectForKey("lname") != nil {
            self.lname = (aDecoder.decodeObjectForKey("lname") as? String)!
        }
        
        
        
        
        
        
    }
    
    required init(){
        
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.userid, forKey: "userid")
        aCoder.encodeObject(self.token, forKey: "token")
        aCoder.encodeObject(self.pwd, forKey: "pwd")
        aCoder.encodeObject(self.fname, forKey: "fname")
        aCoder.encodeObject(self.lname, forKey: "lname")
        
    }
    
    

}


