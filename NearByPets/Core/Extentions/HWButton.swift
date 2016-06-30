//
//  HWButton.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 09/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

@IBDesignable class NBPButton: UIButton {

    @IBInspectable var gredientTopColor: UIColor!
    @IBInspectable var gredientBottomColor: UIColor!
    @IBInspectable var borderColor: UIColor!

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
//        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:(self.frame.size.width/2),
//            bottom: 0, right: 0)
        super.drawRect(rect)
        self.addGradient(rect)

    }

    override func imageRectForContentRect(contentRect:CGRect) -> CGRect {
        var imageFrame = super.imageRectForContentRect(contentRect)
        imageFrame.origin.x = CGRectGetMaxX(self.frame) - 70
        return imageFrame
    }
    
    
//    required init?(coder aDecoder: (NSCoder!)) {
//        super.init(coder: aDecoder)
//        self.addGradient()
//    }

    func addGradient(rect: CGRect){
        
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.CGColor
        
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = rect.size
        gradient.colors = [gredientTopColor.CGColor,gredientBottomColor.CGColor] //Or any colors
        self.layer.insertSublayer(gradient, atIndex:0)
        self.layer.masksToBounds = true;
    }
    
}


@IBDesignable class NBPTextView: UITextView {
    
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
        
//        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.CGColor
        
        
    }
    
}


@IBDesignable class NBPTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
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
        
        //        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 2;
        self.layer.borderColor = borderColor.CGColor
        self.layer.cornerRadius = 2
        let placeholderAttrs = [ NSForegroundColorAttributeName : UIColor.whiteColor()]
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: placeholderAttrs)
        self.attributedPlaceholder = placeholder
        
    }
    
}





@IBDesignable class NBTLabel: UILabel {
    
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
        
        //        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.CGColor
        
        
    }
    
}


