//
//  InterfaceController.swift
//  BeGroups WatchKit Extension
//
//  Created by Anderson Rogério da Silva Gralha on 6/17/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import WatchKit
import Foundation
import Parse


class InterfaceController: WKInterfaceController {

    @IBOutlet var labelName: WKInterfaceLabel!
    @IBOutlet weak var tableGroups: WKInterfaceTable!
    
//    @IBOutlet weak var tableGroups: WKInterfaceGroup!
    
//    var arrayZao : NSArray
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        labelName.setText("")
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func askForName() {
        
        sendMessageToParentAppWithString("Group")
        
    }
    
    @IBAction func askForAge() {
        
                sendMessageToParentAppWithString("Institution")
        
    }
    func sendMessageToParentAppWithString(messageText: String) {
        let infoDictionary = ["ACTION" : messageText]
        
        WKInterfaceController.openParentApplication(infoDictionary) {
            (replyDictionary, error) -> Void in
            
            if let castedResponseDictionary = replyDictionary as? [String: String],
                responseMessage = castedResponseDictionary["ACTION"]
            {
                
                self.labelName.setText(responseMessage)
                
            }
        }
    }




}
