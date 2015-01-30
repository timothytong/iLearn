
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
    @IBOutlet weak var loginTableHeightConstraint: NSLayoutConstraint!
    var cellArray:Array<LoginCell>!

    override func viewDidLoad() {
        super.viewDidLoad()
//        println(UIScreen.mainScreen().bounds.height)
        cellArray = Array<LoginCell>()
        loginTable.delegate = self
        loginTable.dataSource = self
        let loginCellNib = UINib(nibName: "LoginCell", bundle: nil)
        loginTable.registerNib(loginCellNib, forCellReuseIdentifier: "LoginCell")
        loginTable.reloadData()
        loginTable.scrollEnabled = false
        loginTable.separatorStyle = .None
        if Constants.is_ipad(){
            iLearnLabel.font = iLearnLabel.font.fontWithSize(100)
        }
        else{
            if Constants.is_iPhone4(){
                iLearnTopConstraint.constant -= 80
            }
            else{
                loginTableHeightConstraint.constant += 60
                if Constants.is_iPhone5(){
                    iLearnTopConstraint.constant -= 40
                }
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = loginTable.dequeueReusableCellWithIdentifier("LoginCell", forIndexPath: indexPath) as LoginCell
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
        var height:CGFloat = 0
        if Constants.is_ipad(){
            height = 240
        }else{
            height = Constants.is_iPhone4() ? 100.0 : 130.0
        }
//        println("Returning \(height)")
        return height
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selCell = cellArray[indexPath.row] as LoginCell
        selCell.input.becomeFirstResponder()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

