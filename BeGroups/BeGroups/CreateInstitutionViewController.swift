//
//  CreateInstitutionViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/20/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class CreateInstitutionViewController: UIViewController {

    @IBOutlet weak var textFieldInstitutionConfirmPassword: UITextField!
    @IBOutlet weak var textFieldInstitutionPassword: UITextField!
    @IBOutlet weak var textFieldInstitutionName: UITextField!
    @IBOutlet weak var buttonCreateInstitution: UIButton!
    @IBOutlet weak var switchInstitutionPrivacy: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCreateInstitution.layer.cornerRadius = 25;
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCreateInstitution(sender: UIButton) {
        
        let privacySwitchState : Bool?
        if(switchInstitutionPrivacy.on){
            privacySwitchState = true
        } else {
            privacySwitchState = false
        }
        
        BGRInstitution.BGRCreateInstitution(textFieldInstitutionName.text, admin: BGRUser.sharedUser.loggedParseUser!, password: textFieldInstitutionPassword.text, privacy:privacySwitchState!) { (succeeded, error) -> () in
            
            // return to home view if succeeded
            if (succeeded){
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
            
            
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
