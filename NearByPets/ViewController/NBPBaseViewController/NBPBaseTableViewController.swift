//
//  NBPBaseTableViewController.swift
//  NearByPets
//
//  Created by Suyog Kolhe on 22/06/16.
//  Copyright © 2016 Suyog Kolhe. All rights reserved.
//

import UIKit

class NBPBaseTableViewController: UITableViewController {

    var productDetail = NBPProductDetailInfo()
    
//    var categories : [NBPCategoryInfo]?    
    var products : Array <NBPProductDetail>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : NBPMyPostedAdCell = tableView.dequeueReusableCellWithIdentifier("NBPMyPostedAdCell", forIndexPath: indexPath) as! NBPMyPostedAdCell
        cell.title?.text = "Product Title \(indexPath.row+indexPath.section)"
        if  indexPath.row == 4 {
            return tableView.dequeueReusableCellWithIdentifier("FacebookAd", forIndexPath: indexPath) as! NBPFacebookAdCell

        }

        return cell
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }



    override func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.init(rgb: 0x03a021)
        }


    }

    override func tableView(tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        let date = 10 + section


        let cell : NBPSectionHeaderCell =  (tableView.dequeueReusableCellWithIdentifier("SectionHeader") as? NBPSectionHeaderCell)!
        cell.title?.text = "Posted On \(date)/05/2016"

        return cell

    }

    override func tableView(tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        self.navigationItem.backBarButtonItem?.title = " "
        self.performSegueWithIdentifier("ProductDashboardToProductDetailSegue", sender: self)
        
    }
    
    @IBAction func openLeftMenu(sender:UIBarButtonItem ) {
        
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.rootViewController().showLeftViewAnimated(true, completionHandler: nil)
        
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
