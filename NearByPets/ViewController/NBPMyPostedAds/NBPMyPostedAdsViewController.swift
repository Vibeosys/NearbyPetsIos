//
//  NBPDashboardViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 03/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CoreLocation
import BTNavigationDropdownMenu
import FBAudienceNetwork

enum adsType {
    
    case MyFavorite, MyPosted, Category, None
}

class NBPMyPostedAdsViewController: NBPBaseViewController,CLLocationManagerDelegate, VSDropdownDelegate {
    
    let imageNames = ["BIRDS.jpg", "CATS.jpg", "DOGS.jpg" , "FOOD.jpg" , "CATS.jpg" ]
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    var pageNumber = 0
    var productDetail = NBPProductDetailInfo()
    
    var categories : [NBPCategoryInfo]?
    var dropDown = VSDropdown()
    var operationData = ""
    var categoryId = 0
    var navTitle = ""
    var distance : Float = 0.0
    var rowCount = 0
    var section = 0
    var searchActive : Bool = false
    var searchString = ""
    //    var filtered:[NBPProductDetail] = []
    var sortBy = sortType.DateDesc
    var showAdsBy = adsType.MyFavorite
    
    var products = [NBPProductDetail]()
    var dateSortedProducts = [NBPDateSortedProduct]()
    var canLoadMoreData = true
    
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var sortButton : UIButton?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.locationManagerinstanitate()
        
//        self.getProductListFor(0 ,searchString: "")
        dropDown.adoptParentTheme = true
        dropDown.shouldSortItems = false
        dropDown.delegate = self
        self.title = self.navTitle
        self.addPullToRefreshToWebView()
        
        let contents = ["Sort By", "Date Desc", "Date Asc", "Price Desc" , "Price Asc", "Distance Desc", "Distance Asc"]
        
        //        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: contents.first!, items: contents)
        //        self.navigationItem.titleView = menuView
        
        FBAdSettings.addTestDevices(["d5fd182f0cc2f3316d876db62ca786785706868e","193284bd98d9024316a8570fdacffd5a5a671363"])
        
        self.getProductListFor(0, searchString: self.searchString)
        
        //        [FBAdSettings addTestDevice:@"HASHED ID"];
        
        //        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
        //            print("Did select item at index: \(indexPath)")
        ////            self.selectedCellLabel.text = contents[indexPath]
        //        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isLocationUpdate = false
        
    }
    
    func addPullToRefreshToWebView(){
        //        var refreshController:UIRefreshControl = UIRefreshControl()
        //
        //        refreshController.bounds = CGRectMake(0, 50, refreshController.bounds.size.width, refreshController.bounds.size.height) // Change position of refresh view
        //        refreshController.addTarget(self, action: Selector("refreshWebView:"), forControlEvents: UIControlEvents.ValueChanged)
        //        refreshController.attributedTitle = NSAttributedString(string: "Pull down to refresh...")
        //        YourWebView.scrollView.addSubview(refreshController)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(NBPDashboardViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
        
    }
    
    func refresh(refresh:UIRefreshControl){
        
        self.getProductListFor(0, searchString: self.searchString)
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
        if (segue.identifier == "NBPMyPostedAddToProductDetailSegue") {
            
            if let viewController: NBPProductDetailViewController = segue.destinationViewController as? NBPProductDetailViewController {
                viewController.productDetail = self.productDetail
                viewController.distance = self.distance
            }
        }
            
        else if (segue.identifier == "NBPDashboardToCategoriesSegue") {
            
            if let viewController: NBPCategoriesViewController = segue.destinationViewController as? NBPCategoriesViewController {
                viewController.categories = self.categories
            }
        }
        
        
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        var sections = 0
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            sections = self.dateSortedProducts.count
            
        default:
            sections = 1
        }
        return sections
    }
    
    func rowsForSection(sectionIndex : Int) -> Int{
        
        var rowsForSection = 0
        var penddingRows = 0
        
        for var section = 0; section <= sectionIndex ; section += 1{
            let datePro = self.dateSortedProducts[section]
            
            let rows = datePro.products!.count
            let howmanyAdd = (rows + penddingRows) / NBPUserHelper.facebookAdAfterRow()
            rowsForSection =  rows + howmanyAdd
            
            penddingRows = (rows + penddingRows)  % NBPUserHelper.facebookAdAfterRow()
            
        }
        
        return rowsForSection
    }
    
    func rowsForOtherSort() -> Int {
        
        var rowCount = self.products.count
        
        let howmanyAdd = rowCount / NBPUserHelper.facebookAdAfterRow()
        
        rowCount = rowCount + howmanyAdd
        
        return rowCount
    }
    
    
    func canShowFacebookAd(indexPath : NSIndexPath) -> Bool{
        var canShowAd = false
        var rowsForSection = 0
        var penddingRows = 0
        
        for var section = 0; section < indexPath.section ; section += 1 {
            
            let datePro = self.dateSortedProducts[section]
            
            let rows = datePro.products!.count
            let howmanyAdd = (rows + penddingRows) / NBPUserHelper.facebookAdAfterRow()
            rowsForSection =  rows + howmanyAdd
            
            penddingRows = (rows + penddingRows) % NBPUserHelper.facebookAdAfterRow()
            
            //           penddingRows = penddingRows - howmanyAdd
        }
        
        let currentRow = indexPath.row + penddingRows + 1
        
        let AddCount = currentRow / (NBPUserHelper.facebookAdAfterRow() + 1)
        //        var reminder = currentRow % NBPUserHelper.facebookAdAfterRow()
        
        //        currentRow = currentRow - AddCount
        
        //            if currentRow > 5  {
        //
        //                      currentRow = ((indexPath.row + penddingRows - (AddCount - 1)) % NBPUserHelper.facebookAdAfterRow())
        //
        //                if currentRow == 0    {
        //                    canShowAd = true
        //                }
        //
        //            }
        //        if
        
        //        var previousAdIndex = (currentRow - (AddCount - 1)) - 6
        
        //        if AddCount > 0{
        //            if (currentRow + AddCount)  % (NBPUserHelper.facebookAdAfterRow() + 1) == 0 && currentRow != 0  {
        //                canShowAd = true
        //            }
        //        }else{
        
        if currentRow  % (NBPUserHelper.facebookAdAfterRow() + 1) == 0 && currentRow != 0 {
            canShowAd = true
        }
        
        //        }
        
        
        
        //            penddingRows = rows % NBPUserHelper.facebookAdAfterRow()
        
        print(canShowAd)
        return canShowAd
    }
    
    func sortedProductIndex(indexPath : NSIndexPath) -> Int{
        
        var index = 0
        var rowsForSection = 0
        var penddingRows = 0
        
        for var section = 0; section < indexPath.section ; section += 1 {
            
            let datePro = self.dateSortedProducts[section]
            
            let rows = datePro.products!.count
            let howmanyAdd = (rows + penddingRows) / NBPUserHelper.facebookAdAfterRow()
            rowsForSection =  rows + howmanyAdd
            penddingRows = (rows + penddingRows) % NBPUserHelper.facebookAdAfterRow()
        }
        
        let currentRow = indexPath.row + penddingRows
        
        index = indexPath.row - (currentRow / NBPUserHelper.facebookAdAfterRow())
        
        //        if currentRow % NBPUserHelper.facebookAdAfterRow() == 0 && currentRow != 0 {
        //            index = 1
        //        }
        print(" New index " + String(index))
        return index
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 0
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            
            rowCount = self.rowsForSection(section)
            
        default:
            rowCount = self.rowsForOtherSort()
        }
        
        
        return rowCount
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : NBPProductInfoCell = tableView.dequeueReusableCellWithIdentifier("NBPProductInfoCell", forIndexPath: indexPath) as! NBPProductInfoCell
        
        if section != indexPath.section{
            self.rowCount = 0
            self.section = indexPath.section
        }
        
        if self.isLastRow(indexPath) {
            
            
        }
        
        
        print(indexPath)
        print(rowCount)
        
        var productDetail =  NBPProductDetail()
        
        self.canShowFacebookAd(indexPath)
        
        switch  sortBy {
        case .DateDesc, .DateAsc:
            if self.canShowFacebookAd(indexPath) == true{
                return self.showFacebookAd(indexPath)
            }
            
        default:
            if  (indexPath.row % NBPUserHelper.facebookAdAfterRow()) == 0 && indexPath.row != 0  {
                return self.showFacebookAd(indexPath)
            }
        }
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            let datePro = self.dateSortedProducts[indexPath.section]
            if datePro.products!.count > rowCount {
                
                rowCount = indexPath.row - indexPath.row / NBPUserHelper.facebookAdAfterRow()
                
                let index = self.sortedProductIndex(indexPath)
                productDetail = datePro.products![index]
                cell.dateLabel?.text = ""
            }
            
        default:
            rowCount = indexPath.row - indexPath.row / NBPUserHelper.facebookAdAfterRow()
            productDetail = self.products[rowCount]
            
            cell.dateLabel?.text = productDetail.postedDate?.stringFromDate()
        }
        
        
        
        self.sortedProductIndex(indexPath)
        cell.title?.text = productDetail.name
        cell.price?.text = "€ " + String(productDetail.price)
        cell.distance?.text = String(format: "%.01f", productDetail.distance) + " km away from you"  //"The velocity is \(productDetail.distance.string(1))"
        cell.productDescription?.text = String(productDetail.productDesc)
        
        
        switch showAdsBy {
        case .MyFavorite:
            cell.favButton?.selected = true
            break
        default:
            cell.favButton?.selected = false
            
        }
        
        cell.icon!.image = UIImage(named:"default_pet_image.jpg")
        cell.icon!.imageFromUrl(productDetail.image)
        print(productDetail.image)
        
        
        
        
        return cell
    }
    
    func showFacebookAd ( indexPath : NSIndexPath) -> NBPFacebookAdCell {
        
        let cell : NBPFacebookAdCell =  self.tableView!.dequeueReusableCellWithIdentifier("FacebookAd", forIndexPath: indexPath) as! NBPFacebookAdCell
        
        let adView: FBAdView = FBAdView(placementID:"1715459422041023_1722420858011546", adSize:kFBAdSizeHeight50Banner, rootViewController:self);
        
        adView.loadAd();
        cell.addSubview(adView);
        return cell
    }
    
    
    
    
    func isLastRow( indexPath : NSIndexPath) -> Bool{
        
        var currentRowCount = 0
        
        var totlaRows = 0
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            
            for var section = 0; section < indexPath.section ; section += 1 {
                let datePro = self.dateSortedProducts[section]
                var rows = datePro.products!.count
                let howmanyAdd = rows / NBPUserHelper.facebookAdAfterRow()
                rows =  rows + howmanyAdd
                currentRowCount = currentRowCount + rows
            }
            
            currentRowCount = currentRowCount + indexPath.row + 1
            
            
            
            for var section = 0; section < self.dateSortedProducts.count ; section += 1 {
                
                let datePro = self.dateSortedProducts[section]
                var rows = datePro.products!.count
                let howmanyAdd = rows / NBPUserHelper.facebookAdAfterRow()
                rows =  rows + howmanyAdd
                totlaRows = totlaRows + rows
            }
            
            print("currentRowCount" + String(currentRowCount))
            print("totlaRows" + String(totlaRows))
            
            
            
            if currentRowCount == totlaRows{
                
                if canLoadMoreData == true{
                    self.getProductListFor(self.pageNumber + 1 , searchString: searchString)
                }
                self.canLoadMoreData = false
                
            }
            
            
            break
        default:
            
            currentRowCount = indexPath.row + 1
            
            let datePro = self.products
            let rows = datePro.count
            let howmanyAdd = datePro.count / NBPUserHelper.facebookAdAfterRow()
            totlaRows =  rows + howmanyAdd
            
            print("currentRowCount" + String(currentRowCount))
            print("totlaRows" + String(totlaRows))
            
            
            if currentRowCount == totlaRows{
                
                if canLoadMoreData == true{
                    self.getProductListFor(self.pageNumber + 1 ,searchString: "" )
                }
                self.canLoadMoreData = false
                
                
            }
            break
            
        }
        
        
        
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.init(rgb: 0x03a021)
        }
        
        
    }
    
    
    
    func tableView(tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        
        let cell : NBPSectionHeaderCell =  (tableView.dequeueReusableCellWithIdentifier("SectionHeader") as? NBPSectionHeaderCell)!
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            let datePro = self.dateSortedProducts[section]
            cell.title?.text = "Posted On \(datePro.dateString)"
            
            
        default:
            cell.title?.text = ""
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        
        var headerheight = 0.0
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            
            headerheight = 33.0
        default:
            headerheight = 0.0
            
        }
        
        return CGFloat(headerheight)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        if (indexPath.row %  NBPUserHelper.facebookAdAfterRow()) == 0  && indexPath.row != 0{
            
        }else {
            self.getProductDetailsFor(indexPath)
            
        }
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK:
    // MARK: - UISearchBar delegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        self.searchString = searchBar.text!
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchString = searchBar.text!
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.getProductListFor(0, searchString: searchString )

    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.searchString = searchBar.text!
        self.getProductListFor(0, searchString: searchString )
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    // MARK: - locationManager delegate
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let coord = location.coordinate
        
        print(coord.latitude)
        print(coord.longitude)
//        if   isLocationUpdate == false{
//            
//            getProductListFor(0, searchString: self.searchString)
//            isLocationUpdate = true
//        }
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }
    
    // MARK: - Drop Down Delegate
    
    
    @IBAction func openDropDown(sender : UIButton)
    {
        
        self
        let contents = ["Sort By", "Date Desc", "Date Asc", "Price Desc" , "Price Asc", "Distance Desc", "Distance Asc"]
        
        
        //        dropDown.drodownAnimation = rand() % 2
        
        dropDown.allowMultipleSelection = false
        dropDown.setupDropdownForView(sender)
        dropDown.separatorColor = sender.titleLabel?.textColor
        dropDown.backgroundColor = UIColor.whiteColor()
        dropDown.reloadDropdownWithContents(contents, andSelectedItems: [sender.titleForState(.Normal)!])
    }
    
    
    
    func dropdown(dropDown: VSDropdown!, didChangeSelectionForValue str: String!, atIndex index: UInt, selected: Bool) {
        print(str)
        
        switch index {
        case 0,1:
            sortBy = .DateDesc
        case 2:
            sortBy = .DateAsc
        case 3:
            sortBy = .PriceDesc
        case 4:
            sortBy = .PriceAsc
        case 5:
            sortBy = .DistanceDesc
        case 6:
            sortBy = .DistanceAsc
            
        default:
            break
        }
        
        self.getProductListFor(0,searchString: searchString)
        self.sortButton?.setTitle(str, forState: .Normal)
        
        
    }
    
//    
//    @IBAction func categoryButtonClicked(sender : UIBarButtonItem)
//    {
//        
//        let registrationPara = NBPRequestHelper.createRequest(nil ,serviceName : "CategoryList")
//        print (registrationPara)
//        
//        NBPWebServices.getCategoryList(self, parameters: registrationPara) { (response) in
//            self.categories = response as? [NBPCategoryInfo]
//            
//            self.performSegueWithIdentifier( "NBPDashboardToCategoriesSegue", sender: self)
//            
//        }
//        
//        
//    }
    
    @IBAction func addToFavorite(sender : UIButton){
        

        let origin = sender.frame.origin;
        let point = sender.superview?.convertPoint(origin, toView: self.tableView)
        
        let indexPath = self.tableView?.indexPathForRowAtPoint(point!)
        
        print("indexPath:: \(indexPath)")
        
        
        switch showAdsBy {
        case .MyFavorite:
            sender.selected = false
            self.removeFromFavoriteAtIndex(indexPath!)
            
            break
        default:
            sender.selected = true
            self.addMyFavoriteAtIndex(indexPath!)
            
        }
        

        
    }
    
    
    func addMyFavoriteAtIndex(indexPath : NSIndexPath){
        
        var productDet =  NBPProductDetail()
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            let datePro = self.dateSortedProducts[indexPath.section]
            productDet = datePro.products![indexPath.row]
            
        default:
            productDet = self.products[indexPath.row]
        }
        
        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = productDet.adid
        favModel.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        //        favModel.useri = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "SaveAnAd")
        
        print (registrationPara)
        
        NBPWebServices.addToFavorite(self, parameters: registrationPara, completion: { (response) in
            print(response)
            
        })
        
    }
    
    func removeFromFavoriteAtIndex(indexPath : NSIndexPath){

        var productDet =  NBPProductDetail()
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            let datePro = self.dateSortedProducts[indexPath.section]
            productDet = datePro.products![indexPath.row]
            
        default:
            productDet = self.products[indexPath.row]
        }
        
        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = productDet.adid
        favModel.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "RemoveSavedAd")
        print (registrationPara)
        
        NBPWebServices.addToFavorite(self, parameters: registrationPara, completion: { (response) in
            print(response)
            self.getProductListFor(0, searchString: self.searchString)
            
        })
        
    }
    


    // MARK: - Service call for Product List
    
    
    func getProductDetailsFor(indexPath : NSIndexPath) {
        
        
        var productInfo =  NBPProductDetail()
        let datePro = self.dateSortedProducts[indexPath.section]
        
        switch sortBy {
        case .DateDesc, .DateAsc:
            
            let index = self.sortedProductIndex(indexPath)
            productInfo = datePro.products![index]
            
            
        default:
            productInfo = self.products[indexPath.row]
        }
        
        
        
        
        
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
                        self.performSegueWithIdentifier("NBPMyPostedAddToProductDetailSegue", sender: self)
                        
                    }else{
                        self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }

    
    func getProductListFor(pageNo : Int , searchString : String) {
        
        
        var sortChoice = "DESC"
        
        switch sortBy {
        case .DateAsc , .PriceAsc, .DistanceAsc:
            sortChoice = "ASC"
        default:
            sortChoice = "DESC"
        }
        
        
        var sortOption = "0"
        
        switch sortBy {
        case .DateAsc , .DateDesc :
            sortOption = "0"
        case .PriceAsc , .PriceDesc :
            sortOption = "2"
        case .DistanceDesc , .DistanceAsc :
            sortOption = "1"
            
        default:
            sortOption = "0"
        }
        
        self.pageNumber = pageNo
        
        let model = NBPLocationInfo()
        model.latitude = String(locationManager.location!.coordinate.latitude)
        model.longitude = String(locationManager.location!.coordinate.longitude)
        model.userid = NBPUserHelper.sharedInstance.userInfo()!.userid
        model.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        model.pageNumber = self.pageNumber + 1
        model.sortChoice = sortChoice
        model.sortOption = sortOption
        model.search = searchString
        model.categoryId = String(self.categoryId)
        
        let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : self.operationData)
        print (registrationPara)
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                self.refreshControl.endRefreshing()
                debugPrint(response)
                if pageNo == 0 {
                    self.dateSortedProducts.removeAll()
                    self.products.removeAll()
                }
                
                let mapper = Mapper<NBPProductModel>()
                let mappedObject = mapper.map(response.result.value)
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        
//                        self.sortProducts((mappedObject?.dataObject)!)
                        let pro = mappedObject!.dataObject
                        
                        for produ in pro! {
                            self.products.append(produ)
                        }
                        
                        self.sortProducts(self.products)
                        
                        self.rowCount = 0
                        self.section = 0
                        
                        
                        self.tableView?.reloadData()
                        
                        self.canLoadMoreData = true
                        
                    }else{
                        self.canLoadMoreData = false
                        if self.pageNumber == 0{
                            self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        }
                        
                    }
                }else{
                    self.canLoadMoreData = false
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
                print(mappedObject);
        }
    }
    
    
    
    func sortProducts(products : [NBPProductDetail]){
        
        self.dateSortedProducts.removeAll()
        
        var dates = [NSDate]()
        
        for product in products {
            product.postedDateString = NSDate.getDateString(product.postedDate!)
            dates.append(product.postedDate!)
        }
        
        var  uniqDates = dates.unique
        
        switch sortBy {
        case .DateDesc:
            uniqDates = uniqDates.sort { $0.0 .compare($0.1) == NSComparisonResult.OrderedDescending }
        default:
            uniqDates = uniqDates.sort { $0.0 .compare($0.1) == NSComparisonResult.OrderedAscending }
            
        }
        print(uniqDates)
        
        for date in uniqDates {
            let datePro = NBPDateSortedProduct()
            datePro.products = products.filter() { $0.postedDate! == date }
            datePro.date = date
            datePro.dateString = NSDate.getDateString(date)
            self.dateSortedProducts.append(datePro)
        }
        
        
        print(uniqDates)
        //        if sortBy = .Date{
        //
        //
        //        }
        
        
    }
    

}

/*

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





class NBPMyPostedAdsViewController: NBPBaseViewController,CLLocationManagerDelegate, VSDropdownDelegate {
    
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    var pageNumber = 0
    var productDetail = NBPProductDetailInfo()
    var products : Array <NBPProductDetail>?
    var distance : Float = 0.0
    
    @IBOutlet weak var tableView : UITableView?
      @IBOutlet weak var firstImageHeight: NSLayoutConstraint!
      @IBOutlet weak var secondImageHeight: NSLayoutConstraint!
      @IBOutlet weak var thirdImageHeight: NSLayoutConstraint!
    
    
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
        if (segue.identifier == "NBPMyPostedAddToProductDetailSegue") {
            
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
        cell.price?.text = "€ " +  String(productDetail.price)
        cell.distance?.text = String(format: "%.01f", productDetail.distance) + "kilometers away from you"  //"The velocity is \(productDetail.distance.string(1))"
        cell.productDescription?.text = String(productDetail.productDesc)
        
        cell.icon!.imageFromUrl(productDetail.image)
        print(productDetail.image)
        

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
        
    }
    
    // MARK:
    
    @IBAction func addToFavorite(sender : UIButton){
        
        let origin = sender.frame.origin;
        let point = sender.superview?.convertPoint(origin, toView: self.tableView)
        
        let indexPath = self.tableView?.indexPathForRowAtPoint(point!)
        
        print("indexPath:: \(indexPath)")
        
        sender.selected = true
        let productDet =  self.products![indexPath!.row]

        
        let favModel = NBPAddToFavoriteModel()
        favModel.adId = productDet.adid
        favModel.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(favModel ,serviceName : "SaveAnAd")
        print (registrationPara)
        
        NBPWebServices.addToFavorite(self, parameters: registrationPara, completion: { (response) in
            print(response)
            
        })
        
    }

    
    // MARK: - UISearchBar delegate
    
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
        
        
        //        let model = NBPLocationInfo()
        //        model.latitude = String(locationManager.location?.coordinate.latitude)
        //        model.longitude = String(locationManager.location?.coordinate.longitude)
        //        model.pageNumber = self.pageNumber + 1
        
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
                        self.performSegueWithIdentifier("NBPMyPostedAddToProductDetailSegue", sender: self)
                        
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
        //        model.latitude = String(locationManager.location?.coordinate.latitude)
        //        model.longitude = String(locationManager.location?.coordinate.longitude)
        //        model.pageNumber = self.pageNumber + 1
        
        model.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(model ,serviceName : "GetSavedAdIos")
        print (registrationPara)
        
        NBPWebServices.getSavedAds(self, parameters: registrationPara, completion: { (response) in
            
            if pageNo == 0{
                self.products?.removeAll()
            }
            print(response)
            self.products? = (response as? Array<NBPProductDetail>)!
            
            //            self.products?.append(self.products)
            
            
        })
        
        
        
    }
    
}
*/
