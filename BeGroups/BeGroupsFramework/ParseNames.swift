//
//  ParseName.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/17/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit


class ParseNames : NSObject {
    
    // Global Names
    static func OBJECTID() -> String
    {
        return "objectId"
    }
    
    
    // class names
    
    static func INSTITUTION() -> String
    {
        return "Institution"
    }
    
    static func GROUP() -> String
    {
        return "Group"
    }
    static func USER() -> String
    {
        return "_User"
    }
    static func NOTIFICATION() -> String
    {
        return "Notification"
    }
    static func ACTIVITY() -> String {
        return "Activity"
    }
    
    // atribute names
    
    //INSTITUTION atributes
    
    static func INSTITUTION_Admins() -> String
    {
        return "admins"
    }
    static func INSTITUTION_Members() -> String
    {
        return "members"
    }
    static func INSTITUTION_Name() -> String
    {
        return "name"
    }
    static func INSTITUTION_Groups() -> String
    {
        return "groups"
    }
    static func INSTITUTION_Password() -> String
    {
        return "password"
    }
    static func INSTITUTION_Privacy() -> String
    {
        return "privacy"
    }
    static func INSTITUTION_Activities() -> String
    {
        return "activities"
    }
    static func INSTITUTION_Image() -> String
    {
        return "image"
    }
    static func INSTITUTION_Banner() -> String
    {
        return "banner"
    }
    
    //GROUP atributes
    
    static func GROUP_Image() -> String
    {
        return "image"
    }
    static func GROUP_Members() -> String
    {
        return "members"
    }
    static func GROUP_Name() -> String
    {
        return "name"
    }
    static func GROUP_Groups() -> String
    {
        return "groups"
    }
    static func GROUP_Activitiy() -> String
    {
        return "Activity"
    }
    static func GROUP_Institution() -> String
    {
        return "groupInstitution"
    }
    
    //USER atributes
    
    static func USER_Notifications() -> String
    {
        return "notifications"
    }
    static func USER_Institutions() -> String
    {
        return "institutions"
    }
    static func USER_Username() -> String
    {
        return "username"
    }
    static func USER_Password() -> String
    {
        return "password"
    }
    static func USER_Email() -> String
    {
        return "email"
    }
    static func USER_Groups() -> String
    {
        return "groups"
    }
    static func USER_Picture() -> String
    {
        return "picture"
    }
        //ACTIVITY atributes

    static func ACTIVITY_Name() -> String
    {
        return "name"
    }
    
    static func ACTIVITY_Groups() -> String
    {
        return "groups"
    }
    static func ACTIVITY_DeliveryDate() -> String
    {
        return "deliveryDate"
    }
    
    //NOTIFICATION Types
    
    static func NOTIFICATION_ActivityCreated() -> String
    {
        return "ActivityCreated"
    }
    static func NOTIFICATION_AskToJoinGroup() -> String
    {
        return "AskToJoinGroup"
    }
    static func NOTIFICATION_InviteUserToGroup() -> String
    {
        return "InviteUserToGroup"
    }
    
    
    
    
}


