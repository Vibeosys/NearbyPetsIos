//
//  NBPCategoriesViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 08/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import CoreLocation

class NBPCategoriesViewController: UIViewController,CLLocationManagerDelegate {
//
//    let imageNames = ["birdsBanner.jpg", "catsBanner.jpg", "foodBanner.jpg" , "dogsBanner.jpg" , "poultryBanner.jpg", "reptilesBanner.jpg" ]
//    let categoriNames = ["Birds", "Cats", "Food" , "Dogs" , "Poultry", "Reptiles" ]
    
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    var categories : [NBPCategoryInfo]?
    var products : Array <NBPProductDetail>?
    var selectedCatId = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        textView?.scrollEnabled = false
        isLocationUpdate = false
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var row = 0
        if self.categories != nil {
            row = self.categories!.count
        }
        return row
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : NBPCategoriesCell = tableView.dequeueReusableCellWithIdentifier("NBPCategoriesCell", forIndexPath: indexPath) as! NBPCategoriesCell
        
        let category = categories![indexPath.row]

        cell.categoryName?.text = category.title
        cell.categoryImage?.image = UIImage(named:"default_pet_image.jpg")
        cell.categoryImage?.imageFromUrl(category.image)
        cell.numberOfProducts?.text = String(category.products) + " products"

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        let category = categories![indexPath.row]
        
        let model = NBPLocationInfo()
        model.latitude = String(locationManager.location!.coordinate.latitude)
        model.longitude = String(locationManager.location!.coordinate.longitude)
        model.pageNumber = 1
        model.categoryId = String(category.categoryId)
        self.selectedCatId = category.categoryId
        
        let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "ClassifiedAdsIos")
        print (registrationPara)
        
        NBPWebServices.getSavedAds(self, parameters: registrationPara, completion: { (response) in
            
            print(response)
            self.products = response as? Array<NBPProductDetail>
            self.performSegueWithIdentifier("NBPCategoryToProductList", sender: self)
            
        })
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // MARK: - Navigation
        if (segue.identifier == "NBPCategoryToProductList") {
            
            if let viewController: NBPMyPostedAdsViewController = segue.destinationViewController as? NBPMyPostedAdsViewController {
                viewController.products = self.products!
                viewController.pageNumber = 1
                viewController.sortBy = .DateDesc
                viewController.operationData = "ClassifiedAdsIos"
                viewController.navTitle =  "Classsified Ads"
                viewController.showAdsBy = .Category
                viewController.categoryId = self.selectedCatId
                viewController.dateSortedProducts = self.sortProducts(self.products!)
            
                
                
            }
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
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    
    
    
    
}
