//
//  InstitutionHeaderTableViewCell.swift
//  BeGroups
//
//  Created by Rafael Valer on 7/14/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class InstitutionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewInstitutionHeader: UIImageView!
    @IBOutlet weak var labelInstitutionName: UILabel!
    @IBOutlet weak var labelInstitutionPrivacy: UILabel!
    @IBOutlet weak var viewHeaderSeparator: UIView!
    
    @IBOutlet weak var buttonJoined: UIButton!
    @IBOutlet weak var buttonCreateActivity: UIButton!
    @IBOutlet weak var buttonMembers: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
