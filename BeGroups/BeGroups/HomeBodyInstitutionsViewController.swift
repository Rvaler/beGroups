//
//  HomeBodyInstitutionsViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 7/7/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class HomeBodyInstitutionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewInstitutions: UITableView!
    
    var myInstitutionsList : NSArray?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "reloadDataToTableView", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableViewInstitutions.addSubview(refreshControl)
        self.tableViewInstitutions.dataSource = self
        self.tableViewInstitutions.delegate = self
        
        self.reloadDataToTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadDataToTableView()
    {
        BGRInstitution.BGRFetchInstitutionsFromUser(BGRUser.sharedUser.loggedParseUser!, response: { (institutionsResult, error) -> () in

            self.myInstitutionsList = institutionsResult
            self.refreshControl.endRefreshing()
            self.tableViewInstitutions.reloadData()
        })
    }

    
    // MARK: - TalbeView Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.myInstitutionsList == nil){
            return 1
        }
        
        return self.myInstitutionsList!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let institution: AnyObject = myInstitutionsList?.objectAtIndex(indexPath.row)
        {
            
            let cell = tableViewInstitutions.dequeueReusableCellWithIdentifier("homeInstitutionsContentCell") as! HomeBodyInstitutionsTableViewCell
            cell.labelInstitutionName.text = institution.valueForKey(ParseNames.INSTITUTION_Name()) as? String
            let institutionName = institution.valueForKey(ParseNames.INSTITUTION_Name()) as! String
            let institutionNameUpperCaseString = institutionName.uppercaseString
            let character = String(institutionNameUpperCaseString[advance(institutionNameUpperCaseString.startIndex, 0)])
            cell.labelFirstLetterInstitution.text = character
            
            if(institution.valueForKey(ParseNames.INSTITUTION_Privacy()) as? Bool == true){
                cell.labelInstitutionPrivacy.text = "Private Institution"
                cell.imageViewLocker.hidden = false
            }else{
                cell.labelInstitutionPrivacy.text = "Open Institution"
                cell.imageViewLocker.hidden = true
            }
            return cell
        
        }else{
            
            // TODO: represent an empty cell
            let cell = tableViewInstitutions.dequeueReusableCellWithIdentifier("homeInstitutionsContentCell") as! HomeBodyInstitutionsTableViewCell
            return cell
            
        }

    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectedInstitution: AnyObject = self.myInstitutionsList?.objectAtIndex(indexPath.row)
        {
            let institutionStoryboard = UIStoryboard(name: "Institution", bundle: nil)
            let institutionVC : BGRInstitutionViewController = institutionStoryboard.instantiateViewControllerWithIdentifier("InstitutionScreen") as! BGRInstitutionViewController
            
            BGRInstitution.saveCurrentInstitution(selectedInstitution)
            self.navigationController?.pushViewController(institutionVC, animated: true)
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
