//
//  LoginCellTableViewCell.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-28.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import UIKit

class LoginCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var separatorLine: UIImageView!
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        input.textColor = UIColor.redColor()
        input.borderStyle = UITextBorderStyle.None
        input.backgroundColor = UIColor(red: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1)
        var fontSize:CGFloat = 34
        if Constants.is_ipad(){
            fontSize += 20
        }
        else{
            if Constants.is_iPhone4(){
                fontSize -= 5
            }
            else{
                inputBottomConstraint.constant += 15
            }
        }
        input.font = UIFont(name: "Avenir Next Condensed", size: fontSize)
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
