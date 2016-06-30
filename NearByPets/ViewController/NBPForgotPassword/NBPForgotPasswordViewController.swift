//
//  NBPForgotPasswordViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 12/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftValidator

class NBPForgotPasswordViewController: NBPBaseViewController ,ValidationDelegate{

        @IBOutlet var emailIdTextfield : UITextField?
    
        let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            
            }, error:{ (validationError) -> Void in
                self.showAlert("Error", message: validationError.errorMessage)
        })
        
        let errorLabel = UILabel()
        validator.registerField(emailIdTextfield!, errorLabel:errorLabel, rules: [RequiredRule(), EmailRule()])

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func resetPasswordButtonClicked (sender : UIButton){
        
        //        self.loadRootViewController()
        
        validator.validate(self)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func validationSuccessful() {
        
        print (validationSuccessful)
        
        let model = NBPForgotPasswordModel()
        model.email = self.emailIdTextfield!.text!
        
        let registrationPara = NBPRequestHelper.createForgotRequest(model)
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                
                let mapper = Mapper<NBPLoginModel>()
                let mappedObject = mapper.map(response.result.value)
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
                
                print(mappedObject);
        }
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        print("Validation FAILED!")
    }
    
    
}
