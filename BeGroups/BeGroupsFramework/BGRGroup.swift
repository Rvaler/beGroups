//
//  Group.swift
//
//
//  Created by Anderson Rogério da Silva Gralha on 6/17/15.
//
//

import UIKit
import Parse
import Bolts

class BGRGroup: NSObject {
    
    static var currentGroup: PFObject!
    
    
    static func BGRCreateGroupWithName(name: String, onInstitution: PFObject, inActivity: PFObject, response: (succeeded: Bool, error: NSError?) -> ()) -> Void
    {
        var newGroup = PFObject(className: ParseNames.GROUP())
        newGroup[ParseNames.GROUP_Name()] = name
        newGroup[ParseNames.GROUP_Activitiy()] = inActivity
        newGroup[ParseNames.GROUP_Institution()] = onInstitution
        
        let memberRelation = newGroup.relationForKey(ParseNames.GROUP_Members())
        memberRelation.addObject(PFUser.currentUser()!)
        
        newGroup.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response (succeeded: false, error: error)
            } else {
                
                self.addGroupToActivity(newGroup, activity: inActivity, response: { (succeeded, error) -> () in
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? NSString
                        response(succeeded: false, error: error)
                    }else{
                        
                        self.addGroupToUser(newGroup, user: PFUser.currentUser()!, response: { (succeeded, error) -> () in
                            if let error = error {
                                let errorString = error.userInfo?["error"] as? NSString
                                response(succeeded: false, error: error)
                            }else{
                                response (succeeded: true, error: error)
                            }
                        })
                        response (succeeded: true, error: error)
                    }
                })
                
                response (succeeded: true, error: error)
            }
        }
    }
    
    private static func addGroupToActivity(group: PFObject, activity: PFObject ,response: (succeeded: Bool, error: NSError?) -> ()) -> Void
    {
        let groupRelation = activity.relationForKey(ParseNames.ACTIVITY_Groups())
        groupRelation.addObject(group)
        
        activity.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response(succeeded: false, error: error)
            }else{
                response (succeeded: true, error: error)
            }
        }
    }
    
    private static func addGroupToUser(group: PFObject, user: PFUser, response: (succeeded: Bool, error: NSError?) -> ()) -> Void
    {
        let groupRelation = user.relationForKey(ParseNames.USER_Groups())
        groupRelation.addObject(group)
        
        user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response(succeeded: false, error: error)
            }else{
                response (succeeded: true, error: error)
            }
        }
    }
    
    //    static func BGRFetchGroupsFromUser(user: PFUser, response: (groupsResult: NSArray?, activitiesResult : NSArray? ,error: NSError?) -> ()) -> Void
    //    {
    //
    ////        var innerQuery = PFQuery(className: ParseNames.GROUP())
    ////        innerQuery.includeKey(ParseNames.GROUP_Activitiy())
    ////        innerQuery.includeKey(ParseNames.GROUP_Institution())
    //
    //        let groupsRelation = user.relationForKey(ParseNames.USER_Groups())
    //        groupsRelation.query()?.includeKey(ParseNames.USER_Groups())
    ////        groupsRelation.query()?.includeKey("groups.groupActivity")
    ////        groupsRelation.query()?.includeKey("groups.groupInstitution")
    //
    //        groupsRelation.query()?.findObjectsInBackgroundWithBlock { (groupsResult, error: NSError?) -> Void in
    //
    //            if let groups = groupsResult as? [PFObject]
    //            {
    //                var array : NSMutableArray?
    //                var index = groups.count
    //                for group in groups
    //                {
    //                    let activity: AnyObject? = group.objectForKey(ParseNames.GROUP_Activitiy())
    //                    print("atividade dentro da query \(activity)")
    //                    let activityQuery: PFQuery = PFQuery(className: ParseNames.ACTIVITY())
    //                    activityQuery.whereKey("objectId", equalTo: activity!.valueForKey("objectId")!)
    //
    //                    activityQuery.getFirstObjectInBackgroundWithBlock({ (activitiesResult, error: NSError?) -> Void in
    //                        if let activitiesResult = activitiesResult{
    //                            array?.addObject(activitiesResult)
    //                            index = index - 1
    //                        }
    //
    //                    })
    ////                    activityQuery.getFirstObjectInBackgroundWithBlock({ (activityResult, error: NSError?) -> Void in
    ////
    ////                    })
    //
    ////                    print(group[ParseNames.GROUP_Activitiy()])
    ////                    print(activity?.valueForKey("objectId"))
    //
    //                }
    //
    //                if (index == 0){
    //                    response(groupsResult: groups, activitiesResult: array, error: error)
    //                }
    //
    //            } else {
    //                response(groupsResult: nil, activitiesResult: nil, error: error)
    //            }
    //        }
    //    }
    
    
    
    static func BGRFetchGroupsFromUser(user: PFUser, response: (groupsResult: NSArray?, activitiesResult : NSArray? ,error: NSError?) -> ()) -> Void
    {
        
        //        var innerQuery = PFQuery(className: ParseNames.GROUP())
        //        innerQuery.includeKey(ParseNames.GROUP_Activitiy())
        //        innerQuery.includeKey(ParseNames.GROUP_Institution())
        
        let groupsRelation = user.relationForKey(ParseNames.USER_Groups())
        groupsRelation.query()?.includeKey(ParseNames.USER_Groups())
        //        groupsRelation.query()?.includeKey("groups.groupActivity")
        //        groupsRelation.query()?.includeKey("groups.groupInstitution")
        
        groupsRelation.query()?.findObjectsInBackgroundWithBlock { (groupsResult, error: NSError?) -> Void in
            
            if let groups = groupsResult as? [PFObject]
            {
                var array : NSMutableArray?
                var index = groups.count
                for group in groups
                {
                    let activity: AnyObject? = group.objectForKey(ParseNames.GROUP_Activitiy())
                    print("atividade dentro da query \(activity)")
                    let activityQuery: PFQuery = PFQuery(className: ParseNames.ACTIVITY())
                    activityQuery.whereKey("objectId", equalTo: activity!.valueForKey("objectId")!)
                    
                    activityQuery.getFirstObjectInBackgroundWithBlock({ (activitiesResult, error: NSError?) -> Void in
                        if let activitiesResult = activitiesResult{
                            array?.addObject(activitiesResult)
                            index = index - 1
                        }
                        
                    })
                    //                    activityQuery.getFirstObjectInBackgroundWithBlock({ (activityResult, error: NSError?) -> Void in
                    //
                    //                    })
                    
                    //                    print(group[ParseNames.GROUP_Activitiy()])
                    //                    print(activity?.valueForKey("objectId"))
                    
                    
                }
                
                if (index == 0){
                    response(groupsResult: groups, activitiesResult: array, error: error)
                }
                
                
                
                
                
                
            } else {
                response(groupsResult: nil, activitiesResult: nil, error: error)
            }
        }
    }
    
    static func BGRCreateGroup(name: String?, institutionId: String, activityId: String?, inviteMembers: NSArray?) -> Bool {
        var newGroup = PFObject(className: ParseNames.GROUP())

            newGroup[ParseNames.GROUP_Name()] = name

        if newGroup.save() {
            var usersRelation = newGroup.relationForKey(ParseNames.GROUP_Members())
            usersRelation.addObject(PFUser.currentUser()!)
            
            var groupsRelation = PFUser.currentUser()?.relationForKey(ParseNames.USER_Groups())
            groupsRelation?.addObject(newGroup)
            
            PFUser.currentUser()?.save()
            
            if newGroup.save() {
                println("Group Created")
                
                if let activityId = activityId {
                    var activityQuery = PFQuery(className: ParseNames.ACTIVITY())
                    activityQuery.whereKey(ParseNames.OBJECTID(), equalTo: activityId)
                    let activity = activityQuery.getFirstObject()
                    
                    var activityRelation = activity!.relationForKey(ParseNames.ACTIVITY_Groups())
                    activityRelation.addObject(newGroup)
                    
                    if activity!.save() {
                        
                        newGroup[ParseNames.ACTIVITY()] = activity
                        newGroup.save()
                        
                        println("Group added in Activity Relation")
                        
                    } else {
                        println("Couldn't save new group.")
                    }
                }
                
                var institutuionQuery = PFQuery(className: ParseNames.INSTITUTION())
                institutuionQuery.whereKey(ParseNames.OBJECTID(), equalTo: institutionId)
                let institution = institutuionQuery.getFirstObject()
                
                var institutionsRelation = institution?.relationForKey(ParseNames.GROUP_Groups())
                institutionsRelation!.addObject(newGroup)
                
                if institution!.save() {
                    println("Group added in Institution Relation")
                    //
                    
                    newGroup[ParseNames.GROUP_Institution()] = institution
                    newGroup.save()
                    
                    if let inviteMembers = inviteMembers {
                        for member in inviteMembers {
                            self.BGRInviteUser(member as! PFUser, toGroup: newGroup, response: { (succeeded, error) -> () in
                                println(succeeded)
                                println(error)
                            })
                        }
                    }
                    
                    self.currentGroup = newGroup
                    
                    ///
                    return true
                } else {
                    println("Couldn't save new group.")
                    return false
                }
                
            } else {
                println("Couldn't save new group.")
                return false
            }
        } else {
            println("Couldn't save new group.")
            return false
        }
    }
    
    static func BGRFetchGroupsByInstitution (institutionId : String) -> NSArray? {
        
        var institutionQuery: PFQuery = PFQuery(className: ParseNames.INSTITUTION())
        institutionQuery.whereKey(ParseNames.OBJECTID(), equalTo: institutionId)
        let institution = institutionQuery.getFirstObject()
        
        var relation = institution?.relationForKey(ParseNames.GROUP_Groups())
        var groups = relation?.query()?.findObjects()
        
        if let groups = groups {
            return groups
        } else {
            return nil
        }
        
    }
    
    static func BGRInviteUser(user : PFUser, toGroup: PFObject, response:(succeeded : Bool, error: NSError?) -> ()) -> Void {
        
        var newMessage = PFObject(className: ParseNames.NOTIFICATION())
        
        newMessage["fromGroup"] = toGroup
        newMessage["toUser"] = user
        
        var username = PFUser.currentUser()!.username! as String!
        var groupname: String = toGroup["name"]! as! String
        var notification = "\(username) invited you to the group \(groupname)"
        newMessage["description"] = notification
        newMessage["type"] = ParseNames.NOTIFICATION_InviteUserToGroup()
        newMessage["read"] = false
        
        newMessage.saveInBackgroundWithBlock { (succedeed: Bool, error: NSError?) -> Void in
            
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response( succeeded: false, error: error)
            } else {
                
                
                response (succeeded: true, error: error)
                
            }
        }
    }
    
    static func BGRVerifyIfUserIsInGroup(user: PFUser, group: PFObject) -> Bool
    {
        var verifyIfInGroup: PFQuery = PFQuery(className: ParseNames.GROUP_Members())
        verifyIfInGroup.whereKey(ParseNames.OBJECTID(), equalTo: user.objectId!)
        var user = verifyIfInGroup.getFirstObject()
        
        if user == nil {
            return false
        } else {
            return true
        }
        
        
    }
    
    static func BGRAcceptInvitationFromGroup(notification: PFObject, group: PFObject, response:(succeeded: Bool, error: NSError?) -> ()) -> Void {
        
        if self.BGRVerifyIfUserIsInGroup(PFUser.currentUser()!, group: group) == false
        {
            var relation = group.relationForKey(ParseNames.GROUP_Members())
            relation.addObject(PFUser.currentUser()!)
            
            group.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                response (succeeded: true, error: error)
            })
            
            var relation2 = PFUser.currentUser()?.relationForKey(ParseNames.USER_Groups())
            relation2?.addObject(group)
            
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (suceeded: Bool, error: NSError?) -> Void in
                response (succeeded: true, error: error)
            })
            
            
            
            notification["read"] = true
            
            notification.save()
            
        } else {
            response (succeeded: false, error: NSError())
        }
    }
    
    static func BGRAcceptUserInGroup(notification: PFObject, group: PFObject, response:(succeeded: Bool, error: NSError?) -> ()) -> Void {
        
        var query = PFQuery(className: ParseNames.USER())
        query.whereKey(ParseNames.OBJECTID(), equalTo: notification["fromUser"]!)
        var user = query.getFirstObject()
        
        if self.BGRVerifyIfUserIsInGroup(user as! PFUser, group: group) == false
        {
            
            var relation = group.relationForKey(ParseNames.GROUP_Members())
            relation.addObject(user!)
            
            group.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                response (succeeded: true, error: error)
            })
            
            var relation2 = user!.relationForKey(ParseNames.USER_Groups())
            relation2.addObject(group)
            
            user!.saveInBackgroundWithBlock({ (suceeded: Bool, error: NSError?) -> Void in
                response (succeeded: true, error: error)
            })
            
            notification.delete()
            
        } else {
            response (succeeded: false, error: NSError())
        }
    }
    
    static func BGRGetMembersFromGroup(group: PFObject, response:(results: [PFObject], error: NSError?) -> ()) -> Void {
        
        var relationMember = group.relationForKey(ParseNames.GROUP_Members())
        relationMember.query()?.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            let resultsFromQuery = results as! [PFObject]
            response(results: resultsFromQuery, error: error)
        })
    }
    
    static func BGRAskToJoinGroup(group: PFObject, response:(response: Bool, error: NSError?) -> ()) -> Void {
        
        self.BGRGetMembersFromGroup(group, response: { (results, error) -> () in
            
            var usersInGroup : [PFObject] = results
            
            for user in usersInGroup {
                
                var newMessage = PFObject(className: ParseNames.NOTIFICATION())
                
                newMessage["fromUser"] = PFUser.currentUser()
                newMessage["toGroup"] = group
                newMessage["toUser"] = user
                newMessage["type"] = ParseNames.NOTIFICATION_AskToJoinGroup()
                
                var nameName = PFUser.currentUser()!.username! as String!
                var groupName = group["name"]! as! String
                var notification = "\(nameName) asked to join \(groupName)"
                
                newMessage["description"] = notification
                
                newMessage.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? NSString
                        response(response: false, error: error)
                    } else {
                        
                        response(response: true, error: error)
                    }
                    
                })
            }
        })
    }
}
