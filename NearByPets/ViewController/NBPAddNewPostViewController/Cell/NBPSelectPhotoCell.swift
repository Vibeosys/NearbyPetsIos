//
//  NBPSelectPhotoCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 18/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPSelectPhotoCell: UITableViewCell {

    
    @IBOutlet weak var firstImageView : UIButton?
    @IBOutlet weak var secondImageView : UIButton?
    @IBOutlet weak var ThirdImageView : UIButton?
    
    @IBOutlet weak var firstImageHeight: NSLayoutConstraint!
    @IBOutlet weak var secondImageHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var firstImageRemove : UIButton?
    @IBOutlet weak var secondImageRemove : UIButton?
    @IBOutlet weak var thirdImageRemove : UIButton?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
