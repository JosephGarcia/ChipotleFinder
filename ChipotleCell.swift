//
//  ChipotleCellTableViewCell.swift
//  Chipotle Finder
//
//  Created by Joseph Garcia on 3/30/16.
//  Copyright © 2016 joebeard. All rights reserved.
//

import UIKit

class ChipotleCell: UITableViewCell {
    
    @IBOutlet weak var chipotleAddressText: UILabel!
    @IBOutlet weak var neighborhoodText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
