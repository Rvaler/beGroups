//
//  HomeBodyViewController.swift
//  BeGroups
//
//  Created by Rafael Valer on 6/24/15.
//  Copyright (c) 2015 StarGRO. All rights reserved.
//

import UIKit

class HomeBodyViewController: UIViewController, UIPageViewControllerDataSource, UIScrollViewDelegate , UIPageViewControllerDelegate{
   
    let viewTopTitleLine = UIView()
    let viewBotTitleLine = UIView()
    let viewSelectedLine = UIView()
    
    var pageViewController : UIPageViewController!
    var currentPageIndex: Int!
    
    var animationCurrentIndex : Int!

    @IBOutlet weak var labelActivitiesTitle: UILabel!
    @IBOutlet weak var labelInstitutionsTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.view.frame.width)
        self.createLines()
        self.currentPageIndex = 0
        self.animationCurrentIndex = 0
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        var startVC = self.viewControllerAtIndex(0) as! HomeBodyPageOneViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        for sview in pageViewController!.view.subviews
        {
            if (sview.isKindOfClass(UIScrollView))
            {
                let scrollV : UIScrollView = sview as! UIScrollView
                scrollV.delegate = self
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func createLines() {
        
        self.viewTopTitleLine.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4)
        self.viewTopTitleLine.backgroundColor = BGRColors.BGRDarkBlueColor
        self.view.addSubview(viewTopTitleLine)
        
        self.viewBotTitleLine.frame = CGRect(x: 0, y: 34, width: self.view.frame.width, height: 0.4)
        self.viewBotTitleLine.backgroundColor = BGRColors.BGRDarkBlueColor
        self.view.addSubview(viewBotTitleLine)
        
        self.viewSelectedLine.frame = CGRect(x: 0 , y: 32, width: self.view.frame.width / 2, height: 2)
        self.viewSelectedLine.backgroundColor = BGRColors.BGROrangeColor
        self.view.addSubview(viewSelectedLine)
        
        self.labelActivitiesTitle.textColor = BGRColors.BGROrangeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Mark: - PageView Methods
    
    func viewControllerAtIndex(index: Int) -> UIViewController
    {
   
        if (index == 0){
            
            var vc: HomeBodyPageOneViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeBodyPageOneViewController") as! HomeBodyPageOneViewController
 
            return vc
            
        }else {
            
            var vc: HomeBodyInstitutionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeBodyInstitutionsViewController") as! HomeBodyInstitutionsViewController
            
            return vc
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(self.animationCurrentIndex == 0)
        {
            self.animateLineToRight(scrollView.contentOffset.x - self.view.frame.width)
            if(scrollView.contentOffset.x == (2 * self.view.frame.width))
            {
                self.labelInstitutionsTitle.textColor = BGRColors.BGROrangeColor
                self.labelActivitiesTitle.textColor = BGRColors.BGRDarkBlueColor
                self.animationCurrentIndex = 1
            }
            
            
        }
        
        else if (self.animationCurrentIndex == 1)
        {

            self.animateLineToLeft(scrollView.contentOffset.x / 2)
            if(scrollView.contentOffset.x == 0)
            {
                self.animationCurrentIndex = 0
                self.labelInstitutionsTitle.textColor = BGRColors.BGRDarkBlueColor
                self.labelActivitiesTitle.textColor = BGRColors.BGROrangeColor
            }
            
        }
        
    }
    
    func animateLineToRight(offset: CGFloat)
    {
        let newPosition = offset / 2
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.viewSelectedLine.frame.origin.x = newPosition
            }) { (finished) -> Void in
                //
        }
    }
    
    func animateLineToLeft(offset: CGFloat)
    {
        let newPosition = offset
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.viewSelectedLine.frame.origin.x = newPosition
            }) { (finished) -> Void in
                //
        }
    }
    
    // MARK: - Page View Controller DataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        currentPageIndex = currentPageIndex - 1
        if (currentPageIndex <= 0 || currentPageIndex == NSNotFound){
            currentPageIndex = currentPageIndex + 1
            return nil
        }
        
        return self.viewControllerAtIndex(currentPageIndex)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        currentPageIndex = currentPageIndex + 1
        if (currentPageIndex > 1 || currentPageIndex == NSNotFound){
            currentPageIndex = currentPageIndex - 1
            return nil
        }
        
        return self.viewControllerAtIndex(currentPageIndex)
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
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
