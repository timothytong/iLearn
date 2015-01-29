
//
//  LoginController.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-26.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var iLearnLabel: UILabel!
    @IBOutlet weak var loginTable: UITableView!
    @IBOutlet weak var iLearnTopConstraint: NSLayoutConstraint!
    var cellArray:Array<LoginCellTableViewCell>!
    let is_iPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? true : false
    let is_iPhone4 = UIScreen.mainScreen().bounds.height < 568 ? true : false
    override func viewDidLoad() {
        super.viewDidLoad()
        cellArray = Array<LoginCellTableViewCell>()
        loginTable.delegate = self
        loginTable.dataSource = self
        let loginCellNib = UINib(nibName: "LoginCell", bundle: nil)
        loginTable.registerNib(loginCellNib, forCellReuseIdentifier: "LoginCell")
        loginTable.reloadData()
        loginTable.scrollEnabled = false
        loginTable.separatorStyle = .None
        if is_iPad{
            iLearnLabel.font = iLearnLabel.font.fontWithSize(100)
        }
        if is_iPhone4{
            iLearnTopConstraint.constant -= 80
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = loginTable.dequeueReusableCellWithIdentifier("LoginCell", forIndexPath: indexPath) as LoginCellTableViewCell
        var sep = UIImage(named: "SeparatorLine.png")
        cell.separatorLine.image = sep
        cell.selectionStyle = .None
        switch indexPath.row{
        case 0:
            cell.label.text = "watid."
            cell.separatorLine.alpha = 0
            cellArray.append(cell)
            return cell
        case 1:
            cell.label.text = "password."
            cell.input.secureTextEntry = true
            cellArray.append(cell)
            return cell
        default:
            break
        }
        return cell
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat = is_iPad ? 240 : 100
        return height
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selCell = cellArray[indexPath.row] as LoginCellTableViewCell
        selCell.input.becomeFirstResponder()
    }
}

