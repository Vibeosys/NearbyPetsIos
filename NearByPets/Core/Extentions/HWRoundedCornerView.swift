//
//  HWRoundedCornerView.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 18/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

@IBDesignable class HWRoundedCornerView: UIView {
    
    
    
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
        
        self.layer.cornerRadius = 2;
        
        
    }

    
}
