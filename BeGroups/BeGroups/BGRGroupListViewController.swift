//
//  BGRGroupListViewController.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/24/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse

class BGRGroupListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var groupTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    var groupList : [PFObject] = []
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        backgroundImageView.image = UIImage(named: "Background-white")
        self.navigationItem.title = "Groups"


        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        BGRActivity.BGRGroupsFromActivity(BGRActivity.currentActivity!, response: { (result, error) -> () in
            self.groupList = result
            self.groupTableView.reloadData()
        })
    }
    
    @IBAction func addNewGroupAction(sender: AnyObject) {
        let groupDetailStoryboard = UIStoryboard(name: "NewGroup", bundle: nil)
        let groupDetailVC = groupDetailStoryboard.instantiateViewControllerWithIdentifier("newGroupVC") as! UIViewController
        self.navigationController?.pushViewController(groupDetailVC, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupListCell", forIndexPath: indexPath) as! BGRGroupListTableViewCell
        let groupCell = groupList[indexPath.row]
        
        cell.groupNameLabel.text = groupCell.valueForKey(ParseNames.GROUP_Name()) as? String
        println("printando apontador da at\(groupCell[ParseNames.GROUP_Activitiy()])")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let groupDetailStoryboard = UIStoryboard(name: "GroupDetail", bundle: nil)
        let groupDetailVC : BGRGroupDetailViewController = groupDetailStoryboard.instantiateInitialViewController() as! BGRGroupDetailViewController
        
        BGRGroup.currentGroup = groupList[indexPath.row]
        self.navigationController?.pushViewController(groupDetailVC, animated: true)
    
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
