//
//  Tab3ViewController.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/29/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class Tab3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let instutionStoryBoard = UIStoryboard(name: "Notifications", bundle: nil)
        let instVC: UIViewController = instutionStoryBoard.instantiateInitialViewController() as! UIViewController
        addChildViewController(instVC)
        view.addSubview(instVC.view)
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
