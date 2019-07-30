//
//  SectionHeaderView.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 19/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewCell {

    @IBOutlet weak var dayLabelView: UIView!{
        didSet{
            dayLabelView.layer.cornerRadius = 20
            dayLabelView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var dayLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
