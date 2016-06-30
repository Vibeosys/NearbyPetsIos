//
//  NBPAddressCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 19/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import DLRadioButton

class NBPAddressCell: UITableViewCell {

    @IBOutlet weak var  addressTextView : UITextView?
    @IBOutlet weak var  displayFullAddress : DLRadioButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
