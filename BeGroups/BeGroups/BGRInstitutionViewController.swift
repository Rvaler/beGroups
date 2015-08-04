//
//  BGRInstitutionViewController.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/23/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse

class BGRInstitutionViewController: UIViewController, UISearchBarDelegate , UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var activitiesTableView: UITableView!
    @IBOutlet weak var buttonCreateActivity: UIButton!
    
    var refreshControl = UIRefreshControl()
    var activitiesArray: NSArray?
    //var state = InstitutionState()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "reloadDataToTableView", forControlEvents: UIControlEvents.ValueChanged)
        
        self.activitiesTableView.addSubview(refreshControl)
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        
        self.reloadDataToTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func verifyAdminMember(headerCell: InstitutionHeaderTableViewCell)
    {
        if let currentInstitution = BGRInstitution.currentInstitution
        {
            if let currentUser = BGRUser.sharedUser.loggedParseUser
            {
                BGRInstitution.BGRVerifyInstitutionAdmin(currentUser, institution: currentInstitution) { (succeeded, error) -> () in
                    if(succeeded){
                        headerCell.buttonCreateActivity.enabled = true
                        headerCell.buttonCreateActivity.alpha = 1.0
                    }else{
                        headerCell.buttonCreateActivity.enabled = false
                        headerCell.buttonCreateActivity.alpha = 0.3
                    }
                }
            }
        }
        
    }
    
    //        BGRInstitution.BGRGetActivitiesOfInstitutioninBackGround(BGRInstitution.currentInstitution!, response: { (results, error) -> () in
    //            self.activitiesArray = results
    //            //self.state.currentList = self.activitiesArray
    //            //self.state.filteredList = self.activitiesArray
    //            //self.state.displayingList = self.activitiesArray
    //            self.activitiesTableView.reloadData()
    //       })
    
    func reloadDataToTableView()
    {
        BGRActivity.BGRFetchActivitiesFromInstitutionAndReturnInstitution(BGRInstitution.currentInstitution!, response: { (result, institution, error) -> () in
            self.activitiesArray = result
            self.refreshControl.endRefreshing()
            self.activitiesTableView.reloadData()
        })
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            //shows header cell
            let cell = activitiesTableView.dequeueReusableCellWithIdentifier("institutionHeaderCell") as! InstitutionHeaderTableViewCell
            
            self.verifyAdminMember(cell)
            cell.viewHeaderSeparator.backgroundColor = BGRColors.BGRDarkBlueColor
            let institution = BGRInstitution.currentInstitution
            cell.labelInstitutionName.text = institution?.valueForKey(ParseNames.INSTITUTION_Name()) as? String
            if (institution?.valueForKey(ParseNames.INSTITUTION_Privacy()) as? Bool == true)
            {
                cell.labelInstitutionPrivacy.text = "Private Institution"
            }else{
                cell.labelInstitutionPrivacy.text = "Open Institution"
            }
            
            let institutionImageHeader = institution?.valueForKey(ParseNames.INSTITUTION_Banner()) as? PFFile
            institutionImageHeader?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let institutionImage = UIImage(data: imageData!)
                    cell.imageViewInstitutionHeader.image = institutionImage
                }else{
                    //
                }
            })
            
            return cell
        }else{
            let cell = activitiesTableView.dequeueReusableCellWithIdentifier("activityCell") as! BGRInstitutionTableViewCell
            cell.labelActivityName.text = self.activitiesArray?.objectAtIndex(indexPath.row - 1).valueForKey(ParseNames.ACTIVITY_Name()) as? String
            cell.labelActivityDeliveryDate.textColor = BGRColors.BGROrangeColor
            cell.labelActivityDeliveryDate.textColor = BGRColors.BGRDarkBlueColor
            
            
            if let activityDate = self.activitiesArray?.objectAtIndex(indexPath.row - 1).valueForKey(ParseNames.ACTIVITY_DeliveryDate()) as? NSDate
            {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                var dateString = dateFormatter.stringFromDate(activityDate)
                cell.labelActivityDeliveryDate.text = "Due to: \(dateString)"
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 257
        }
        return 61
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.activitiesArray == nil)
        {
            return 1
        }else{
            // sum 1 cause we always will show the header cell
            return self.activitiesArray!.count + 1
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != 0)
        {
            BGRActivity.saveCurrentActivity(self.activitiesArray!.objectAtIndex(indexPath.row - 1))
            performSegueWithIdentifier("institutionToGroupListSegue", sender: nil)

        }
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        let filteredList = state.currentList.filter { (parseObject) -> Bool in
//            let tmp: NSString = parseObject.valueForKey(ParseNames.ACTIVITY_Name()) as! String
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        }
//        
//        state.displayingList = filteredList
//        activitiesTableView.reloadData()
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        state.displayingList = state.currentList
//        activitiesTableView.reloadData()
//    }
    

    @IBAction func membersButtonAction(sender: AnyObject) {
        performSegueWithIdentifier("institutionToMemberList", sender: nil)
    }
    
 
//    struct InstitutionState {
//        var currentList: [PFObject] = []
//        var filteredList: [PFObject] = []
//        var displayingList: [PFObject] = []
//    }
    
    
    //MARK - Buttons Methods
    @IBAction func actionMembersButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("institutionToMemberList", sender: self)
    }
    
    @IBAction func actionCreateActivityClicked(sender: AnyObject) {
        
    }
    
    @IBAction func actionJoinedButtonClicked(sender: AnyObject) {
        println("button clicked")
    }
    
    @IBAction func cancelActivityCreation(segue:UIStoryboardSegue) {
    }

}
