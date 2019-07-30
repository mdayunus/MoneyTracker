//
//  TransactionCell.swift
//  MoneyTracker
//
//  Created by Mohammad Yunus on 01/07/19.
//  Copyright © 2019 simpleApp. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 10.1
            containerView.layer.shadowColor = UIColor.gray.cgColor
            containerView.layer.shadowOpacity = 0.6
            
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowRadius = 5.6
//            containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
            containerView.layer.shouldRasterize = true
            containerView.layer.rasterizationScale = UIScreen.main.scale
//            containerView.layer.masksToBounds = true
            
            
            
//            colorView.layer.shadowColor = UIColor.lightGray.cgColor
//            colorView.layer.shadowOpacity = 0.5
//            colorView.layer.shadowOffset = .zero
//            colorView.layer.shadowRadius = 6
//            colorView.layer.shouldRasterize = true
//            colorView.layer.rasterizationScale = UIScreen.main.scale
            
            
        }
    }
    
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
