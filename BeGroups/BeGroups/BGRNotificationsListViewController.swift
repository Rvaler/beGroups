//
//  BGRNotificationsListViewController.swift
//
//
//  Created by Anderson Rogério da Silva Gralha on 6/27/15.
//
//

import UIKit
import Parse

class BGRNotificationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notifications = [PFObject]()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var BGRNotificationsListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.BGRNotificationsListTableView.addSubview(refreshControl)
        
        
        
        
        BGRNotificationsListTableView.delegate = self
        BGRNotificationsListTableView.dataSource = self
        
        
        //        self.tableView.backgroundView?.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        //        BGRUser.loginWithUsername("Anderson", password: "123456") { (succeeded, error) -> () in
        //
        //        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func refresh(sender:AnyObject)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.notifications = BGRUser.BGRGetUsersNotifications() as! [(PFObject)]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.BGRNotificationsListTableView.reloadData()
                self.refreshControl.endRefreshing()
            })
            
        })
        
        //        var query = PFQuery(className: ParseNames.GROUP())
        //        query.whereKey(ParseNames.OBJECTID(), equalTo: "puASwMHJaN")
        //
        //        var obj = query.getFirstObject()
        //
        //
        //        BGRGroup.BGRInviteUser(PFUser.currentUser()!, toGroup: obj!, response: { (succeeded, error) -> () in
        //
        //
        //        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.notifications = BGRUser.BGRGetUsersNotifications() as! [(PFObject)]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.BGRNotificationsListTableView.reloadData()
            })
            
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if [self.notifications] == nil {
            return 0
        } else {
            return self.notifications.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Notification", forIndexPath: indexPath) as! BGRNotificationTableViewCell
        
        cell.BGRNotificationDescriptionLabel.text = notifications[indexPath.row]["description"] as? String
        
        if notifications[indexPath.row]["read"] as! Bool == false {
            cell.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //println("shit works")
        
        if (self.notifications[indexPath.row]["type"] as! String == ParseNames.NOTIFICATION_InviteUserToGroup()) {
            
            var group = (self.notifications[indexPath.row]["fromGroup"] as! PFObject)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                group.fetch()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var name: String = group["name"] as! String
                    let actionSheetController: UIAlertController = UIAlertController(title: "Join Group", message: "Do you want to join the group \(name)?", preferredStyle: .Alert)
                    
                    let joinAction: UIAlertAction = UIAlertAction(title: "Join", style: .Default) { action -> Void in
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                            
                            BGRGroup.BGRAcceptInvitationFromGroup(self.notifications[indexPath.row], group: self.notifications[indexPath.row]["fromGroup"] as! PFObject) { (succeeded, error) -> () in
                                
                                println(succeeded)
                                println(error)
                                
                                if succeeded == true {
                                    
                                    self.notifications[indexPath.row]["read"] = true
                                    
                                    (self.notifications[indexPath.row] as PFObject).save()
                                    
                                    self.notifications = BGRUser.BGRGetUsersNotifications() as! [(PFObject)]
                                    
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.BGRNotificationsListTableView.reloadData()
                                    })
                                    
                                }
                            }
                        })
                    }
                    actionSheetController.addAction(joinAction)
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel ) { action -> Void in
                        
                    }
                    actionSheetController.addAction(cancelAction)
                    
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
                })
            })
        }
        else if (self.notifications[indexPath.row]["type"] as! String == ParseNames.NOTIFICATION_AskToJoinGroup()){
            //
            //                BGRGroup.BGRAcceptUserInGroup(self.notifications[sender.tag], group: self.notifications[sender.tag]["toGroup"] as! PFObject) { (succeeded, error) -> () in
            //
            //                    println(succeeded)
            //                    println(error)
            //
            //                    if succeeded == true {
            //                        self.notifications = BGRUser.BGRGetUsersNotifications() as! [(PFObject)]
            //
            //                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //
            //                            self.tableView.reloadData()
            //
            //
            //                        })
            //
            //                    }
            //                }
        }
        else if (self.notifications[indexPath.row]["type"] as! String == ParseNames.NOTIFICATION_ActivityCreated()){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.notifications[indexPath.row]["read"] = true
                
                (self.notifications[indexPath.row] as PFObject).save()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    var string: String = (self.notifications[indexPath.row]["description"] as? String)!
                    
                    let actionSheetController: UIAlertController = UIAlertController(title: "New Activity", message: string, preferredStyle: .Alert)
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .Cancel ) { action -> Void in
                        
                    }
                    actionSheetController.addAction(cancelAction)
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
                    
                    self.BGRNotificationsListTableView.reloadData()
                })
            })
        }
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
