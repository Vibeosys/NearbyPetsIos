//
//  LeftMenuController.swift
//  Fixtures
//
//  Created by C332268 on 12/02/16.
//  Copyright © 2016 C332268. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import FBSDKCoreKit
//import FBSDKShareKit
import FBSDKLoginKit

class LeftMenuController: UITableViewController, CLLocationManagerDelegate  {
//@property (strong, nonatomic) UIColor *tintColor;
    
    var arrayOfStrings: [String] = ["","Home","My Profile", "My Favorite Ads", "My Posted Ads","View Categories", "Post a new ad","Setting","Logout"]
    var arrayOfIcons: [String] = ["","home_Menu", "ic_perm_identity_black_24dp", "ic_perm_media","ic_slideshow", "ic_send","ic_send","ic_settings","ic_action_io"]

    
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    
    internal var tintColor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        textView?.scrollEnabled = false
        isLocationUpdate = false
        self.tableView.backgroundColor = UIColor.whiteColor()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfStrings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.row == 0 {
            
            let uerinfo = NBPUserHelper.sharedInstance.userInfo
            let cell : NBPLeftMenuUserInfoCell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! NBPLeftMenuUserInfoCell
            if uerinfo()?.fname != nil && uerinfo()?.lname != nil {
                cell.userName!.text =  uerinfo()!.fname + " " + uerinfo()!.lname
            }
            if uerinfo()?.email != nil {
            cell.emailId!.text =  uerinfo()!.email
            }
            
            return cell

        }
        // Configure the cell...
        let cell : LeftMenuTableViewCell = tableView.dequeueReusableCellWithIdentifier("leftMenuIdentifier", forIndexPath: indexPath) as! LeftMenuTableViewCell
        cell.title?.text = arrayOfStrings[indexPath.row]
        cell.icon?.image = UIImage(named: arrayOfIcons[indexPath.row])
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        if indexPath.row == 1{
            let homeViewController : NBPDashboardViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPDashboardViewController") as! NBPDashboardViewController
            appDelegate.rootNavigationController().pushViewController(homeViewController, animated: true)
            appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)

        }
        else if indexPath.row == 2 {
            

            let userinfo = NBPUserHelper.sharedInstance

            let registrationPara = NBPRequestHelper.createRequest(userinfo.userInfo()! ,serviceName : "GetProfile")
            print (registrationPara)
            
            
            NBPWebServices.getProfile(self, parameters: registrationPara, completion: { (response) in
                
                print(response)
                
                let profileViewController : NBPMyProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPMyProfileViewController") as! NBPMyProfileViewController
                profileViewController.userInfo = response as? NBPUserInfoModel
                appDelegate.rootNavigationController().pushViewController(profileViewController, animated: true)
                kRootViewController.hideLeftViewAnimated(true, completionHandler: nil)
                
                
            })

            
        }else if indexPath.row == 3 {
            
            
//            let model = NBPLocationInfo()
//        model.latitude = String(locationManager.location!.coordinate.latitude)
//        model.longitude = String(locationManager.location!.coordinate.longitude)
//        model.pageNumber = 1
//            
//            model.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
//            
//            let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "GetSavedAdIos")
//            print (registrationPara)
//            
//            NBPWebServices.getSavedAds(self, parameters: registrationPara, completion: { (response) in
            
//                print(response)
                let sheduleViewController : NBPMyPostedAdsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPMyPostedAdsViewController") as! NBPMyPostedAdsViewController
                sheduleViewController.operationData = "GetSavedAdIos"
                sheduleViewController.pageNumber = 1
                sheduleViewController.navTitle =  "My Favorite Ads"
                sheduleViewController.showAdsBy = .MyFavorite
                sheduleViewController.categoryId = 0
//                sheduleViewController.products = (response as? Array<NBPProductDetail>)!
                sheduleViewController.sortBy = .DateDesc
//                sheduleViewController.dateSortedProducts = self.sortProducts((response as? Array<NBPProductDetail>)!)
            
                
                appDelegate.rootNavigationController().pushViewController(sheduleViewController, animated: true)
                appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)
                
//                
//                let mySavedAdController : NBPMySavedAdsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPMySavedAdsViewController") as! NBPMySavedAdsViewController
//                mySavedAdController.products = response as? Array<NBPProductDetail>
//                appDelegate.rootNavigationController().pushViewController(mySavedAdController, animated: true)
//                appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)
                
                
//            })

        }else if indexPath.row == 4{
//            let model = NBPLocationInfo()
//            model.latitude = String(locationManager.location!.coordinate.latitude)
//            model.longitude = String(locationManager.location!.coordinate.longitude)
//            model.pageNumber =  1
//            model.userid = NBPUserHelper.sharedInstance.userInfo()!.userid
//            model.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
//            let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "MyPostedAdsIos")
//            print (registrationPara)
//            
//            NBPWebServices.getSavedAds(self, parameters: registrationPara, completion: { (response) in
            
//                print(response)

            let sheduleViewController : NBPMyPostedAdsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPMyPostedAdsViewController") as! NBPMyPostedAdsViewController
            sheduleViewController.operationData = "MyPostedAdsIos"
            sheduleViewController.pageNumber = 1
             sheduleViewController.navTitle =  "My Posted Ads"
                sheduleViewController.showAdsBy = .MyPosted
                sheduleViewController.categoryId = 0
//            sheduleViewController.products = (response as? Array<NBPProductDetail>)!
            sheduleViewController.sortBy = .DateDesc
//            sheduleViewController.dateSortedProducts = self.sortProducts((response as? Array<NBPProductDetail>)!)
            
                
            appDelegate.rootNavigationController().pushViewController(sheduleViewController, animated: true)
            appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)
                
//            })
            
        }else if indexPath.row == 5 {
            
            let registrationPara = NBPRequestHelper.createRequest(nil ,serviceName : "CategoryList")
            print (registrationPara)
            
            NBPWebServices.getCategoryList(self, parameters: registrationPara) { (response) in
                
                let addNewPostViewController : NBPCategoriesViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPCategoriesViewController") as! NBPCategoriesViewController
                addNewPostViewController.categories = response as? [NBPCategoryInfo]
                appDelegate.rootNavigationController().pushViewController(addNewPostViewController, animated: true)
                appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)
                
            }
            
        

            
            
        }else if indexPath.row == 6 {
            let addNewPostViewController : NBPAddNewPostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPAddNewPostViewController") as! NBPAddNewPostViewController
            appDelegate.rootNavigationController().pushViewController(addNewPostViewController, animated: true)
            appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)
        }        else if indexPath.row == 7 {
            
            
            
            let userinfo = NBPUserHelper.sharedInstance
            
            let registrationPara = NBPRequestHelper.createRequest(userinfo.userInfo()! ,serviceName : "GetProfile")
            print (registrationPara)
            
            
            NBPWebServices.getProfile(self, parameters: registrationPara, completion: { (response) in
                
                print(response)
                
                let settingViewController : NBPSettingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NBPSettingViewController") as! NBPSettingViewController
                settingViewController.userInfo = response as? NBPUserInfoModel

                appDelegate.rootNavigationController().pushViewController(settingViewController, animated: true)
                appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)

                
                
            })
            

            
        }

        if indexPath.row == 8 {
             self.showLogOutAlert("Alert", message: "LogOut")
        }

        
    }

    
    func sortProducts(products : [NBPProductDetail]) -> [NBPDateSortedProduct]{
        
        var dates = [NSDate]()
        var dateSortedProducts = [NBPDateSortedProduct]()
        
        for product in products {
            product.postedDateString = NSDate.getDateString(product.postedDate!)
            dates.append(product.postedDate!)
        }
        
        var  uniqDates = dates.unique
        
        
        uniqDates = uniqDates.sort { $0.0 .compare($0.1) == NSComparisonResult.OrderedDescending }
        print(uniqDates)
        
        for date in uniqDates {
            let datePro = NBPDateSortedProduct()
            datePro.products = products.filter() { $0.postedDate! == date }
            datePro.date = date
            datePro.dateString = NSDate.getDateString(date)
            dateSortedProducts.append(datePro)
        }
        
        
        print(uniqDates)
        //        if sortBy = .Date{
        //
        //
        //        }
        
      return dateSortedProducts
    }
    
    override func showAlert(title: String?, message: String?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showLogOutAlert(title: String?, message: String?){
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            
            action in
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey("LoggedInUserInfo")
            defaults.synchronize()
            
            
            self.logInViewShow()
            }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {
            action in
            
            }
        )
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: false, completion: nil)

    }
    
    func logInViewShow(){
    
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
        
        let navigationController = loginStoryBoard.instantiateInitialViewController()!
        
        let window : UIWindow =  ((UIApplication.sharedApplication().delegate?.window)!)!
        window.rootViewController = navigationController
        
    }
    
    
    
    // MARK: - locationManager delegate
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let coord = location.coordinate
        
        print(coord.latitude)
        print(coord.longitude)
        if   isLocationUpdate == false{
            isLocationUpdate = true
        }

        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    
    
    
    
//
//    func loadRateFeelingViewController(){
//        let appDelegate =
//            UIApplication.sharedApplication().delegate as! AppDelegate
//        let sheduleViewController : RateFeelingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RateFeelingViewController") as! RateFeelingViewController
//        appDelegate.rootNavigationController().pushViewController(sheduleViewController, animated: true)
//        appDelegate.rootViewController().hideLeftViewAnimated(true, completionHandler: nil)
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
