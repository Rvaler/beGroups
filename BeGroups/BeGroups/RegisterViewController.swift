//
//  RegisterViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/23/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFIeldConfirmPassword: UITextField!
    @IBOutlet weak var buttonDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonDone.layer.cornerRadius = 25;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionSignUpUser(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Error", message: "Passwords dont match", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //hhohoo
        })
        alertController.addAction(alertAction)
        
        if let confirmation = textFIeldConfirmPassword.text {
            if let password = textFieldPassword.text{
                if confirmation == password {
                    BGRUser.signUpWithUsername(textFieldUsername.text, password: textFieldPassword.text, email: textFieldEmail.text) { (succeeded, error) -> () in
                        if (succeeded){
                            // segue to main view of app
                            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                            //let viewController = storyBoard.instantiateViewControllerWithIdentifier("mainTabBar") as! UIViewController
                            let viewController = storyBoard.instantiateInitialViewController() as! UIViewController
                            self.presentViewController(viewController, animated: true, completion: nil)
                        } else {
                            // TODO: tell user what error and why
                            print("register err: \(error)")
                        }
                    }
                } else {
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            self.presentViewController(alertController, animated: true, completion: nil)

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
