//
//  TransactionCell.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 01/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var memberName: UILabel!
    
    @IBOutlet weak var madeAt: UILabel!
    
    @IBOutlet weak var cocImageView: UIImageView!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
