//
//  ProjectTableViewCell.swift
//  MobilePatch
//
//  Created by Alex Rodriguez on 8/30/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var overdueLabel: UILabel!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
