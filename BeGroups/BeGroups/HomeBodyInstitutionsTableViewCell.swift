//
//  HomeBodyInstitutionsTableViewCell.swift
//  BeGroups
//
//  Created by Rafael Valer on 7/7/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class HomeBodyInstitutionsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFirstLetterInstitution: UILabel!
    @IBOutlet weak var labelInstitutionName: UILabel!
    @IBOutlet weak var labelInstitutionPrivacy: UILabel!
    @IBOutlet weak var imageViewLocker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
