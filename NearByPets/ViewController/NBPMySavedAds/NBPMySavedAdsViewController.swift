//
//  NBPMySavedAdsViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CoreLocation
import BTNavigationDropdownMenu



class NBPMySavedAdsViewController: NBPBaseViewController,CLLocationManagerDelegate, VSDropdownDelegate {
    
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    var pageNumber = 0
    var productDetail = NBPProductDetailInfo()
    var products : Array <NBPProductDetail>?
    var distance : Float = 0.0
    
    @IBOutlet weak var tableView : UITableView?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.locationManagerinstanitate()
//        self.getProductListFor(0)
//        dropDown.adoptParentTheme = true
//        dropDown.shouldSortItems = false
//        dropDown.delegate = self
        self.addPullToRefreshToWebView()
        
//        let contents = ["Sort By", "Date Desc", "Date Asc", "Price Desc" , "Price Asc", "Distance Desc", "Distance Asc"]
//        
//        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: contents.first!, items: contents)
//        self.navigationItem.titleView = menuView
//        
//        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
//            print("Did select item at index: \(indexPath)")
//            //            self.selectedCellLabel.text = contents[indexPath]
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isLocationUpdate = false
        
    }
    
    func addPullToRefreshToWebView(){

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(NBPDashboardViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
        
    }
    
    func refresh(refresh:UIRefreshControl){
        
        self.getFavoriteProductListFor(0)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // MARK: - Navigation
        if (segue.identifier == "NBPAddToFavoritToProductDetailSegue") {
            
            if let viewController: NBPProductDetailViewController = segue.destinationViewController as? NBPProductDetailViewController {
                viewController.productDetail = self.productDetail
                viewController.distance = self.distance
            }
        }

        
        
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        let sections = 1

        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 0
        rowCount = (self.products?.count)!

        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : NBPProductInfoCell = tableView.dequeueReusableCellWithIdentifier("NBPProductInfoCell", forIndexPath: indexPath) as! NBPProductInfoCell
        
        let productDetail =  self.products![indexPath.row]
        cell.title?.text = productDetail.name
        cell.price?.text = "€ " + String(productDetail.price)
        cell.distance?.text = String(format: "%.01f", productDetail.distance) + " km away from you"  //"The velocity is \(productDetail.distance.string(1))"
        print(productDetail.productDesc)
        cell.productDescription?.text = String(productDetail.productDesc)
        cell.icon!.image = UIImage(named:"default_pet_image.jpg")
        cell.icon!.imageFromUrl(productDetail.image)
        print(productDetail.image)
        
//        if  indexPath.row == 4 {
//            cell.favButton?.selected = true
//        }else{
//            cell.favButton?.selected = false
//        }
        //
        //        if  indexPath.row == 4 {
        //            return tableView.dequeueReusableCellWithIdentifier("FacebookAd", forIndexPath: indexPath) as! NBPFacebookAdCell
        //
        //        }
        //
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.textLabel?.textColor = UIColor.init(rgb: 0x03a021)
//        }
//        
//        
//    }
//
//    func tableView(tableView: UITableView,
//                   viewForHeaderInSection section: Int) -> UIView?
//    {
//        // This is where you would change section header content
//        
//        let cell : NBPSectionHeaderCell =  (tableView.dequeueReusableCellWithIdentifier("SectionHeader") as? NBPSectionHeaderCell)!
//        
//        switch sortBy {
//        case .Date:
//            let datePro = self.dateSortedProducts[section]
//            cell.title?.text = "Posted On \(datePro.dateString)"
//            
//            
//        default:
//            cell.title?.text = ""
//            
//        }
//        
//        return cell
//        
//    }
    
    func tableView(tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        self.getProductDetailsFor(indexPath.row)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // MARK:
    // MARK: - UISearchBar delegate
    
    
    
    @IBAction func removeFromFavorite(sender : UIButton){
        
        let origin = sender.frame.origin;
        let point = sender.superview?.convertPoint(origin, toView: self.tableView)
        
        let indexPath = self.tableView?.indexPathForRowAtPoint(point!)
        
        print("indexPath:: \(indexPath)")
        
        sender.selected = true
        let productDet =  self.products![indexPath!.row]
        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = productDet.adid
        favModel.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "RemoveSavedAd")
        print (registrationPara)
        
        NBPWebServices.addToFavorite(self, parameters: registrationPara, completion: { (response) in
            print(response)
            self.getFavoriteProductListFor(0)
            
        })
        
    }
    

//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchActive = true;
//    }
//    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.tableView!.reloadData()
    }
    
    // MARK: - locationManager delegate
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let coord = location.coordinate
        
        print(coord.latitude)
        print(coord.longitude)
        if   isLocationUpdate == false{
            
            //            self.getProductList()
            isLocationUpdate = true
            
            
        }
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    

    // MARK: - Service call for Product List
    
    
    func getProductDetailsFor(indexRow : Int) {

        let productInfo = self.products![indexRow]
        let model = NBPRequestProductModel()
        model.adId = productInfo.adid
        self.distance = productInfo.distance
        
        let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "ProductDescriptionIos")
        
        print (registrationPara)
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                
                let mapper = Mapper<NBPProductDetailModel>()
                let mappedObject = mapper.map(response.result.value)
                
                self.productDetail = (mappedObject?.dataObject)!
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        self.navigationItem.backBarButtonItem?.title = " "
                        self.performSegueWithIdentifier("NBPAddToFavoritToProductDetailSegue", sender: self)
                        
                    }else{
                        self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }
    

    
    func getFavoriteProductListFor(pageNo : Int) {
        
        let model = NBPLocationInfo()
        model.latitude = String(locationManager.location!.coordinate.latitude)
        model.longitude = String(locationManager.location!.coordinate.longitude)
        model.pageNumber = self.pageNumber + 1
        
        model.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "GetSavedAdIos")
        print (registrationPara)
        
        NBPWebServices.getSavedAds(self, parameters: registrationPara, completion: { (response) in
            
            if pageNo == 0{
                self.products?.removeAll()
            }
            print(response)
            self.products? = (response as? Array<NBPProductDetail>)!
            
            self.tableView?.reloadData()
//            self.products?.append(self.products)
            
            
        })
        
        
        
    }
    
}
