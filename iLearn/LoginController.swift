
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
    @IBOutlet weak var iLearnTableVertSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var iLearnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginStatusVertSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTableVertSpaceContraint: NSLayoutConstraint!
    var sessionQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL),
    timeoutTimer:NSTimer!,
    timeoutCount = 0,
    cellArray:Array<LoginCell>!,
    isEditing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(preloadView)
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 1
        timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timeOut", userInfo: nil, repeats: true)
        dispatch_async(self.sessionQueue, { () -> Void in
            APICaller.fetchCookieWithCompletionHandler({ (jsessionID) -> () in
                var sess = SessionVars.sharedInstance
                sess.jsessionID = jsessionID
                self.timeoutTimer.invalidate()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.animateKeyframesWithDuration(0.8, delay: 1, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                        self.preloadView.frame.origin = CGPointMake(0, self.view.frame.height)
                        }, completion: { (complete) -> Void in
                            self.preloadView.removeFromSuperview()
                    })
                })
                }, errorHandler: { () -> () in
                    self.timeoutTimer.invalidate()
                    self.oneSecLabel.text = "connection error."
            })
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
            iLearnTableVertSpaceConstraint.constant -= 40
            if Constants.is_iPhone4(){
                iLearnTopConstraint.constant -= 75
                iLearnBottomConstraint.constant -= 10
                loginTableVertSpaceContraint.constant += 15
            }
            else{
                loginTableHeightConstraint.constant += 60
                if Constants.is_iPhone5(){
                    iLearnTopConstraint.constant -= 80
                }
                else if Constants.is_iPhone6(){
                    loginTableVertSpaceContraint.constant += 40
                    loginStatusVertSpaceConstraint.constant = 30
                    iLearnTableVertSpaceConstraint.constant += 60
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
            cell.input.delegate = self
            return cell
        case 1:
            cell.label.text = "password."
            cell.input.returnKeyType = .Done
            cell.input.secureTextEntry = true
            cellArray.append(cell)
            cell.input.delegate = self
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
        return height
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if !isEditing{
                    textField.attributedPlaceholder = NSAttributedString(string: "")
            isEditing = true
            if !Constants.is_ipad(){
                var offset:CGFloat = 135
                if !Constants.is_iPhone4() && !Constants.is_iPhone5(){
                    offset /= 1.5
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        for subview in self.view.subviews{
                            var sView = subview as UIView
                            sView.frame.origin = CGPointMake(sView.frame.origin.x, sView.frame.origin.y - offset)
                        }
                        }, completion: { (complete) -> Void in
                    })
                })
            }
            
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField{
        case cellArray[0].input:
            cellArray[1].input.becomeFirstResponder()
        default:
            var usernameTextField = cellArray[0].input, pwTextField = cellArray[1].input
            if(usernameTextField.text == "" || pwTextField.text == ""){
                if(usernameTextField.text == ""){
                    usernameTextField.attributedPlaceholder = NSAttributedString(string: "username please.", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                }
                if(pwTextField.text == ""){
                    pwTextField.attributedPlaceholder = NSAttributedString(string: "password please.", attributes: [NSForegroundColorAttributeName:UIColor.redColor()])
                }
            }
            else{
                textField.resignFirstResponder()
                finishEditing()
                var sess = SessionVars.sharedInstance
                let params = "username=\(cellArray[0].input.text)&password=\(textField.text)&lt=e1s1&_eventId=submit&submit=LOGIN"
                println(params)
                dispatch_async(self.sessionQueue, { () -> Void in
                    APICaller.loginWithParams(params, jsessionID: sess.jsessionID, successHandlerWithCASTGCCookieParam: { (CASTGC) -> () in
                        sess.CASTGC = CASTGC
                        }, errorHandler: { () -> () in
                            
                    })
                })
                
            }
        }
        return true;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selCell = cellArray[indexPath.row] as LoginCell
        selCell.input.becomeFirstResponder()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if isEditing{
            for cell in cellArray{
                if cell.input.isFirstResponder(){
                    cell.input.resignFirstResponder()
                }
            }
            finishEditing()
        }
        
    }
    func finishEditing(){
        if !Constants.is_ipad(){
            var offset:CGFloat = 135
            if !Constants.is_iPhone4() && !Constants.is_iPhone5(){
                offset /= 1.5
            }
            println("\(offset)")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    for subview in self.view.subviews{
                        var sView = subview as UIView
                        sView.frame.origin = CGPointMake(sView.frame.origin.x, sView.frame.origin.y + offset)
                    }
                    }, completion: { (complete) -> Void in
                        self.isEditing = false
                })
                
                
            })
        }
    }
}

