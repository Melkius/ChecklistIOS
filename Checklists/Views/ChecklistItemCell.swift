//
//  ChecklistItemCell.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 21/02/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class ChecklistItemCell: UITableViewCell {

    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var checkmarkCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
