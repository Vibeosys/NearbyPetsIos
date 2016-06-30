//
//  NBPRegistartionViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 11/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftValidator

class NBPRegistartionViewController: NBPBaseViewController ,ValidationDelegate {

    @IBOutlet var emailIdTextfield : UITextField?
    @IBOutlet var passwordTextField : UITextField?
    @IBOutlet var firstNameTextField : UITextField?
    @IBOutlet var lastNameTextField : UITextField?
    @IBOutlet var phoneNumberTextField : UITextField?

    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Validation Rules are evaluated from left to right.
        //        validator.registerField(, rules: [RequiredRule(), FullNameRule()])
        
        // You can pass in error labels with your rules
        // You can pass in custom error messages to regex rules (such as ZipCodeRule and EmailRule)
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            
            
            }, error:{ (validationError) -> Void in
                print("error")
                self.showAlert("Error", message: validationError.errorMessage)
                //                validationError.errorLabel?.hidden = false
                //                validationError.errorLabel?.text = validationError.errorMessage
                //                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                //                validationError.textField.layer.borderWidth = 1.0
        })
        
        let errorLabel = UILabel()
        validator.registerField(emailIdTextfield!, errorLabel:errorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordTextField!, errorLabel: errorLabel, rules: [RequiredRule(), PasswordRule(message: "Password must be 8 characters with 1 upper case.")])
        validator.registerField(firstNameTextField!, errorLabel:errorLabel, rules: [RequiredRule()])
        validator.registerField(lastNameTextField!, errorLabel:errorLabel, rules: [RequiredRule()])
        validator.registerField(phoneNumberTextField!, errorLabel:errorLabel, rules: [RequiredRule()])
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonClicked(sender: UIButton) {
        
        validator.validate(self)
//        self.loadLoginView()
    }
    
    @IBAction func backButtonClicked(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    

    // MARK: - Swift Validation Delegate 
    
    func validationSuccessful() {
        
        print (validationSuccessful)
        let registrationPara = NBPRequestHelper.createRegistrationRequest(self.firstNameTextField!.text!, lastName: self.lastNameTextField!.text!, emailId:self.emailIdTextfield!.text!, password: self.passwordTextField!.text! , phoneNumber : self.phoneNumberTextField!.text!)
        
        print(registrationPara)
        
        Alamofire.request(.POST, BASE_URL, parameters:registrationPara, encoding: .JSON)
            .responseString { response in
                
                debugPrint(response)
                let mapper = Mapper<NBPRegistrationModel>()
                let mappedObject = mapper.map(response.result.value)
                
                if response.result.error == nil {
                    if  mappedObject?.error!.errorCode == 0 {
                        
                        let userInfo = mappedObject?.dataObject!
                        self.navigationController?.popViewControllerAnimated(true)
                        UIApplication.sharedApplication().keyWindow?.rootViewController!.showAlert("Info", message:mappedObject?.error?.errorMsg )
                        
                    }else{
                        self.showAlert("Error", message:mappedObject?.error!.errorMsg )
                        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
