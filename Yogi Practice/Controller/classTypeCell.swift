//
//  classTypeCell.swift
//  Yogi Practice
//
//  Created by margot on 2017-11-26.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit

class classTypeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var classes = ["Standard Class", "Asana Class", "Pranayama Class"];
    
    @IBOutlet weak var classTypeLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
