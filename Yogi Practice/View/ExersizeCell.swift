//
//  ExersizeCell.swift
//  Yogi Practice
//
//  Created by margot on 2018-02-05.
//  Copyright © 2018 foxberryfields. All rights reserved.
//

import UIKit

class ExersizeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptiveImageView: UIImageView!
    
    @IBOutlet weak var infoBtnLb: UIButton!
    
    
    @IBAction func infoBtn(_ sender: Any) {
        if descriptionTextView.isHidden == false {
            descriptionTextView.isHidden = true
            descriptiveImageView.isHidden = false
        }
        else {
            descriptionTextView.isHidden = false
            descriptiveImageView.isHidden = true
        }
    }
    
    @IBAction func notificationBell(_ sender: Any) {
        
    }
    
//    func testlabel(newText: String){
//
//        titleLabel.text = newText;
//    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // Customize imageView like you need
//        self.imageView?.frame = CGRect(x: 30, y: 40, width: self.frame.width-80, height: self.frame.height-80)
//
//
//        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//        // Costomize other elements
//        //self.textLabel?.frame = CGRectMake(60, 0, self.frame.width - 45, 20)
//        //self.detailTextLabel?.frame = CGRectMake(60, 20, self.frame.width - 45, 15)
//    }

}
