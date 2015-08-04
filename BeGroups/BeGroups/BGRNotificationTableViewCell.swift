//
//  BGRNotificationTableViewCell.Swift
//  
//
//  Created by Anderson Rogério da Silva Gralha on 6/28/15.
//
//

import UIKit
import Parse

class BGRNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var BGRNotificationDescriptionLabel: UILabel!
    
    @IBOutlet weak var BGRConfirmNotificationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
