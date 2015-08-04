//
//  CreateActivityTableViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 7/16/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class CreateActivityTableViewController: UITableViewController {
    
    @IBOutlet var tableViewActivityCreation: UITableView!
    @IBOutlet weak var textFieldActivityName: UITextField!
    @IBOutlet weak var textFieldActivityDeliveryDate: UITextField!
    @IBOutlet weak var buttonCreateActivity: UIButton!
    
    var datePicker : UIDatePicker = UIDatePicker()
    var datePickerContainer = UIView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldActivityName.becomeFirstResponder()
        self.tableViewActivityCreation.delegate = self
        self.tableViewActivityCreation.dataSource = self
        self.buttonCreateActivity.layer.cornerRadius = 25
        
        self.textFieldActivityDeliveryDate.textColor = BGRColors.BGRDarkBlueColor
        self.textFieldActivityDeliveryDate.tintColor = BGRColors.BGRDarkBlueColor
        self.textFieldActivityName.textColor = BGRColors.BGRDarkBlueColor
        self.textFieldActivityName.tintColor = BGRColors.BGRDarkBlueColor
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionCreateActivityButtonClicked(sender: AnyObject) {
        
       if (self.textFieldActivityName.text != "" && self.textFieldActivityDeliveryDate.text != "")
       {

            BGRActivity.BGRCreateActivityWithName(self.textFieldActivityName.text, inInstitution: BGRInstitution.currentInstitution!, dueTo: self.datePicker.date, response: { (succeeded, error) -> () in
                if (succeeded) {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        //
                    })
                }else{
                    //TODO: tell user he couldnt create activity
                }
            })
        }
    }
    
    @IBAction func actionActivityDateClicked(sender: UITextField) {
        
        datePicker = UIDatePicker()
        datePickerContainer = UIView()
        
        datePickerContainer.frame = CGRectMake(0.0, 150, self.view.frame.width, 300)
        datePickerContainer.backgroundColor = UIColor.whiteColor()
        
        var pickerSize : CGSize = datePicker.sizeThatFits(CGSizeZero)
        datePicker.frame = CGRectMake(0.0, 20, pickerSize.width, 460)
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.setDate(NSDate(), animated: true)
        datePicker.minimumDate = NSDate()
        datePicker.tintColor = BGRColors.BGRDarkBlueColor
        datePickerContainer.addSubview(datePicker)
        
        var doneButton = UIButton()
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(BGRColors.BGRDarkBlueColor, forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "dismissPicker", forControlEvents: UIControlEvents.TouchDown)
        doneButton.frame = CGRectMake(250, 0, 70, 37)
        
        datePickerContainer.addSubview(doneButton)
        self.view.addSubview(datePickerContainer)
        
    }
    
    func dismissPicker()
    {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(self.datePicker.date)
        
        self.textFieldActivityDeliveryDate.text = dateString
        self.textFieldActivityDeliveryDate.resignFirstResponder()
        datePickerContainer.removeFromSuperview()
    }

    
    // MARK: - Table view data source
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
