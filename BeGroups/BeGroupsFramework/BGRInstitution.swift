//
//  Institution.swift
//  
//
//  Created by Anderson Rogério da Silva Gralha on 6/17/15.
//
//

import UIKit
import Parse
import Bolts

class BGRInstitution: NSObject {
    
    static var currentInstitution: PFObject?
    
    static func saveCurrentInstitution(institution:AnyObject)
    {
        self.currentInstitution = institution as? PFObject
    }
    
    static func BGRCreateInstitution(name: String, admin: PFUser, password: String?, privacy: Bool, response:(succeeded : Bool, error: NSError?) -> ()) -> Void
    {
        var newInstitution = PFObject(className: ParseNames.INSTITUTION())
        newInstitution[ParseNames.INSTITUTION_Name()] = name
        newInstitution[ParseNames.INSTITUTION_Password()] = password
        newInstitution[ParseNames.INSTITUTION_Privacy()] = privacy
        
        let adminsRelation = newInstitution.relationForKey(ParseNames.INSTITUTION_Admins())
        adminsRelation.addObject(PFUser.currentUser()!)

        let membersRelation = newInstitution.relationForKey(ParseNames.INSTITUTION_Members())
        membersRelation.addObject(PFUser.currentUser()!)
        

        
        newInstitution.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response( succeeded: false, error: error)
            } else {
                
                self.addInstitutionToUser(admin, institution: newInstitution, response: { (succeeded, error) -> () in
                    if let error = error{
                        let errorString = error.userInfo?["error"] as? NSString
                        response( succeeded: false, error: error)
                    }else{
                        response (succeeded: true, error: error)
                    }
                })
                response (succeeded: true, error: error)
                
            }
        }
    }
    
    private static func addInstitutionToUser(user: PFUser, institution: PFObject, response :(succeeded : Bool, error: NSError?) -> ()) -> Void
    {
        let institutionRelation = user.relationForKey(ParseNames.USER_Institutions())
        institutionRelation.addObject(institution)
        user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response(succeeded: false, error: error)
            }else{
                response (succeeded: true, error: error)
            }
        }
    }
    
    private static func addUserToInstitution(user: PFUser, institution: PFObject, response: (succeeded: Bool, error: NSError?) -> ()) -> Void
    {
        let membersRelation = institution.relationForKey(ParseNames.INSTITUTION_Members())
        membersRelation.addObject(user)
        institution.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                response(succeeded: false, error: error)
            }else{
                response(succeeded: true, error: error)
            }
        }
    }
    
    static func BGRVerifyRequestToInstitution(institution: PFObject, requestingUser: PFUser,password: String?, response:(succeeded: Bool, error: NSError?) -> ()) -> Void
        
    {
        
        self.addInstitutionToUser(requestingUser, institution: institution, response: { (succeeded, error) -> () in
            
            if let error = error {
                response(succeeded: false, error: error)
            }else{
                self.addUserToInstitution(requestingUser, institution: institution, response: { (succeeded, error) -> () in
                    if let error = error {
                        response(succeeded: false, error: error)
                    }else{
                        response(succeeded: true, error: error)
                    }
                })
            }
            
        })
    }
    
    
    static func BGRSearchInstitutionByName(institutionName: String, response: (institutionsResult: NSArray?, error: NSError?) -> ()) -> Void
    {
        var institutionsQuery:PFQuery = PFQuery(className: ParseNames.INSTITUTION())
   
        institutionsQuery.whereKey(ParseNames.INSTITUTION_Name(), matchesRegex: institutionName, modifiers: "i")
        
        institutionsQuery.findObjectsInBackgroundWithBlock { (result, error: NSError?) -> Void in
            if ((result) != nil){
                response(institutionsResult: result, error: error)
            } else {
                response(institutionsResult: nil, error: error)
            }
        }
    }
    
    
    /*Assyncronous*/
    static func BGRGetAllInstitutions(response: (institutionsResult: NSArray?, error: NSError?) -> ()) {
        
        let institutionQuery = PFQuery(className: ParseNames.INSTITUTION())
        let institutionObj = PFObject(className: ParseNames.INSTITUTION())
        
        let  results = institutionQuery.findObjects()
        institutionQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            response(institutionsResult: results, error: error)
        }

    }
    
    static func BGRFetchInstitutionsFromUser(user: PFUser, response: (institutionsResult: NSArray?, error: NSError?) -> ())
    {
        let institutionsRelation = user.relationForKey(ParseNames.USER_Institutions())
        institutionsRelation.query()?.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            response(institutionsResult: result, error: error)
        })
    }

    
    
    static func BGRGetUserInstitutions() -> NSArray? {
        
        if let user = PFUser.currentUser() {
            var userInstitutionsQuery:PFQuery = PFQuery(className: ParseNames.USER())
            userInstitutionsQuery.whereKey("objectId", equalTo: user.objectId!)
            let user = userInstitutionsQuery.getFirstObject()

            var relation = user?.relationForKey(ParseNames.USER_Institutions())
            var institutions = relation?.query()?.findObjects()

            if let institutions = institutions {
                
                println(institutions.description)
                
                return institutions
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    static func BGRAddMemberToInstitution(memberId: String, institutionId: String, response:(succeeded: Bool, error: NSError?) -> ()) -> Void {
        
        let memberQuery: PFQuery = PFQuery(className: ParseNames.USER())
        memberQuery.whereKey("objectId", equalTo: memberId)
        let memberObjc = memberQuery.getObjectWithId(memberId)

        let institutionQuery: PFQuery = PFQuery(className: ParseNames.INSTITUTION())
        institutionQuery.whereKey("objectId", equalTo: institutionId)
        var institutionObjc = institutionQuery.getObjectWithId(institutionId)

        let membersRelation = institutionObjc!.relationForKey(ParseNames.INSTITUTION_Members())
        membersRelation.addObject(memberObjc!)
        
        institutionObjc?.save()
        
    }
    
    
    static func BGRGetMembersOfInstitution(institution: PFObject, response: (results: [PFObject]?, error: NSError?) -> () ) -> Void {
        
        let membersRelation = institution.relationForKey(ParseNames.INSTITUTION_Members())
        membersRelation.query()?.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            let downcastArray = results as! [PFObject]
            response(results: downcastArray, error: error)
        })
        
    }
    
    static func BGRGetMembersOfInstitution(institutionId: String) -> Void {
        
        let institutionQuery: PFQuery = PFQuery(className: ParseNames.INSTITUTION())
        institutionQuery.whereKey("objectId", equalTo: institutionId)
        var institutionObjc = institutionQuery.getObjectWithId(institutionId)
        let membersRelation = institutionObjc!.relationForKey(ParseNames.INSTITUTION_Members())
        
        let results = membersRelation.query()?.findObjects()
        println(results)
        
    }
    
    static func BGRGetActivitiesOfInstitution(institutionId: String) -> Void {
        
        let institutionQuery: PFQuery = PFQuery(className: ParseNames.INSTITUTION())
        institutionQuery.whereKey("objectId", equalTo: institutionId)
        var institutionObjc = institutionQuery.getObjectWithId(institutionId)
        /*  TODO PARSE NAMES */
        let activitiesRelation = institutionObjc!.relationForKey("activities")
        
        let results = activitiesRelation.query()?.findObjects()
        println(results)
    }
    
    static func BGRGetActivitiesOfInstitutioninBackGround(institutionObjc: PFObject, response: (results: [PFObject]?, error: NSError?) -> () ) -> Void {
        
        let activitiesRelation = institutionObjc.relationForKey("activities")
        activitiesRelation.query()?.findObjectsInBackgroundWithBlock({ (resultsArray, error) -> Void in
            let resultCast = resultsArray as! [PFObject]?
            response(results: resultCast, error: error)
        })
    }
    
    static func BGRGetGroupsOfActivity(activityId: String) -> Void {
        
    }
    
    //verify if an user is already member of an institution
    static func BGRVerifyInstitutionMember(user: PFUser, institution: PFObject, response: (succeeded: Bool, error: NSError?) -> () ) -> Void
    {
        var isMember = false
        let institutionRelation = user.relationForKey(ParseNames.USER_Institutions())
        institutionRelation.query()?.findObjectsInBackgroundWithBlock({ (institutionsResult, error) -> Void in
            
            if let institutions = institutionsResult as? [PFObject]
            {
                for institutionObject in institutions
                {
                    if((institutionObject.objectId) == institution.objectId){
                        isMember = true
                    }
                }
            }
            response(succeeded: isMember, error: error)
        })
    }
    
    
    static func BGRVerifyInstitutionAdmin(user: PFUser, institution: PFObject, response: (succeeded: Bool, error: NSError?) -> () ) -> Void
    {
        var isAdmin = false
        let adminsRelation = institution.relationForKey(ParseNames.INSTITUTION_Admins())
        adminsRelation.query()?.findObjectsInBackgroundWithBlock({ (adminsResult, error) -> Void in
            if let admins = adminsResult as? [PFObject]
            {
                for admin in admins
                {
                    if(admin.objectId == user.objectId){
                        isAdmin = true
                    }
                }
            }
            response(succeeded: isAdmin, error: error)
        })
    }
    
    
    
    
}
