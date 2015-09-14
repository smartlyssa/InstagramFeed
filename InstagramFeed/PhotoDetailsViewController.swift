//
//  PhotoDetailsViewController.swift
//  InstagramFeed
//
//  Created by Lyssa on 9/13/15.
//  Copyright © 2015 thegeekgoddess.net. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var detailTableView: UITableView!
    var selectPhotoDetails: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NSLog("Photo Details: \(selectPhotoDetails)")
        NSLog("Attr Count: \(selectPhotoDetails.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//        cell.textLabel?.text = "\(indexPath.row)"

        cell.textLabel?.text = selectPhotoDetails["link"] as! String
        return cell
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
