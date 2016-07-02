//
//  NBPAddNewPostViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import DownPicker
import Alamofire
import ObjectMapper
import CoreLocation
import DLRadioButton

enum selectedImageNumber {
    case First, Second, Third, None
}


class NBPAddNewPostViewController: NBPBaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UIPickerViewDelegate {


//    @property (strong, nonatomic) DownPicker *downPicker;

    var downPicker : DownPicker?
    var categoriesdownPicker : DownPicker?
    let locationManager = CLLocationManager()
    var isLocationUpdate = false
    let imagePicker = UIImagePickerController()
    var categories = [NBPCategoryInfo]()
    var types = [NBPAdPostTypesInfo]()
    
    var firstSelectedImage : UIImage?
    var secondSelectedtImage : UIImage?
    var thirdSelectedImage : UIImage?
    
    let adPostModel = NBPAdPostInfo()
    
    var address = ""
    var imageNumber = selectedImageNumber.None
    @IBOutlet weak var  firstImage : UIButton?
    @IBOutlet weak var  secondImage : UIButton?
    @IBOutlet weak var  thirdImage : UIButton?
    
    
 var  titleTextField : UITextField?
 var  descriptiontextField : NBPTextView?
    
    @IBOutlet weak var  tableView : UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        self.locationManagerinstanitate()
        self.getCategories()
        self.getTypes()
        

        
//        [self.yourDownPicker addTarget:self
//            action:@selector(dp_Selected:)
//        forControlEvents:UIControlEventValueChanged];
        
        
    }
    
    func dp_Selected(sender : AnyObject){
        
        self.adPostModel.selectedTypeIndex =  (self.downPicker?.selectedIndex)!
        
    }
//    
//    -(void)dp_Selected:()dp {
//    
//        NSString* selectedValue = [self.youtDownPicker text];
//    // do what you want
//    }
//    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isLocationUpdate = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UploadPhotoCell", forIndexPath: indexPath)
//        cell.title?.text = "Product Title \(indexPath.row+indexPath.section)"
        
        
        if  indexPath.row == 0 {
            let photoCell : NBPSelectPhotoCell =  tableView.dequeueReusableCellWithIdentifier("UploadPhotoCell", forIndexPath: indexPath) as! NBPSelectPhotoCell

            
            
            if self.firstSelectedImage != nil {

                photoCell.firstImageRemove?.hidden = false
                photoCell.firstImageRemove?.enabled = true
                photoCell.firstImageView?.setBackgroundImage(self.firstSelectedImage!, forState: .Normal)
            }else{
                photoCell.firstImageRemove?.hidden = true
                photoCell.firstImageRemove?.enabled = false
                
            }
            
            if self.secondSelectedtImage != nil {

                 photoCell.secondImageRemove?.hidden = false
                photoCell.secondImageRemove?.enabled = true
                photoCell.secondImageView?.setBackgroundImage(self.secondSelectedtImage!, forState: .Normal)
            }else{
                photoCell.secondImageRemove?.hidden = true
                photoCell.secondImageRemove?.enabled = false
            }
            
            if self.thirdSelectedImage != nil{

                photoCell.thirdImageRemove?.hidden = false
                photoCell.thirdImageRemove?.enabled = true
                photoCell.ThirdImageView?.setBackgroundImage(self.thirdSelectedImage!, forState: .Normal)
            }else{
                photoCell.thirdImageRemove?.hidden = true
                photoCell.thirdImageRemove?.enabled = false
            }

            
            
            if self.firstSelectedImage != nil  || self.secondSelectedtImage != nil || self.thirdSelectedImage != nil{
                
                photoCell.firstImageHeight.constant = 40.0
                photoCell.secondImageHeight.constant = 40.0
                photoCell.thirdImageHeight.constant = 40.0
                
            }else{
                
                photoCell.firstImageHeight.constant = 0.0
                photoCell.secondImageHeight.constant = 0.0
                photoCell.thirdImageHeight.constant = 0.0
            }
            
            return photoCell
            
        }else if indexPath.row == 1{
            
            let descriptionCell : NBPTitleDescriptionCell = tableView.dequeueReusableCellWithIdentifier("PostDescriptionCell", forIndexPath: indexPath) as! NBPTitleDescriptionCell
            
            self.titleTextField = descriptionCell.titleTextField
            self.descriptiontextField = descriptionCell.descritionTextView
        
            
            var categories = [String]()
            
            for category in self.categories {
                categories.append(category.categoryTitle)
            }
            
            self.categoriesdownPicker = DownPicker.init(textField:descriptionCell.categoriesTextField, withData: categories)
            self.categoriesdownPicker?.showArrowImage(true)
            self.categoriesdownPicker?.setPlaceholder("Choose Category")

            return descriptionCell
            
        }else if indexPath.row == 2{
            let addressCell : NBPAddressCell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! NBPAddressCell
            
            if addressCell.displayFullAddress?.selected == true{
                addressCell.addressTextView?.text = self.address
                self.adPostModel.isDisplayFullAddress = true
            }else{
                addressCell.addressTextView?.text = self.adPostModel.city
                self.adPostModel.isDisplayFullAddress = false
            }
            
            return addressCell
            
        }
        else if indexPath.row == 3{
            let priceCell : NBPAdPostPriceCell = tableView.dequeueReusableCellWithIdentifier("PriceCell", forIndexPath: indexPath) as! NBPAdPostPriceCell
            
            var types = [String]()
            
            for category in self.types {
                types.append(category.typeTitle)
            }
            
            
            priceCell.typeTextField?.text = "For Sale"
            self.downPicker = DownPicker.init(textField:priceCell.typeTextField, withData: types)
            self.downPicker?.showArrowImage(true)
            self.downPicker?.addTarget(self, action: #selector(NBPAddNewPostViewController.dp_Selected(_:)), forControlEvents:.ValueChanged)
            if types.count > 1{
                self.downPicker?.setValueAtIndex(self.adPostModel.selectedTypeIndex)
                
            }
            self.downPicker?.setPlaceholder("Choose Type")
            
            
            return priceCell
        }
        
        return cell
    }
    

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

// MARK: - IBActions
    
    @IBAction func displayFullAddressRadioButtonClicked(sender : DLRadioButton){
        self.tableView?.reloadData()
        
    }
    
    @IBAction func postMyAddButtonClicked(sender : UIButton){
        
        self.uploadAdPostData()
    }
    
    
    @IBAction func removeFirstImage(sender: AnyObject) {
        
        self.firstSelectedImage = nil
        self.tableView?.reloadData()
    }
    
    @IBAction func removeSecondImage(sender: AnyObject) {
        
         self.secondSelectedtImage = nil
        self.tableView?.reloadData()
    }
    @IBAction func removeThirdImage(sender: AnyObject) {
        
         self.thirdSelectedImage = nil
        self.tableView?.reloadData()
        
    }
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func showActionSheet(sender: UIButton) {
        // 1
        
        switch sender.tag {
        case 1:
            firstImage = sender
            self.imageNumber = .First
        case 2:
            secondImage = sender
            self.imageNumber = .Second
        case 3:
            thirdImage = sender
             self.imageNumber = .Third
        default:
            firstImage = sender
            self.imageNumber = .None
        }
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
            print("Camera")
            
        })
        let saveAction = UIAlertAction(title: "Choose Existing Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Photo Library")
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .SavedPhotosAlbum
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerView Delegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        
    }

    
//    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
//        
//        
//        print(row)
//    }
//    

    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        switch imageNumber {
        case .First:
            firstImage?.setBackgroundImage(newImage, forState: .Normal)
            firstSelectedImage = newImage
        case .Second:
            secondImage?.setBackgroundImage(newImage, forState: .Normal)
            secondSelectedtImage = newImage
        case .Third:
            thirdImage?.setBackgroundImage(newImage, forState: .Normal)
            thirdSelectedImage = newImage
        default:
            break
        }
        
        self.tableView?.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - locationManager delegate
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let coord = location.coordinate
        
        if   isLocationUpdate == false{
            
            //            self.getProductList()
            isLocationUpdate = true
            self.getAddressFromLocation(location)

            
        }
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
    }

    
    func getAddressFromLocation(location: CLLocation){
    
//    var longitude :CLLocationDegrees = -122.0312186
//    var latitude :CLLocationDegrees = 37.33233141
//    
//    var location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
    print(location)
    
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        print(location)
        
        if error != nil {
        print("Reverse geocoder failed with error" + error!.localizedDescription)
        return
        }
        
            if placemarks!.count > 0 {
            let pm = placemarks![0]
                let addressDetail = pm.addressDictionary!["FormattedAddressLines"] as! [String]
                
                let city = pm.subAdministrativeArea!
                
                 self.address = addressDetail.joinWithSeparator(", ")
                self.adPostModel.city = city
                print(self.address)
                self.tableView?.reloadData()
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Service call
    
    func getCategories() {

        let registrationPara = NBPRequestHelper.createRequest(nil, serviceName : "GetCategory")
        
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                
                let mapper = Mapper<NBPCategoryModel>()
                let mappedObject = mapper.map(response.result.value)
                self.categories =  (mappedObject?.dataObject)!
                self.tableView?.reloadData()
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        
                    }else{
                        self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
        }
    }
    
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        
        let compressImage = self.imageWithImage(image, scaledToSize: CGSizeMake(480.0, 320.0))
        
        let imageData = UIImageJPEGRepresentation(compressImage, 0.6)
        
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return base64String
        
    }
    
//    func convertImageToBase64(image: UIImage) -> String {
//        
//        let imageData = UIImagePNGRepresentation(image)
//        let base64String = NSData.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
//        
//        return base64String
//        
//    }
//    
    
    func getTypes() {

        
        let registrationPara = NBPRequestHelper.createRequest(nil, serviceName : "GetTypes")
        
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                
                let mapper = Mapper<NBPAdPostTypesModel>()
                let mappedObject = mapper.map(response.result.value)
                self.types =  (mappedObject?.dataObject)!
                self.adPostModel.typeId = 0
                
                self.tableView?.reloadData()
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        
                        
                    }else{
                        self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
        }
    }
    
    var Timestamp: NSTimeInterval {
        return NSDate().timeIntervalSince1970 * 1000
    }
    
    
    func uploadAdPostData() {
        
        
//        let descripCell : NBPTitleDescriptionCell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! NBPTitleDescriptionCell
        
        let priceCell : NBPAdPostPriceCell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! NBPAdPostPriceCell
        
        
        if self.titleTextField?.text == ""{
            
            self.showAlert("Info", message:"Please enter Title." )
            return
        }
        
        if self.categoriesdownPicker?.selectedIndex == nil{
            
            self.showAlert("Info", message:"Please choose Category." )
            return
        }
        
        if self.categoriesdownPicker?.selectedIndex == nil{
            
            self.showAlert("Info", message:"Please choose Category." )
            return
        }
        
        
        let fImage = NBPImageInfo()
        fImage.imageId = 1
        fImage.imageFileName = String(self.Timestamp) + "1"
        if firstSelectedImage != nil {
           
        fImage.imageData = self.convertImageToBase64(firstSelectedImage!)
            self.adPostModel.images.append(fImage)
            
        }
        
        let sImage = NBPImageInfo()
        sImage.imageId = 2
        sImage.imageFileName = String(self.Timestamp) + "2"
        if secondSelectedtImage != nil {
        sImage.imageData = self.convertImageToBase64(secondSelectedtImage!)
              self.adPostModel.images.append(sImage)
        }
        
        let tImage = NBPImageInfo()
        tImage.imageId = 3
        tImage.imageFileName = String(self.Timestamp) + "3"
        if thirdSelectedImage != nil{
        tImage.imageData = self.convertImageToBase64(thirdSelectedImage!)
            self.adPostModel.images.append(tImage)
        }
        
        //        let model = NBPAdPostInfo()
        
        let catIndex = (self.categoriesdownPicker?.selectedIndex)!
        let cate = self.categories[catIndex]
        
        self.adPostModel.categoryId = cate.categoryId
        
        let typeIndex = (self.downPicker?.selectedIndex)!
        
        let type = self.types[typeIndex]
        
        self.adPostModel.typeId = type.typeId
        let newString = (self.descriptiontextField?.text)!.stringByReplacingOccurrencesOfString(" ", withString:"", options: NSStringCompareOptions.LiteralSearch, range: nil)

        
        self.adPostModel.descriptionIos = newString
        self.adPostModel.title = (self.titleTextField?.text)!
        self.adPostModel.address = self.address
        if self.adPostModel.isDisplayFullAddress == true{
            self.adPostModel.displayAddress = self.address
            self.adPostModel.isAddress = 2
        }else{
            self.adPostModel.displayAddress = self.adPostModel.city
            self.adPostModel.isAddress = 1
        }
        
        self.adPostModel.latitude = String(locationManager.location!.coordinate.latitude)
        self.adPostModel.longitude = String(locationManager.location!.coordinate.longitude)
        self.adPostModel.price = (priceCell.priceTextField?.text)!
        self.adPostModel.userId = NBPUserHelper.sharedInstance.userInfo()!.userid
        
        let registrationPara = NBPRequestHelper.createRequest(self.adPostModel, serviceName : "PostAdIos")
        
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                
                let mapper = Mapper<NBPAdPostTypesModel>()
                let mappedObject = mapper.map(response.result.value)
//                self.types =  (mappedObject?.dataObject)!
                self.tableView?.reloadData()
                
                if response.result.error == nil {
                    if  mappedObject?.error?.errorCode == 0 {
                        self.navigationController?.popViewControllerAnimated(true)
                        UIApplication.sharedApplication().keyWindow?.rootViewController!.showAlert("Info", message:mappedObject?.error?.errorMsg )
                        
                        
                    }else{
                        self.showAlert("Error", message:mappedObject?.error?.errorMsg )
                        
                    }
                }else{
                    self.showAlert("Error", message: response.result.error?.localizedDescription)
                }
                
        }
    }


    
    func textView(textView: UITextView,
                    shouldChangeTextInRange range: NSRange,
                                            replacementText text: String) -> Bool
    {
        var shouldChangeChar = true

        if text == "\n"
        {
           shouldChangeChar = false
        }
        
        return shouldChangeChar
    }
    
    
    
}
