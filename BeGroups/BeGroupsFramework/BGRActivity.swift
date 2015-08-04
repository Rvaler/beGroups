//
//  BGRActivity.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/26/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import Foundation
import Parse
import Bolts


class BGRActivity: NSObject {
    
    static var currentActivity: PFObject?
    
    
    
    
    static func saveCurrentActivity(activity:AnyObject)
    {
        self.currentActivity = activity as? PFObject
    }

    
    static func BGRCreateActivityWithName(name: String, inInstitution: PFObject, dueTo: NSDate ,response: (succeeded:Bool, error:NSError?) -> ()) -> Void
    {
        var newActivity = PFObject(className: ParseNames.ACTIVITY())
        newActivity[ParseNames.ACTIVITY_Name()] = name
        newActivity[ParseNames.ACTIVITY_DeliveryDate()] = dueTo
        
        newActivity.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response( succeeded: false, error: error)
            } else {
                self.addActivityToInstitution(newActivity, institution: inInstitution, response: { (succeeded, error) -> () in
                    if let error = error{
                        let errorString = error.userInfo?["error"] as? NSString
                        response( succeeded: false, error: error)
                    }else{
                        self.BGRSendNotificationsToMembersOfInstitutionAboutTheLatestCreatedActivity(newActivity, institution: inInstitution, name: name, response: { (succeeded, error) -> () in
                            
                            response(succeeded: succeeded, error: error)
                        })
                    }
                })
            }
        }
    }
    
    
    // used to add the an activity to the institution->activities relation on parse
    private static func addActivityToInstitution(activity: PFObject, institution: PFObject, response: (succeeded: Bool, error: NSError?) -> ()) -> Void
    {
        let activityRelation = institution.relationForKey(ParseNames.INSTITUTION_Activities())
        activityRelation.addObject(activity)
        
        institution.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response(succeeded: false, error: error)
            } else {
                response (succeeded: true, error: error)
            }
        }
    }
    
    private static func BGRSendNotificationsToMembersOfInstitutionAboutTheLatestCreatedActivity(activity: PFObject, institution: PFObject, name: String, response: (succeeded: Bool, error: NSError?)->()) -> Void {
        
        var relationInstitutionMembers = institution.relationForKey(ParseNames.INSTITUTION_Members())
        relationInstitutionMembers.query()?.findObjectsInBackgroundWithBlock({ (members, error: NSError?) -> Void in
            
            var memberList: [PFUser]? = members as! [PFUser]?
            
            if let memberList = memberList {
                var notification0 = institution[ParseNames.INSTITUTION_Name()] as! String
                var notification = "The institution \(notification0) created a new activity"
                
                for member in memberList {
                    
                    var newMessage = PFObject(className: ParseNames.NOTIFICATION())
                    newMessage["description"] = notification
                    newMessage["toUser"] = member
                    newMessage["fromInstitution"] = institution
                    newMessage["type"] = ParseNames.NOTIFICATION_ActivityCreated()
                            newMessage["read"] = false
//                    newMessage["toActivity"] = activity
                    
                    newMessage.save()
                    
                }
                
                response (succeeded: true, error: error)
                
            } else {
                response (succeeded: false, error: error)
            }
        })
        
        
    }
    
    
    
    
    static func BGRFetchActivitiesFromInstitution(institution: PFObject, response: (result: NSArray?, error: NSError?) -> ()) -> Void
    {
        var activitiesRelation = institution.relationForKey(ParseNames.INSTITUTION_Activities())
        var activities: Void? = activitiesRelation.query()?.findObjectsInBackgroundWithBlock({ (activitiesResult, error: NSError?) -> Void in
            if ((activitiesResult) != nil){
                response(result: activitiesResult, error: error)
            } else {
                response(result: nil, error: error)
            }
        })
    }
    
    
    // EQUAL FUNCTION, BUT ALSO RETURN THE INSTITUTION
    static func BGRFetchActivitiesFromInstitutionAndReturnInstitution(inInstitution: PFObject, response: (result: NSArray?, institution: PFObject, error: NSError?) -> ()) -> Void
    {
        var activitiesRelation = inInstitution.relationForKey(ParseNames.INSTITUTION_Activities())
        var activities: Void? = activitiesRelation.query()?.findObjectsInBackgroundWithBlock({ (activitiesResult, error: NSError?) -> Void in
            if ((activitiesResult) != nil){
                response(result: activitiesResult, institution: inInstitution ,error: error)
            } else {
                response(result: nil, institution: inInstitution, error: error)
            }
        })
    }
    

    
    static func BGRGroupsFromActivity(activity: PFObject, response: (result: [PFObject], error: NSError?) -> ()) -> Void
    {
        var groupsRelation = activity.relationForKey(ParseNames.ACTIVITY_Groups())
        groupsRelation.query()?.findObjectsInBackgroundWithBlock({ (groupsResult, error: NSError?) -> Void in
            let results = groupsResult as! [PFObject]
            response(result: results, error: error)
        })
    }
    
    
}