//
//  HomeBodyPageOneViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/24/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse

class HomeBodyPageOneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewActivities: UITableView!
    
    var myActivitiesList : NSArray?
    var refreshControl = UIRefreshControl()
    
    var institutionsArray : NSArray?
    var institutionsControl = 0


    var structResult = [ActiviesFromInstitution]()
    
    // struct used to guard the activities and institutions from query to display in view
    struct ActiviesFromInstitution {
        var institution : PFObject
        var activity : PFObject
    }
    
    var array = Array<Array<AnyObject>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "reloadDataToTableView", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableViewActivities.addSubview(refreshControl)
        self.tableViewActivities.dataSource = self
        self.tableViewActivities.delegate = self
        
        self.reloadDataToTableView()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.structResult.count == 0){
            return 1
        }
        
        return self.structResult.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        if (self.structResult.count == 0){
            let cell = tableViewActivities.dequeueReusableCellWithIdentifier("homeActivitiesContentCell") as! HomeBodyActivitiesTableViewCell
            return cell
        }else{
            let cell = tableViewActivities.dequeueReusableCellWithIdentifier("homeActivitiesContentCell") as! HomeBodyActivitiesTableViewCell
            
            let institution = self.structResult[indexPath.row].institution
            let activity = self.structResult[indexPath.row].activity
            
            cell.labelActivityName.text = activity.valueForKey(ParseNames.ACTIVITY_Name()) as? String
            cell.labelInstitutionName.text = institution.valueForKey(ParseNames.INSTITUTION_Name()) as? String
            
            if let activityDate = activity.valueForKey(ParseNames.ACTIVITY_DeliveryDate()) as? NSDate
            {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                var dateString = dateFormatter.stringFromDate(activityDate)
                cell.labelActivityDate.text = "Due to: \(dateString)"
            }
            
            return cell
        }
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
       if (self.structResult.count != 0)
       {
        
            let institutionStoryboard = UIStoryboard(name: "Institution", bundle: nil)
            let institutionVC : BGRGroupListViewController = institutionStoryboard.instantiateViewControllerWithIdentifier("activityScreen") as! BGRGroupListViewController
            let selectedInstitution: AnyObject? = self.structResult[indexPath.row].institution
            let selectedActivity: AnyObject? = self.structResult[indexPath.row].activity
        
            BGRActivity.saveCurrentActivity(selectedActivity!)
            BGRInstitution.saveCurrentInstitution(selectedInstitution!)
            self.navigationController?.pushViewController(institutionVC, animated: true)
        
        }
    }

    
    func reloadDataToTableView()
    {
        self.institutionsControl = 0
        self.structResult = []
        BGRInstitution.BGRFetchInstitutionsFromUser(BGRUser.sharedUser.loggedParseUser!, response: { (institutionsResult, error) -> () in
            
            if(institutionsResult != nil)
            {
                self.institutionsArray = institutionsResult!
                for ( var i = 0; i < institutionsResult!.count; i++)
                {

                    BGRActivity.BGRFetchActivitiesFromInstitutionAndReturnInstitution(institutionsResult!.objectAtIndex(i) as! PFObject, response: { (result, institution, error) -> () in
                        
                        self.institutionsControl++
                        var structComponent : ActiviesFromInstitution?
                        
                        if ( result!.count != 0)
                        {
                            for(var j = 0; j < result!.count; j++)
                            {
                                structComponent = ActiviesFromInstitution(institution: institution as PFObject, activity: result!.objectAtIndex(j) as! PFObject)
                                self.structResult.append(structComponent!)
                            }
                        }
                        
                        //end search for activities from institutions
                        if (self.institutionsArray!.count == self.institutionsControl)
                        {
                            self.refreshControl.endRefreshing()
                            self.tableViewActivities.reloadData()
                        }
                        
                    })
                    

                }
            }
            
        })

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
