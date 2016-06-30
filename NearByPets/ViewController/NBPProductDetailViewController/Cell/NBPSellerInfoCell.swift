//
//  NBPSellerInfoCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 18/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPSellerInfoCell: UITableViewCell {

    @IBOutlet var name : UILabel?
    @IBOutlet var email : UITextView?
    @IBOutlet var phone : UITextView?
    @IBOutlet var aaddressText : UILabel?
    @IBOutlet var addressDetail : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
