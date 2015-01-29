//
//  LoginCellTableViewCell.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-28.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import UIKit

class LoginCellTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var separatorLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        input.layer.borderColor = UIColor.whiteColor().CGColor
        input.textColor = UIColor.redColor()
        input.layer.borderWidth = 0
        input.backgroundColor = UIColor.clearColor()
        var fontSize:CGFloat = 34
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            fontSize += 20
        }
        if UIScreen.mainScreen().bounds.height < 568{
            fontSize -= 5
        }
        input.font = UIFont(name: "Avenir Next Condensed", size: fontSize)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
