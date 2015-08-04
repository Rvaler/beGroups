//
//  BGRGroupDetailViewController.swift
//  BeGroups
//
//  Created by Felipe S F Paula on 6/22/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit
import Parse

class BGRGroupDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var memberCollectionView: UICollectionView!
    @IBOutlet var joinInviteButton: UIButton!
    var memberList : [PFObject] = []
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var groupNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        memberCollectionView.dataSource = self
        memberCollectionView.delegate = self
        //Sself.view.backgroundColor = UIColor.clearColor()
    
        /*Textview config*/
        descriptionTextView.font = UIFont(name: "Avenir", size: 14)
        descriptionTextView.editable = false
        descriptionTextView.selectable = false
        descriptionTextView.scrollEnabled = false
        descriptionTextView.backgroundColor = UIColor.clearColor()
        
        /**/
        groupNameLabel.text = (BGRGroup.currentGroup.valueForKey(ParseNames.GROUP_Name()) as! String)
        groupNameLabel.font = UIFont(name: "Avenir", size: 25)
        /*Collection view*/
        joinInviteButton.layer.cornerRadius = 20
        backgroundImageView.image = UIImage(named: "Background")
        BGRGroup.BGRGetMembersFromGroup(BGRGroup.currentGroup, response: { (results, error) -> () in
            self.memberList = results
            self.memberCollectionView.reloadData()
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func joinInviteAction(sender: AnyObject) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memberCell", forIndexPath: indexPath) as! BGRMemberCollectionViewCell
        let member = memberList[indexPath.row]
        if let memberPicture: AnyObject = member.valueForKey("picture") {
            let memberPictureData = memberPicture as! PFFile
            let url = NSURL(string: memberPictureData.url!)
            let data = NSData(contentsOfURL: url!)
            cell.memberImageView.image = UIImage(data: data!)
        } else {
            //colocar photo default
        }
        
        if let memberName: AnyObject = member.valueForKey("firstName") {
            cell.labelName.text = (memberName as! String)
        } else {
            cell.labelName.text = ""
        }
        
        cell.memberImageView.layer.cornerRadius = 25
        cell.memberImageView.layer.masksToBounds = true
        
        
        return cell

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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
