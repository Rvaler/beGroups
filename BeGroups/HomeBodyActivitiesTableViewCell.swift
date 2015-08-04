//
//  HomeBodyActivitiesTableViewCell.swift
//  BeGroups
//
//  Created by Rafael Valer on 7/7/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class HomeBodyActivitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var labelActivityName: UILabel!
    @IBOutlet weak var labelInstitutionName: UILabel!
    @IBOutlet weak var labelActivityDate: UILabel!
    @IBOutlet weak var imageCheckActivity: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
