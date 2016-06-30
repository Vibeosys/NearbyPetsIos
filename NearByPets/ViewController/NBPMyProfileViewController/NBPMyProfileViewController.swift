//
//  NBPMyProfileViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPMyProfileViewController: NBPBaseViewController {

    @IBOutlet var firstName : UITextField?
    @IBOutlet var lastName : UITextField?
    @IBOutlet var phoneNo : UITextField?
    @IBOutlet var emailId : UITextField?
    @IBOutlet var pwd : UITextField?
    
    var userInfo : NBPUserInfoModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.firstName?.text = userInfo?.fname
        self.lastName?.text = userInfo?.lname
        self.emailId?.text = userInfo?.email
        self.phoneNo?.text = userInfo?.phone
         self.pwd?.text = userInfo?.pwd
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateButtonClicked(sender : UIButton){
        
        
        let model = NBPUserInfoModel()
        model.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        model.fname = (self.firstName?.text)!
        model.lname = (self.lastName?.text)!
        model.email = (self.emailId?.text)!
        model.phone = (self.phoneNo?.text)!
        model.pwd = (self.pwd?.text)!
        
        
        let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "UserProfileUpdate")
        print (registrationPara)
        
        NBPWebServices.UserProfileUpdate(self, parameters: registrationPara, completion: { (response) in
            
            self.saveLoggedInUserInfo(response as! NBPUserInfoModel)

            print(response)
            
        })

        
    }

    
    func saveLoggedInUserInfo(userInfo : NBPUserInfoModel )
    {
        let data  = NSKeyedArchiver.archivedDataWithRootObject(userInfo)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey:"LoggedInUserInfo" )
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
