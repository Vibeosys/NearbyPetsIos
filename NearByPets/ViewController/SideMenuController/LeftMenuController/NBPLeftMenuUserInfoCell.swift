//
//  NBPLeftMenuUserInfoCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 20/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPLeftMenuUserInfoCell: UITableViewCell {

    @IBOutlet var userName : UILabel?
    @IBOutlet var emailId : UILabel?
    @IBOutlet var icon : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
