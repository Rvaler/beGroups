//
//  LoginViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/23/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController{

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonFacebookLogin: UIButton!
    
    var permissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSignIn.layer.cornerRadius = 25
        buttonFacebookLogin.layer.cornerRadius = 25
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func facebookButtonTapped(sender: UIButton) {
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if let loggedUser = user{
            
                if loggedUser.isNew{
                //hue
                    println("Logou")
                    self.saveUserData(user!)
                    BGRUser.sharedUser.initWithParseUser(user!)
                    
                }else{
                
                    println("Usuario ja logado")
                    self.saveUserData(user!)
                    BGRUser.sharedUser.initWithParseUser(user!)

                }

            
            }else{
            
                println("Erro")
                return Void()
            }
        }
        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController() as! UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    @IBAction func actionSignIn(sender: AnyObject) {
        
        BGRUser.loginWithUsername(textFieldUsername.text, password: textFieldPassword.text) { (succeeded, error) -> () in
            
            if (succeeded){
                // segue to main view of app
                let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                let viewController = storyBoard.instantiateInitialViewController() as! UIViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                // TODO: tell user what error and why
                print("login err: \(error)")
            }
        }
    }
    
    func returnUserData(user: PFUser)
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println(userName)
            }
        })
        
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                println("\(result)")
            } else {
                println("\(result)")

                println("\(error)")
            }
        })
    }
    
    func saveUserData(user: PFUser) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                /*TODO ACHAR MANEIRA MELHOR MANEIRA PRA FAZER ISSO*/
                println("fetched user: \(result)")
                let user : PFUser = PFUser.currentUser()!
                let userName : NSString = result.valueForKey("name") as! NSString
                let userEmail : NSString = result.valueForKey("email") as! NSString
                let firstName : NSString = result.valueForKey("first_name") as! NSString
                let lastName : NSString = result.valueForKey("last_name") as! NSString
                user["firstName"] = firstName
                user["lastName"] = lastName
                //println(user)
                let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
                pictureRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    let pictureUrl: String = result.valueForKey("data")!.valueForKey("url")! as! String
                    println(pictureUrl)
                    let dataFromUrl = NSData(contentsOfURL: NSURL(string: pictureUrl)!)
                    let imageFromData = UIImage(data: dataFromUrl!)
                    let imagePng = UIImagePNGRepresentation(imageFromData)
                    let imageFile = PFFile(data: imagePng)
                    let user : PFUser = PFUser.currentUser()!
                    user.setValue(imageFile, forKey: "picture")
                    imageFile.saveInBackground()
                    user.saveInBackground()
                })
                
            }
        })

    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func cancelSignUpUser(segue:UIStoryboardSegue) {
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