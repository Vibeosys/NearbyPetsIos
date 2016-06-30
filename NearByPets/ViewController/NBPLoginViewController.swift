//
//  NBPLoginViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 31/05/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftValidator
import FBSDKCoreKit
//import FBSDKShareKit
import FBSDKLoginKit

class NBPLoginViewController: NBPBaseViewController,ValidationDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet var emailIdTextfield : UITextField?
    @IBOutlet var passwordTextField : UITextField?
    
    let validator = Validator()
     @IBOutlet weak var facebookBg : UIView?
    @IBOutlet weak var loginButton : FBSDKLoginButton?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            
            }, error:{ (validationError) -> Void in
                self.showAlert("Error", message: validationError.errorMessage)
        })
        
        let errorLabel = UILabel()
        validator.registerField(emailIdTextfield!, errorLabel:errorLabel, rules: [RequiredRule(), EmailRule()])
        
        self.loginButton!.readPermissions=["public_profile", "email"]
            
        
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("LoggedInUserInfo") as? NSData
        {
            let userInfo = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NBPUserInfoModel)!
            
            let decodedTeams = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NBPUserInfoModel
            
                self.loadRootViewController()
            
//            print(decodedTeams)
//            print(userInfo)

            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!
            
            var email : String?
            if result.objectForKey("email") != nil{
                email = (result.objectForKey("email") as? String)!
            }
            
//            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            
            
            let registra = NBPUserInfoModel()
            registra.fname = strFirstName
            registra.lname = strLastName
            registra.email = email!
            registra.token = FBSDKAccessToken.currentAccessToken().tokenString!
            registra.source = "2"

            
        let registrationPara = NBPRequestHelper.createRequest(registra, serviceName : "UserRegistration")
            
            print(registrationPara)
            
            
            Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
                .responseString { response in
                    
                    debugPrint(response)
                    let mapper = Mapper<NBPRegistrationModel>()
                    let mappedObject = mapper.map(response.result.value)
                    
                    if response.result.error == nil {
                        if  mappedObject?.error!.errorCode == 0 {
                            
                            self.saveLoggedInUserInfo(mappedObject!.dataObject!)
                            self.loadRootViewController()
//                            self.showAlert("Info", message:mappedObject?.error!.errorMsg  )
                            
                            
                        }else{
                            self.showAlert("Error", message:mappedObject?.error!.errorMsg )
                            
                        }
                    }else{
                        self.showAlert("Error", message: response.result.error?.localizedDescription)
                    }
                    
                    print(mappedObject);
            }

        
        }
            
    let token:FBSDKAccessToken = result.token
    
    print("Token \(FBSDKAccessToken.currentAccessToken().tokenString)")
    print("User ID \(FBSDKAccessToken.currentAccessToken().userID)")
    

    print(result)
}
    
    
    func saveLoggedInUserInfo(userInfo : NBPUserInfoModel )
    {
        let data  = NSKeyedArchiver.archivedDataWithRootObject(userInfo)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey:"LoggedInUserInfo" )
        
    }
    
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
    
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginButtonClicked (sender : UIButton){
        
//        self.loadRootViewController()

        validator.validate(self)

        
    }
    
    
    func loadRootViewController(){
        
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let navCtrl = mainStoryBoard.instantiateViewControllerWithIdentifier("NavigationController")
        
        let rootViewController = mainStoryBoard.instantiateInitialViewController() as! NBPRootViewController
        rootViewController.rootViewController = navCtrl
        
        
        let window : UIWindow =  ((UIApplication.sharedApplication().delegate?.window)!)!
        window.rootViewController = rootViewController
        
        UIView.transitionWithView(window, duration: 0.3, options: .TransitionCrossDissolve, animations: nil, completion: nil)
//        [UIView transitionWithView:window
//            duration:0.3
//            options:UIViewAnimationOptionTransitionCrossDissolve
//            animations:nil
//            completion:nil];
        
        
//
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        
//        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
//        
//        MainViewController *mainViewController = [storyboard instantiateInitialViewController];
//        mainViewController.rootViewController = navigationController;
        
        
        
    }
    

    
    
    // MARK: - Swift Validation Delegate
    
    func validationSuccessful() {
        
        print (validationSuccessful)
        let registrationPara = NBPRequestHelper.createLoginRequest(self.emailIdTextfield!.text!, password: self.passwordTextField!.text!)
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)

                let mapper = Mapper<NBPLoginModel>()
                let mappedObject = mapper.map(response.result.value)
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
//                        NBPUserHelper.sharedInstance.userInfo = mappedObject!.dataObject!
                        self.saveLoggedInUserInfo(mappedObject!.dataObject!)
                        self.loadRootViewController()

                    }else{
                        self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        print("Validation FAILED!")
    }
    
    
    
    // MARK: - Facebook login
    
    @IBAction func facebookSinginButtonClicked(sender: UIButton) {
        
        
        
        self.loginToFacebookWithSuccess(self, successBlock: { () -> () in
            print("Succcess")
//            
//            let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email,gender,birthday"])
//            pictureRequest.startWithCompletionHandler({
//                (connection, result, error: NSError!) -> Void in
//                if error == nil {
//                    print("\(result)")
//                    if result.isKindOfClass(NSDictionary){
//                        
//                        
//                        let resultInfo : NSDictionary = result as! NSDictionary
//                        
//                        var dob = ""
//                        if resultInfo["birthday"] != nil{
//                            dob = String (resultInfo["birthday"]!)
//                        }
//                        var gender = ""
//                        if resultInfo["gender"] != nil{
//                            gender = String(resultInfo["gender"]!)
//                        }
//                        
//                        
////                        self.facebookLogin(String(resultInfo["email"]!), password: String(resultInfo["id"]!), gender:gender, age: dob)
//                    }
//                    
//                } else {
//                    print("\(error)")
//                }
//            })
            
            
        }) { (error) -> () in
            print(error?.description)
        }
    }
    
    let facebookReadPermissions = ["public_profile"]
    //Some other options: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"
    
    func loginToFacebookWithSuccess(callingViewController: UIViewController, successBlock: () -> (), andFailure failureBlock: (NSError?) -> ()) {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            FBSDKLoginManager().logOut()
            //Otherwise do:
            return
        }
        
        FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: callingViewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                FBSDKLoginManager().logOut()
                failureBlock(error)
            } else if result.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
                failureBlock(nil)
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                var allPermsGranted = true
                
                //result.grantedPermissions returns an array of _NSCFString pointers
                let grantedPermissions = Array(result.grantedPermissions).map( {"\($0)"} )
                for permission in self.facebookReadPermissions {
                    if !grantedPermissions.contains(permission) {
                        allPermsGranted = false
                        break
                    }
                }
                if allPermsGranted {
                    // Do work
                    let fbToken = result.token.tokenString
                    let fbUserID = result.token.userID
                    
                    //Send fbToken and fbUserID to your web API for processing, or just hang on to that locally if needed
                    //self.post("myserver/myendpoint", parameters: ["token": fbToken, "userID": fbUserId]) {(error: NSError?) ->() in
                    //  if error != nil {
                    //      failureBlock(error)
                    //  } else {
                    //      successBlock(maybeSomeInfoHere?)
                    //  }
                    //}
                    
                    successBlock()
                } else {
                    //The user did not grant all permissions requested
                    //Discover which permissions are granted
                    //and if you can live without the declined ones
                    successBlock()
                }
            }
        })
    }
    
    
    
}
