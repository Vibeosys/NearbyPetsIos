//
//  NBPProductInfoCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 04/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPProductInfoCell: UITableViewCell {

    @IBOutlet var title : UILabel?
    @IBOutlet var distance : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var price : UILabel?
    @IBOutlet var productDescription : UILabel?
    @IBOutlet var icon : UIImageView?
    @IBOutlet var favButton : UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
