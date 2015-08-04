//
//  BGRUser.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/20/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import Foundation
import Parse


class BGRUser {
    
    var loggedParseUser : PFUser?
    
    class var sharedUser: BGRUser {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BGRUser? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BGRUser()
        }
        return Static.instance!
    }
    
    func initWithParseUser(parseUser:PFUser) {
        
        if (self.loggedParseUser == nil){
            self.loggedParseUser = parseUser
        }
    }
}
