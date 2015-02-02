//
//  SessionVars.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-29.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import Foundation
class SessionVars{
    var jsessionID = ""
    var CASTGC = ""
    class var sharedInstance: SessionVars{
        struct Static{
            static var instance: SessionVars?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token, { () -> Void in
            Static.instance = SessionVars()
        })
        return Static.instance!
    }
}

