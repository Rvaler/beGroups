//
//  SearchInstitutionsTableViewCell.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/17/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class SearchInstitutionsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelInstitutionName: UILabel!
    @IBOutlet weak var labelInstitutionPrivacy: UILabel!
    @IBOutlet weak var imageInstitutionLogo: UIImageView!
    @IBOutlet weak var imageCellLocker: UIImageView!
    @IBOutlet weak var imageHexagonNoFill: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
