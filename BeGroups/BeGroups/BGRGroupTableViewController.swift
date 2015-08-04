//
//  BGRGroupViewController.swift
//
//
//  Created by Anderson Rogério da Silva Gralha on 6/22/15.
//
//

import UIKit
import Parse

class BGRGroupTableViewController: UITableViewController {
    
    @IBOutlet weak var BGRNameTextField: UITextField!
    @IBOutlet weak var BGRInstitutionText: UILabel!
    @IBOutlet weak var BGRActivityText: UILabel!
    @IBOutlet weak var BGRCreateGroupButton: UIButton!
    
    var BGRSavedInstitution : PFObject!
    var BGRSavedActivity : PFObject!
    var usersToInvite = [PFUser]()
    
    
    var BGRInstitutionList : NSArray!
    
    override func viewDidLoad() { //institution : PFObject, activity : PFObject
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clearColor()
        var background:UIImage = UIImage(named: "Background-white")!
        var view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(patternImage: background)
        tableView.backgroundView = view
        
        
        BGRCreateGroupButton.layer.cornerRadius = 25
        
//        var query = PFQdentrory.getFirstObject()
//        
//        
//        
////        BGRGroup.BGRAskToJoinGroup(group!, response: { (response, error) -> () in
//
//        })
        
//        BGRUser.loginWithUsername("Anderson", password: "123456") { (succeeded, error) -> () in
//            
//        }
        
        
        
        //=================== Plus Friend Button
        
        let screeSize = UIScreen.mainScreen().bounds
        
//        BGRAddMembersButton.frame = CGRect(x: BGRAddMembersButton.frame.height, y: (screeSize.size.width * 0.75), width: 40, height: 40)
        
        //===================
        
        
        
        //=================== Style Name Text Field
        BGRNameTextField.borderStyle = UITextBorderStyle.None
        
        var border1 = CALayer()
        var width = CGFloat(1.0)
        
        border1.borderColor = UIColor.lightGrayColor().CGColor
        border1.frame = CGRect(x: 0, y: BGRNameTextField.frame.size.height - width, width: BGRNameTextField.frame.size.width, height: BGRNameTextField.frame.size.height)
        
        border1.borderWidth = width
        
        BGRNameTextField.layer.addSublayer(border1)
        BGRNameTextField.layer.masksToBounds = true
        
        BGRNameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        //===================
        
        
        //=================== Style Institution Label
        var border2 = CALayer()
        border2.borderColor = UIColor.lightGrayColor().CGColor
        border2.frame = CGRect(x: 0, y: BGRInstitutionText.frame.size.height - width, width: BGRInstitutionText.frame.size.width, height: BGRInstitutionText.frame.size.height)
        
        border2.borderWidth = width
        
        BGRInstitutionText.layer.addSublayer(border2)
        BGRInstitutionText.layer.masksToBounds = true
        
        if let BGRSavedInstitution = BGRInstitution.currentInstitution {
            
            let underlineAttributedStringIntitution = NSAttributedString(string: BGRSavedInstitution["name"] as! String, attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
            BGRInstitutionText.attributedText = underlineAttributedStringIntitution
            
            BGRInstitutionText.hidden = false
        }
        
        
        //===================
        
        
        //=================== Style Activity Label
        var border3 = CALayer()
        border3.borderColor = UIColor.lightGrayColor().CGColor
        border3.frame = CGRect(x: 0, y: BGRActivityText.frame.size.height - width, width: BGRActivityText.frame.size.width, height: BGRActivityText.frame.size.height)
        
        border3.borderWidth = width
        
        BGRActivityText.layer.addSublayer(border3)
        BGRActivityText.layer.masksToBounds = true
        
        if let BGRSavedActivity = BGRActivity.currentActivity {
            let underlineAttributedStringActivity = NSAttributedString(string: BGRSavedActivity["name"] as! String, attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
            
            BGRActivityText.attributedText = underlineAttributedStringActivity
            
            BGRActivityText.hidden = false
        }
        //===================
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.BGRInstitutionList = BGRInstitution.BGRGetUserInstitutions()
        })
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BGRAddMembersToGroupButton(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "AddMembers", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("addMembersViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func BGRConfirmGroupCreation(sender: AnyObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
                    BGRGroup.BGRCreateGroup(self.BGRNameTextField.text, institutionId: BGRInstitution.currentInstitution!.objectId!, activityId: BGRActivity.currentActivity?.objectId, inviteMembers: self.usersToInvite)
//
//            BGRGroup.BGRCreateGroup(self.BGRNameTextField.text, institutionId: "FTktCZun9s", activityId: nil, inviteMembers: self.usersToInvite)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let groupDetailStoryboard = UIStoryboard(name: "GroupDetail", bundle: nil)
                let groupDetailVC : BGRGroupDetailViewController = groupDetailStoryboard.instantiateInitialViewController() as! BGRGroupDetailViewController
                
                self.navigationController?.pushViewController(groupDetailVC, animated: true)
            })
        })
    }
    
    @IBAction func BGRSaveInvitedPlayers(segue:UIStoryboardSegue) {
        
        if let BGRAddMembersToGroupViewController = segue.sourceViewController as? BGRAddMembersToGroupViewController {
            
            
            usersToInvite.extend(BGRAddMembersToGroupViewController.selectedUsers)
            
            for user in usersToInvite {
                println(user.description)
            }
            
        }
        
        
    }
    
    @IBAction func BGRConfirmGroupCreationButton(sender: AnyObject) {
        
        BGRGroup.BGRCreateGroup(self.BGRNameTextField.text, institutionId: self.BGRSavedInstitution.objectId!, activityId: self.BGRSavedActivity?.objectId, inviteMembers: self.usersToInvite)
        
        
    }
    
    @IBAction func unwindToGroupCreationViewController(segue: UIStoryboardSegue) {
    
        if let BGRAddMembersToGroupViewController = segue.sourceViewController as? BGRAddMembersToGroupViewController {
            
            
            usersToInvite.extend(BGRAddMembersToGroupViewController.selectedUsers)
            
            for user in usersToInvite {
                println(user.description)
            }
            
        }
        
        
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
