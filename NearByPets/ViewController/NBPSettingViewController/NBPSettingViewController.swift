//
//  NBPSettingViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPSettingViewController: UIViewController {

    @IBOutlet weak var radiusInKmLabel : UILabel?
    @IBOutlet weak var slider : UISlider?
    var userInfo : NBPUserInfoModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.slider?.value = Float((userInfo?.radiusInKm)!)
        self.radiusInKmLabel?.text = String(Int(slider!.value))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func radiusValueChanged(sender : UISlider){
        
        self.radiusInKmLabel?.text = String(Int(sender.value))
        
    }
    
    
        @IBAction func updateButtonClicked(sender : UIButton){
            
                        let userinfo = NBPUserHelper.sharedInstance
            
            let settingModel = NBPUpdateSettingModel()
            settingModel.userId = (userinfo.userInfo()?.userid)!
            settingModel.radiusInKm = String(Int(self.slider!.value))
            
            
            let registrationPara = NBPRequestHelper.createRequest(settingModel ,serviceName : "UpdateUserRadius")
            print (registrationPara)
            
            NBPWebServices.SaveSettings(self, parameters: registrationPara) { (response) in
//                self.categories = response as? [NBPCategoryInfo]
                print(response)
//                self.performSegueWithIdentifier( "NBPDashboardToCategoriesSegue", sender: self)
                
            }

            
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
