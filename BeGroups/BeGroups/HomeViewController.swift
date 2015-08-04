//
//  HomeViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/24/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    
    var currentPageIndex : NSInteger?
    var pageController : UIPageViewController?
    @IBOutlet weak var imageUser: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        self.loadCurrentMemberImage()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCurrentMemberImage(){
        self.imageUser.image = UIImage(named: "defaultPerfilImage")
        
        if let currentUserImage:AnyObject = BGRUser.sharedUser.loggedParseUser?.valueForKey(ParseNames.USER_Picture())
        {
            currentUserImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error == nil
                {
                    self.imageUser.image = UIImage(data: imageData!)
                    self.imageUser.layer.cornerRadius = self.imageUser.frame.size.width / 2
                    self.imageUser.clipsToBounds = true
                }else{
                    self.imageUser.image = UIImage(named: "defaultPerfilImage")
                }
            })
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
