//
//  NBPProductDetailViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import CoreLocation
import FBAudienceNetwork

class NBPProductDetailViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var pageControl : UIPageControl?
    var productDetail : NBPProductDetailInfo?
    var distance : Float = 0.0 
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    
    var noOfPages = 0
    var height : CGFloat = 0.0
//    let imageNames = ["dogsBanner.jpg","foodBanner.jpg","reptilesBanner.jpg","poultryBanner.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        noOfPages = (self.productDetail?.images.count)!
        self.locationManagerinstanitate()
        self.pageControl!.numberOfPages = noOfPages
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isLocationUpdate = false
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        
        super.viewDidAppear(true)
        let bounds = UIScreen.mainScreen().bounds
        height = bounds.size.height
        let scrollWidth = Int(bounds.size.width) * noOfPages
        scrollView!.contentSize = CGSizeMake(CGFloat(scrollWidth), (scrollView?.frame.size.height)!)
        
        print(scrollView?.frame.size.height)
        self.addPages()
    }
    
    func locationManagerinstanitate () {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }

    func createImageName(index: Int)-> String{

        print(self.productDetail!.images[index])
        
        return self.productDetail!.images[index] as! String
    }
    
    func addPages(){
        
        var frame: CGRect = CGRectMake(0, 0.0, 0, 0)
        
        for index in 0 ..< noOfPages {
            
            frame.origin.x = self.scrollView!.frame.size.width * CGFloat(index)
            frame.size = self.scrollView!.frame.size
            
            let imageView = UIImageView(frame : frame )
            imageView.contentMode = .ScaleAspectFit
            imageView.backgroundColor = UIColor.blackColor()
            imageView.image = UIImage(named:"default_pet_image.jpg")
            imageView.imageFromUrl(self.createImageName(index))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NBPProductDetailViewController.imageTapped(_:)))
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            self.scrollView! .addSubview(imageView)
        }
        
    }
    
    func imageTapped(img: AnyObject)
    {
        
        self.performSegueWithIdentifier("NBPImageViewerController", sender: self)

//        
//        let viewController = UIViewController()
//        let tappedImageView = img.view!
//        
//        let imageView = UIImageView(image: tappedImageView as? UIImage)
//        
//        viewController.view.addSubview(imageView)
//        self.presentViewController(viewController, animated: true) { 
//            
//        }
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // MARK: - Navigation
        if (segue.identifier == "NBPImageViewerController") {
            
            self.productDetail?.images
            
            if let viewController: NBPImageViewerController = segue.destinationViewController as? NBPImageViewerController {
                
                let imageUrl = self.productDetail?.images[(self.pageControl?.currentPage)!] as! String
                
                viewController.imageUrlString = imageUrl
            }
        }
            

        
    }

    
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let pageWidth = self.scrollView!.frame.size.width;
        let fractionalPage = self.scrollView!.contentOffset.x / pageWidth;
        let page = lround(Double(fractionalPage));
        self.pageControl!.currentPage = page;
        
        
    }
    
    @IBAction func changePage(sender : UIPageControl){
        let x = pageControl!.currentPage * Int (scrollView!.frame.size.width);
        self.scrollView!.setContentOffset(CGPointMake(CGFloat (x ), 0), animated: true)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : NBPProductInfoCell = tableView.dequeueReusableCellWithIdentifier("NBPProductDeailInfoCell", forIndexPath: indexPath) as! NBPProductInfoCell
        cell.title?.text = self.productDetail!.adTitle
        
        if Float(productDetail!.price) != nil {
            
        cell.price?.text = "€ " +   String(format: "%.02f", Float(productDetail!.price)!)
            
        }
//        cell.distance?.text = String(format: "%.01f", self.distance) + " km away from you"  //"The velocity is \(productDetail.distance.string(1))"
        cell.productDescription?.text = String(productDetail!.productDesc)
        
        if  indexPath.row == 3 {
            cell.favButton?.selected = true
        }else{
            cell.favButton?.selected = false
        }
        
        if  indexPath.row == 0 || indexPath.row == 5 {
            let cell : NBPFacebookAdCell =  tableView.dequeueReusableCellWithIdentifier("FacebookAd", forIndexPath: indexPath) as! NBPFacebookAdCell
            
            let adView: FBAdView = FBAdView(placementID:NBPUserHelper.getFacebookPlaementId(), adSize:kFBAdSizeHeight50Banner, rootViewController:self);
            
            adView.loadAd();
            cell.addSubview(adView);
            return cell
            
        }else
        if indexPath.row == 2{
             let sellerCell : NBPSellerInfoCell =  tableView.dequeueReusableCellWithIdentifier("SellerInfo", forIndexPath: indexPath) as! NBPSellerInfoCell
            sellerCell.name?.text = self.productDetail?.name
            sellerCell.phone?.text = self.productDetail?.phone
            sellerCell.email?.text = self.productDetail?.email
            
            if self.productDetail?.isAddress == 2 {
                 sellerCell.aaddressText?.text = "Address:"
                 sellerCell.addressDetail?.text = self.productDetail?.displayAddress
            }else{
                sellerCell.aaddressText?.text = "City:"
                sellerCell.addressDetail?.text = self.productDetail?.displayAddress
            }
            
             return sellerCell
            
        }else if indexPath.row == 3{
             let adDetailCell : NBPAdDetailCell =   tableView.dequeueReusableCellWithIdentifier("AddDetail", forIndexPath: indexPath) as! NBPAdDetailCell
            
            adDetailCell.addedDate?.text =  NSDate.getDateString((self.productDetail?.postedDate!)!)
             adDetailCell.views?.text = String(self.productDetail!.adViews)
             adDetailCell.distance?.text = String(format: "%.01f", self.distance) + " km away from you"
            return adDetailCell
            
        }
        else if indexPath.row == 4{
            
            print(NBPUserHelper.sharedInstance.userInfo()!.email)
             print(self.productDetail!.email)
            if NBPUserHelper.sharedInstance.userInfo()!.email == self.productDetail!.email {
                return tableView.dequeueReusableCellWithIdentifier("MoreActionDetailCell", forIndexPath: indexPath)
                
            }else{
                return tableView.dequeueReusableCellWithIdentifier("ActionDetail", forIndexPath: indexPath)
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func addToFavorite(sender : UIButton){
        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = self.productDetail!.adId
        favModel.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "SaveAnAd")
        print (registrationPara)
        
        NBPWebServices.addToFavorite(self, parameters: registrationPara, completion: { (response) in
            print(response)
           
        })

        
    }
    
    @IBAction func soldOutButtonClicked(sender : UIButton){
        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = self.productDetail!.adId
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "SoldOutPost")
        print (registrationPara)
        
        NBPWebServices.statusChange(self, parameters: registrationPara, completion: { (response) in
            print(response)
            self.showAlert("Info", message:"The Ad is sold out now." )

            
        })
        
        
    }
    
    @IBAction func disableButtonClicked(sender : UIButton){
        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = self.productDetail!.adId
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "DisablePost")
        self.showAlert("Info", message:"The Ad is disabled now." )
        
        NBPWebServices.statusChange(self, parameters: registrationPara, completion: { (response) in
            print(response)
            
        })
        
        
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
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    
    
    
    
    @IBAction func showOnMap(){
    
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(productDetail!.latitude),\(productDetail!.longitude)&directionsmode=driving")!)
            
        } else {
        
            if locationManager.location != nil {
            UIApplication.sharedApplication().openURL(NSURL (string: "http://maps.apple.com/maps?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.latitude)&daddr=\(productDetail!.latitude),\(productDetail!.longitude)")!)
            }else {
                    UIApplication.sharedApplication().openURL(NSURL (string: "http://maps.apple.com/maps?saddr=&daddr=\(productDetail!.latitude),\(productDetail!.longitude)")!)
            }
        }
    }
    
//    if ([[UIApplication sharedApplication] canOpenURL:
//    [NSURL URLWithString:@"comgooglemaps://"]])
//    {
//    NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=traffic",self.latitude,self.longitude];
//    [[UIApplication sharedApplication] openURL:
//    [NSURL URLWithString:urlString]];
//    }
//    else
//    {
//    NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f",self.latitude,self.longitude];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//    }
    
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.textLabel?.textColor = UIColor.init(rgb: 0x03a021)
//        }
//        
//        
//    }
    
//    func tableView(tableView: UITableView,
//                   viewForHeaderInSection section: Int) -> UIView?
//    {
//        // This is where you would change section header content
//        let date = 10 + section
//        
//        
//        let cell : NBPSectionHeaderCell =  (tableView.dequeueReusableCellWithIdentifier("SectionHeader") as? NBPSectionHeaderCell)!
//        cell.title?.text = "Posted On \(date)/05/2016"
//        
//        return cell
//        
//    }
    
//    func tableView(tableView: UITableView,
//                   heightForHeaderInSection section: Int) -> CGFloat {
//        return 33.0
//    }
//    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
