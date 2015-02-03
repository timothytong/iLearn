//
//  Constants.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-29.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import Foundation
import UIKit
class Constants {
    enum LearnStatus{
        case NoToken
        case Connected
        case TokenExpired
    }
    private var status:LearnStatus!
    class func is_ipad() -> Bool{
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad ? true : false
    }
    class func is_iPhone4() -> Bool{
        return UIScreen.mainScreen().bounds.height < 568 ? true : false
    }
    class func is_iPhone5() -> Bool{
        return UIScreen.mainScreen().bounds.height == 568 ? true : false
    }
    class func is_iPhone6() -> Bool{
        return UIScreen.mainScreen().bounds.height > 736 ? true : false
    }
}