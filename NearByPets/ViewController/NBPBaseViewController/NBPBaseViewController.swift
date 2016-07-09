//
//  NBPBaseViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 03/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import FBSDKCoreKit
import FBSDKLoginKit

class NBPBaseViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKAppEvents.activateApp()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openLeftMenu(sender:UIBarButtonItem ) {

        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rootViewController().showLeftViewAnimated(true, completionHandler: nil)
        
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



extension UIViewController{
    

    func showAlert(title: String?, message: String?){
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            
            print("showAlert")
        }
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: callActionHandler)
        alertView.addAction(defaultAction)
        alertView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
}