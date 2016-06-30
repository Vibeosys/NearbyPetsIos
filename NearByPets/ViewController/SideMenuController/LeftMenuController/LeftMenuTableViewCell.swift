//
//  LeftMenuTableViewCell.swift
//  HealthWatch
//
//  Created by Suyog Kolhe on 16/03/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {

    @IBOutlet var title : UILabel?
    @IBOutlet var icon : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor(rgb: 0x0099d3)
        self.selectedBackgroundView = view
    }
}
