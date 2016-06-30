//
//  NBPCategoriesCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 08/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPCategoriesCell: UITableViewCell {

    @IBOutlet var categoryName : UILabel?
    @IBOutlet var numberOfProducts : UILabel?
    @IBOutlet var categoryImage : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
