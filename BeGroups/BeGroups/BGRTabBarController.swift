//
//  BGRTabBarController.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 7/13/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class BGRTabBarController: UITabBarController {

    @IBOutlet var theTab: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        self.view.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
