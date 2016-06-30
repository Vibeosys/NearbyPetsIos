//
//  NBPAdDetailCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 18/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPAdDetailCell: UITableViewCell {

    @IBOutlet var addedDate : UILabel?
    @IBOutlet var views : UILabel?
    @IBOutlet var distance : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
