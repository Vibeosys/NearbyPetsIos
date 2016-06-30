//
//  NBPRequestHelper.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import EVReflection

class NBPRequestHelper {
    
    
    
    class func createRegistrationRequest(firstName : String ,lastName : String , emailId : String , password : String , phoneNumber : String ) -> [String: AnyObject] {
        
        
        let user = ["roleId" : "0"]
        
        let operationData = ["fname":firstName,"lname" :lastName,"phone":phoneNumber,"email" : emailId,"password" : password,"source" : "1","url" : ""]
        

        var str = ""
        do{
            
            str = try NBPRequestHelper.jsonStringWithJSONObject(operationData)!
            print(str)
            
        }catch {
            print("JSON serialization failed:  \(error)")
        }
        let data = ["operation" : "UserRegistration" , "operationData" : str]
        
        let arrayData = [data]
        let registrationRequest = ["user" : user , "data" : arrayData ]

        return registrationRequest as! [String : AnyObject]

        
    }
    

    
    class func jsonStringWithJSONObject(jsonObject: AnyObject) throws -> String? {
        let data: NSData? = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted)
        
        var jsonStr: String?
        if data != nil {
            jsonStr = String(data: data!, encoding: NSUTF8StringEncoding)
        }
        
        return jsonStr
    }
    
    
    class func createLoginRequest(emailId : String , password : String) -> [String: AnyObject] {
        
        let user = ["userId" : "0"]
        
        let operationData = ["email":emailId,"password" : password]
        
        var str = ""
        do{
            
            str = try NBPRequestHelper.jsonStringWithJSONObject(operationData)!
            print(str)
            
        }catch {
            print("JSON serialization failed:  \(error)")
        }
        
        
        let data = ["operation" : "UserLogin" , "operationData" : str]
        let arrayData = [data]
        
        let loginRequest = ["user" : user , "data" : arrayData ]
        
        return loginRequest as! [String : AnyObject]
    }
    
    class func createForgotRequest(object : EVObject) -> [String: AnyObject] {
        
        let user = ["accessToken" : "token"]
        let jsonString = object.toJsonString()

        let data = ["operation" : "ForgotPassword" , "operationData" : jsonString]
        let arrayData = [data]
        
        let loginRequest = ["user" : user , "data" : arrayData ]
        
        return loginRequest as! [String : AnyObject]
    }
    

    class func createRequest(object : EVObject? , serviceName : NSString) -> [String: AnyObject] {
        
        let userinfo = NBPUserHelper.sharedInstance
//        let dict = userinfo.userInfo.toDictionary()
        
        var userId = ""
        if userinfo.userInfo()?.userid != nil {
            
            userId = userinfo.userInfo()!.userid
        }
        
        var email = ""
        if userinfo.userInfo()?.email != nil {
            email = userinfo.userInfo()!.email
        }
        
        var pwd = ""
        if userinfo.userInfo()?.pwd != nil {
            pwd = userinfo.userInfo()!.pwd
        }
        
        var user = [String : String]()
        var token = ""
        if userinfo.userInfo()?.token != nil {
            token = userinfo.userInfo()!.token
        }
        
        user = ["userId" : userId, "email" : email, "pwd" :  pwd , "accessToken" :token]

        
        if userinfo.userInfo()?.token == nil || token == "" {
            
            user = ["userId" : userId, "email" : email, "pwd" :  pwd ]
            
        }
        
        if userinfo.userInfo()?.email == nil{
            user = ["userId" : userId, "pwd" :pwd ]
        }
        
        
        
        
         var jsonString =  ""
        if object != nil {
            
             jsonString = object!.toJsonString(ConversionOptions.DefaultSerialize)

        }else{
            jsonString =  ""
        }
        
        let data = ["operation" : serviceName , "operationData" : jsonString]
        let arrayData = [data]
        
        let loginRequest = ["user" : user , "data" : arrayData ]
        
        return loginRequest as! [String : AnyObject]
    }
    
    
    

}
