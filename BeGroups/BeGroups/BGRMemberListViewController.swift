//
//  BGRMemberListViewController.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/24/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class BGRMemberListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var memberListTableView: UITableView!
    var memberList = []
    override func viewDidLoad() {
        super.viewDidLoad()
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
        // Do any additional setup after loading the view.
        //BGRInstitution.currentInstitution
        self.navigationItem.title = "Members"
       BGRInstitution.BGRGetMembersOfInstitution(BGRInstitution.currentInstitution!, response: { (results, error) -> () in
         self.memberList = results!
         self.memberListTableView.reloadData()
       })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberListCell", forIndexPath: indexPath) as! BGRMemberListTableViewCell
        cell.memberLabel.text = (memberList.objectAtIndex(indexPath.row).valueForKey(ParseNames.USER_Username()) as! String)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
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
