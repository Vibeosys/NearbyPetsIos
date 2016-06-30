//
//  NBPTitleDescriptionCell.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 18/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPTitleDescriptionCell: UITableViewCell {

    
    @IBOutlet weak var  categoriesTextField : UITextField?
    @IBOutlet weak var  titleTextField : UITextField?
    @IBOutlet weak var  descritionTextView : NBPTextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
