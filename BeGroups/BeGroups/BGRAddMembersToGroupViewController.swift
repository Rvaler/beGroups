//
//  BGRAddMembersToGroupViewController.swift
//
//
//  Created by Anderson Rogério da Silva Gralha on 6/24/15.
//
//

import UIKit
import Parse

class BGRAddMembersToGroupViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var users : [PFUser] = []
    var filteredUsers: [PFUser] = []
    var selectedUsers = [PFUser]()
    var searchActive : Bool = false
    
    var refreshControl = UIRefreshControl()
    
//    @IBOutlet weak var BGRAddMembersSearchBar: UISearchBar!
    @IBOutlet weak var BGRAddMembersToGroupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.BGRAddMembersToGroupTableView.addSubview(self.refreshControl)
        
        self.BGRAddMembersToGroupTableView.dataSource = self
        self.BGRAddMembersToGroupTableView.delegate = self
        
        
//        self.BGRAddMembersSearchBar.delegate = self
        
    }
    
    func refresh(sender:AnyObject)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            self.users = BGRUser.BGRGetInstitutionsMembers(BGRInstitution.currentInstitution!.objectId!) as! [PFUser]
//            self.users = BGRUser.BGRGetInstitutionsMembers("FTktCZun9s") as! [PFUser]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // Reload the table
                self.BGRAddMembersToGroupTableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            self.users = BGRUser.BGRGetInstitutionsMembers(BGRInstitution.currentInstitution!.objectId!) as! [PFUser]
//            self.users = BGRUser.BGRGetInstitutionsMembers("FTktCZun9s") as! [PFUser]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // Reload the table
                self.BGRAddMembersToGroupTableView.reloadData()
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
        
        if self.users.count == 0 {
            return 0
        } else {
            if(searchActive) {
                return filteredUsers.count
            }
            return self.users.count
        }
        
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        cell = tableView.dequeueReusableCellWithIdentifier("UsersCell") as! BGRUsersListTableViewCell
        var obj : PFUser!
        
        if (searchActive)
        {
            
            obj = filteredUsers[indexPath.row] //as! PFUser
            if obj.objectId == PFUser.currentUser()?.objectId {
                return cell
            }
            cell.textLabel?.text = obj["username"] as? String
            cell.textLabel?.textColor = UIColor.lightGrayColor()
        }
        else
        {
            
            obj = users[indexPath.row]// as! PFUser
            if obj.objectId == PFUser.currentUser()?.objectId {
                return cell
            }
            cell.textLabel?.text = obj["username"] as? String
            cell.textLabel?.textColor = UIColor.lightGrayColor()
        }
        return cell
    }
    
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var obj : PFUser!
        
        obj = users[indexPath.row] //as! PFUser
        
        if obj.objectId == PFUser.currentUser()?.objectId {
            
            
            
            return 0
        }
        return 60
    }
    
    
    @IBAction func BGRAddMembersButton(sender: AnyObject) {
        
        
        
        if (BGRAddMembersToGroupTableView.indexPathForSelectedRow() != nil) {
            let selectedRows : NSArray? = self.BGRAddMembersToGroupTableView.indexPathsForSelectedRows()!.map{$0.row}
            println(selectedRows)
            
            if let selectedRows = selectedRows {
                for selectedUser in selectedRows {
                    
                    selectedUsers.append(users[selectedUser as! Int])// as! PFUser)
                
                }
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ReturnAllSelectedUsers" {
            
            
        }
        
    }
    
    
    // ===== Search Bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        self.filteredUsers = self.users.filter({ (user) -> Bool in
//            let tmp: NSString = user.username!
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
        
        self.filteredUsers = self.users.filter() { $0.username! == searchText }
        
        
        if(filteredUsers.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.BGRAddMembersToGroupTableView.reloadData()
    }
    
    
    
    
    
    
    
    
    //    ================
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
