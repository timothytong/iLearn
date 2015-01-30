
//
//  LoginController.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-26.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var preloadView: UIView!
    @IBOutlet weak var oneSecLabel: UILabel!
    @IBOutlet weak var iLearnLabel: UILabel!
    @IBOutlet weak var loginTable: UITableView!
    @IBOutlet weak var iLearnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTableHeightConstraint: NSLayoutConstraint!
    var timeoutTimer:NSTimer!
    var timeoutCount = 0
    var cellArray:Array<LoginCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timeOut", userInfo: nil, repeats: true)
        APICaller.fetchCookieWithCompletionHandler({ (jsessionID) -> () in
            var sess = SessionVars.sharedInstance
            sess.cookie = jsessionID
            self.timeoutTimer.invalidate()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIView.animateKeyframesWithDuration(0.8, delay: 1, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                    self.preloadView.frame.origin = CGPointMake(0, self.view.frame.height)
                    }, completion: { (complete) -> Void in
                })
            })
            }, errorHandler: { () -> () in
                self.timeoutTimer.invalidate()
                self.oneSecLabel.text = "connection error."
        })
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
    
    func timeOut(){
        println("timeout")
        timeoutCount++
        if timeoutCount == 1{
            oneSecLabel.text = "ok maybe more."
            if !Constants.is_ipad(){
                oneSecLabel.font = oneSecLabel.font.fontWithSize(50)
            }
        }
        else if timeoutCount == 2{
            oneSecLabel.text = "awe, timed out."
            self.timeoutTimer.invalidate()
        }
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

