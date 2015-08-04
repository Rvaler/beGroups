//
//  BGRGroupListTableViewCell.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/24/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class BGRGroupListTableViewCell: UITableViewCell {

    @IBOutlet var groupNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
