//
//  NBPRootViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 03/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit
import LGSideMenuController

class NBPRootViewController: LGSideMenuController {

    var leftMenuController = LeftMenuController()
    //    var rightMenuController = RightMenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.initialSetUp()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func initialSetUp(){
        
        let navCtrl = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        self.rootViewController = navCtrl
        
        self.setupLeftAndRightMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLeftAndRightMenu(){
        
        leftMenuController = self.storyboard!.instantiateViewControllerWithIdentifier("LeftMenuController") as! LeftMenuController
        
        self.setLeftViewEnabledWithWidth(250.0, presentationStyle:LGSideMenuPresentationStyle.SlideBelow, alwaysVisibleOptions:LGSideMenuAlwaysVisibleOptions.OnNone)
        self.leftViewStatusBarStyle = UIStatusBarStyle.Default
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions.OnAll
        
        self.leftViewBackgroundColor = UIColor.clearColor()
        leftMenuController.tableView.backgroundColor = UIColor.whiteColor()
        
        self.leftViewBackgroundColor = UIColor.whiteColor()

        leftMenuController.tableView.reloadData()
        self.leftView().addSubview(leftMenuController.tableView)

    }
    
    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.rightViewWillLayoutSubviewsWithSize(size)
        if (!UIApplication.sharedApplication().statusBarHidden){
            leftMenuController.tableView.frame = CGRectMake(0.0 , 20.0, size.width, size.height-20.0);        }
        else{
            leftMenuController.tableView.frame = CGRectMake(0.0 , 0.0, size.width, size.height);
        }
    }
    

}
