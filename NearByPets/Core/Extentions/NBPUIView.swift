//
//  NBPUIView.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import Alamofire


@IBDesignable class NBPUIView: UIView {
    
    @IBInspectable var borderColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.addBorder(rect)
        
    }
    
    
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    func addBorder(rect: CGRect){
        
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = true;
    }

    
    
}



@IBDesignable class NBPRoundedImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.addBorder(rect)
        
    }
    
    
    //    required init?(coder aDecoder: (NSCoder!)) {
    //        super.init(coder: aDecoder)
    //        self.addGradient()
    //    }
    
    func addBorder(rect: CGRect){
        
        self.layer.borderColor = borderColor.CGColor
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = true;
    }
    
    
    
}



extension UIImageView {
    public func imageFromUrl(urlString: String) {
        
        Alamofire.request(.GET,urlString).response { (request, response, data, error) in
            self.image = UIImage(data: data!, scale:1)
        }
        
        
//        if let url = NSURL(string: urlString) {
//            let request = NSURLRequest(URL: url)
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
//                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//                if let imageData = data as NSData? {
//                    self.image = UIImage(data: imageData)
//                }
//            }
//        }
    }
}


