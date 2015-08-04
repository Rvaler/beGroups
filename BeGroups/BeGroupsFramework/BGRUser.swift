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
    
    static func signUpWithUsername(username: String, password: String, email: String, response:(succeeded : Bool, error: NSError?) -> ()) -> Void
    {
        var user = PFUser()
        
        user.username = username
        user.password = password
        user.email = email
        
        var signUpError : NSError? = nil
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response( succeeded: false, error: error)
                
                // TODO: treat error here!
                
            } else {
                // saving logged user in singleton class
                BGRUser.sharedUser.initWithParseUser(user)
                response (succeeded: true, error: error)
            }
        }
    }
    
    static func loginWithUsername(username: String, password: String, response:(succeeded : Bool, error: NSError?) -> ()) -> Void
    {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user : PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                // saving logged user in singleton class
                BGRUser.sharedUser.initWithParseUser(user!)
                response(succeeded: true, error: error )
            } else {
                response(succeeded: false, error: error )
            }
        }
    }
    
    static func performLogOut()
    {
        PFUser.logOut()
        BGRUser.sharedUser.loggedParseUser = nil // nao sei se essa é a forma adequada
    }
    
    static func BGRGetInstitutionsMembers(institutionId : String) -> NSArray? {
        
        var institutionUsersQuery : PFQuery = PFQuery(className: ParseNames.INSTITUTION())
        institutionUsersQuery.whereKey("objectId", equalTo: institutionId)
        
        let institution = institutionUsersQuery.getFirstObject()
        
        var relation = institution?.relationForKey(ParseNames.INSTITUTION_Members())
        
        var users = relation?.query()?.findObjects()
        

        
        if let users = users {

//            for obj in users as! [PFUser] {
//                if (obj).objectId == PFUser.currentUser()?.objectId {
//                    users.
//                }
//            }
            
            
            return users
        } else {
            
            return nil
        }
    }
    
    static func BGRGetUsersNotifications() -> NSArray?
    {
        var lazyNotificationsQuery : PFQuery = PFQuery(className: ParseNames.NOTIFICATION())
        lazyNotificationsQuery.whereKey("toUser", equalTo: PFUser.currentUser()!)
        
        var notifications : NSArray? = lazyNotificationsQuery.findObjects()!
        
        if let notifications = notifications {
            return notifications
        } else {
            return nil
        }
    }
    
}
