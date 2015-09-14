//
//  PhotosViewController.swift
//  InstagramFeed
//
//  Created by Lyssa Laudencia on 9/10/15.
//  Copyright © 2015 thegeekgoddess.net. All rights reserved.
//

import UIKit
import AFNetworking

private let CELL_NAME = "net.thegeekgoddess.photofeed.photocell"

class PhotosViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var photos: NSArray?
    var refreshControl:UIRefreshControl!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        NSLog("Photo Count: \(photos?.count)")
        return photos?.count ?? 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! PhotoCell
        let photoDictionary = photos![indexPath.row] as! NSDictionary
        let photoImageDict = photoDictionary["images"] as! NSDictionary
        let photoLowRes = photoImageDict["low_resolution"] as! NSDictionary
        let photoLowResURL = photoLowRes["url"] as! NSString
        
        cell.imageLink.text = photoDictionary["link"] as? String
        cell.photoView.setImageWithURL(NSURL(string: photoLowResURL as String)!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("TableView? \(tableView)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // copy paste credit: http://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 320
        
        refresh(self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        vc.selectPhotoDetails = photos![(indexPath?.row)!] as? NSDictionary
    }
    
    func refresh(sender:AnyObject) {

        let clientId = "f0ad5a0e24c244a3ab245709a700ecc8"
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        
        //        let request = NSURLRequest(URL: url)
        //        NSURLConnection.sendAsynchronousRequest(request,queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
        //            let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        //
        //            dispatch_async(dispatch_get_main_queue()) {
        //                self.photos = responseDictionary["data"] as? NSDictionary
        //                NSLog("Count \(responseDictionary.count)")
        //                self.tableView.reloadData()
        //            }
        //
        //            NSLog("\(responseDictionary)")
        //        }
        
        let request = NSMutableURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , response, error ) -> Void in
            if let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                dispatch_async(dispatch_get_main_queue()) {
                    self.photos = dictionary["data"] as? NSArray
                    self.tableView.reloadData()
                }
                NSLog("\(dictionary)")
            } else {
                
            }
        }
        task.resume()
        
        self.refreshControl.endRefreshing()

    }

}

class PhotoCell: UITableViewCell {
    @IBOutlet var imageLink: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
}
