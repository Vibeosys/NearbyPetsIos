//
//  NBPWebServices.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 19/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import Alamofire
import ObjectMapper


class NBPWebServices: NSObject {

    
    class func getProfile(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        Alamofire.request(.POST, BASE_URL, parameters: parameters, encoding: .JSON, headers: nil)
            .responseJSON{ response in
                
                debugPrint(response)

                let mapper  = Mapper<NBPRegistrationModel>()
                
                let mappedObject = mapper.map(response.result.value)
                
                if (response.result.error == nil ){
                    if  mappedObject?.error?.errorCode == 0
                    {
                        completion(response:mappedObject!.dataObject!)
                    } else
                    {
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                    }
                    
                }
                else
                {
                   objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
        }
        
    }

    
    
    class func getCategoryList(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        Alamofire.request(.POST, BASE_URL, parameters: parameters, encoding: .JSON, headers: nil)
            .responseJSON{ response in
                
                debugPrint(response)
                
                let mapper  = Mapper<NBPCategoryModel>()
                
                let mappedObject = mapper.map(response.result.value)
                
                if (response.result.error == nil ){
                    if  mappedObject?.error?.errorCode == 0
                    {
                        completion(response:mappedObject!.dataObject!)
                    } else
                    {
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                    }
                    
                }
                else
                {
                    objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
        }
        
    }
    
    
    class func SaveSettings(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        Alamofire.request(.POST, BASE_URL, parameters: parameters, encoding: .JSON, headers: nil)
            .responseJSON{ response in
                
                debugPrint(response)
                
                let mapper  = Mapper<NBPBaseModel>()
                
                let mappedObject = mapper.map(response.result.value)
                
                if (response.result.error == nil ){
                    if  mappedObject?.error?.errorCode == 0
                    {
                         objSelf.showAlert("Info", message:mappedObject?.error?.errorMsg )
                        completion(response:mappedObject!)
                    } else
                    {
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                    }
                    
                }
                else
                {
                    objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
        }
        
    }
    
    

    
    class func getSavedAds(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        Alamofire.request(.POST, BASE_URL, parameters:parameters, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                
                let mapper = Mapper<NBPProductModel>()
                let mappedObject = mapper.map(response.result.value)

                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        
                        completion(response:(mappedObject?.dataObject)!)
                        
                    }else{
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }

    
    class func addToFavorite(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        
        Alamofire.request(.POST, BASE_URL, parameters:parameters, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                
                let mapper = Mapper<NBPBaseModel>()
                let mappedObject = mapper.map(response.result.value)
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        objSelf.showAlert("Info", message:mappedObject?.error?.errorMsg )
                        completion(response:(mappedObject)!)
                        
                    }else{
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }
    
    
    class func statusChange(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        
        Alamofire.request(.POST, BASE_URL, parameters:parameters, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                
                let mapper = Mapper<NBPBaseModel>()
                let mappedObject = mapper.map(response.result.value)
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        completion(response:(mappedObject)!)
                        
                    }else{
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }
    
    
    
    
    
    class func UserProfileUpdate(objSelf:UIViewController, parameters:[String:AnyObject] , completion:(response:AnyObject)->()){
        
        
        Alamofire.request(.POST, BASE_URL, parameters:parameters, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                
                let mapper = Mapper<NBPRegistrationModel>()
                let mappedObject = mapper.map(response.result.value)
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        objSelf.showAlert("Info", message:mappedObject?.error?.errorMsg )
                        completion(response:(mappedObject!.dataObject)!)
                        
                    }else{
                        objSelf.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    objSelf.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }
    
    
}
