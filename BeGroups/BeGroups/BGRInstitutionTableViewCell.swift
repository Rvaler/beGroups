//
//  BGRInstitutionTableViewCell.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/23/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class BGRInstitutionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCheckActivity: UIImageView!
    @IBOutlet weak var labelActivityName: UILabel!
    @IBOutlet weak var labelActivityDeliveryDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
