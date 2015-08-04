//
//  SearchInstitutionsViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/17/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse


class SearchInstitutionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var institutionsTableView: UITableView!
    @IBOutlet weak var barButtonCreateInstitution: UIBarButtonItem!
    
    
    var searchBarInstitutions:UISearchBar?
    var searchActive : Bool = false
    
    //var searchBarInstitutions = UISearchBar()
    var institutionsList : NSArray?
    
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBarInstitutions = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 65, height: 20))
        
        institutionsTableView.dataSource = self
        institutionsTableView.delegate = self
        searchBarInstitutions!.delegate = self
        
        
        searchBarInstitutions!.backgroundImage = UIImage.new()
        searchBarInstitutions!.scopeBarBackgroundImage = UIImage.new()
       
        self.searchBarInstitutions!.placeholder = "Search Institutions"
        let rightNavBarButtom = UIBarButtonItem(customView: self.searchBarInstitutions!)
        self.navigationItem.rightBarButtonItem = rightNavBarButtom
        
        searchBarInstitutions!.backgroundImage = UIImage.new()
        searchBarInstitutions!.scopeBarBackgroundImage = UIImage.new()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.actionSearchInstitutions([])
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.searchBarInstitutions!.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.searchBarInstitutions!.hidden = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        /* empty list, show alternative cell */
        if (institutionsList == nil){
            return 1
        }
    
        return self.institutionsList!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if let institutionSearchList = self.institutionsList
        {
            let institutionCell = institutionsTableView.dequeueReusableCellWithIdentifier("searchInstitutionsCell") as! SearchInstitutionsTableViewCell
            institutionCell.labelInstitutionName.text = institutionsList?.objectAtIndex(indexPath.row).valueForKey(ParseNames.INSTITUTION_Name()) as? String
            
            
            let institution: PFObject = institutionsList!.objectAtIndex(indexPath.row) as! PFObject
            if (institution.valueForKey(ParseNames.INSTITUTION_Privacy()) as! Bool == true)
            {
                institutionCell.labelInstitutionPrivacy.text = "Private Institution"
                institutionCell.imageCellLocker.hidden = false
            }else{
                institutionCell.labelInstitutionPrivacy.text = "Open Institution"
            }
            
            institutionCell.imageInstitutionLogo.image = UIImage(named: "Hexagon")
            let institutionImageLogo = institution[ParseNames.INSTITUTION_Image()] as? PFFile
            institutionImageLogo?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if let institutionImage = imageData
                {
                    let cellImage = UIImage(data: institutionImage)
                    institutionCell.imageInstitutionLogo.image = cellImage
                }
    
            })
            
            return institutionCell
            
        }else{
            
            // aqui cell vazia
            let institutionCell = institutionsTableView.dequeueReusableCellWithIdentifier("searchInstitutionsCell") as! SearchInstitutionsTableViewCell
            
            return institutionCell
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var alertController:UIAlertController?
        
        BGRInstitution.BGRVerifyInstitutionMember(PFUser.currentUser()!, institution: institutionsList?.objectAtIndex(indexPath.row) as! PFObject) { (succeeded, error) -> () in
            
            // if user is already a member of institution it will enter immediately
            if(succeeded){
                self.enterInInstitution(self.institutionsList?.objectAtIndex(indexPath.row) as! PFObject)
            } else {
                
                
                let enteringInstitution = self.institutionsList?.objectAtIndex(indexPath.row) as! PFObject
                let enteringInstitutionPassword = enteringInstitution[ParseNames.INSTITUTION_Password()] as? NSString
                let enteringInstitutionPrivacy = enteringInstitution[ParseNames.INSTITUTION_Privacy()] as! Bool
                
                if(enteringInstitutionPrivacy == false){
                    BGRInstitution.BGRVerifyRequestToInstitution(enteringInstitution, requestingUser: BGRUser.sharedUser.loggedParseUser!, password: "", response: { (succeeded, error) -> () in
                        if (succeeded){
                            self.enterInInstitution(enteringInstitution)
                        }
                    })
                }else{
                    alertController = UIAlertController(title: self.institutionsList?.objectAtIndex(indexPath.row).valueForKey(ParseNames.INSTITUTION_Name()) as? String, message: "New member request", preferredStyle: .Alert)
                    alertController!.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
                        textField.placeholder = "Enter password here"
                    }
                    
                    let confirmAction = UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default) { (action) -> Void in
                        if let textFields = alertController?.textFields{
                            let theTextFields = textFields as! [UITextField]
                            let enteredText = theTextFields[0].text
                            
                            if (enteringInstitutionPassword == enteredText)
                            {
                                BGRInstitution.BGRVerifyRequestToInstitution(enteringInstitution, requestingUser: BGRUser.sharedUser.loggedParseUser!, password: "", response: { (succeeded, error) -> () in
                                    if (succeeded){
                                        self.enterInInstitution(enteringInstitution)
                                    }
                                })
                            }
                            
                        }
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) -> Void in
                        print("cancelando")
                    }
                    
                    alertController?.addAction(confirmAction)
                    alertController?.addAction(cancelAction)
                    self.presentViewController(alertController!, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @IBAction func actionSearchInstitutions(sender: AnyObject) {
        
        var resultSearch : NSArray?
        // search for institutions by name and put it on institutionsList
        BGRInstitution.BGRSearchInstitutionByName(searchBarInstitutions!.text, response: { (resultSearch, error) -> () in
            self.institutionsList = resultSearch
            self.institutionsTableView.reloadData()
        })

    }
    
    func enterInInstitution(institution: PFObject)
    {
        let institutionStoryboard = UIStoryboard(name: "Institution", bundle: nil)
        let institutionVC : BGRInstitutionViewController = institutionStoryboard.instantiateViewControllerWithIdentifier("InstitutionScreen") as! BGRInstitutionViewController
        let carryobjc: PFObject = institution
        
        BGRInstitution.currentInstitution = carryobjc as PFObject?
        self.navigationController?.pushViewController(institutionVC, animated: true)
    }
    
    // MARK: - SEARCH METHODS
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        BGRInstitution.BGRSearchInstitutionByName(searchBarInstitutions!.text, response: { (resultSearch, error) -> () in
            self.institutionsList = resultSearch
            self.institutionsTableView.reloadData()
        })
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBarInstitutions!.showsCancelButton = true
    }
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBarInstitutions?.text = ""
        self.searchBarInstitutions?.setShowsCancelButton(false, animated: true)
        self.searchBarInstitutions?.resignFirstResponder()
        self.actionSearchInstitutions([])
    }
    

    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func cancelInstitutionCreation(segue:UIStoryboardSegue) {
    }
    
    

}
