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

class PhotosViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var photos: NSArray?
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let photoDictionary = photos![indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! PhotoCell
//        cell.lowResImage.text = photoDictionary["link"] as! String
        
        cell.imageLink.text = photoDictionary["link"] as! String
        cell.photoView.setImageWithURL(photoDictionary["link"] as! NSURL)
        
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("TableView? \(tableView)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.dataSource = self
        tableView.rowHeight = 320

        
        let clientId = "f0ad5a0e24c244a3ab245709a700ecc8"
        
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        let request = NSURLRequest(URL: url)

        NSURLConnection.sendAsynchronousRequest(request,queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            
            dispatch_async(dispatch_get_main_queue()) {
                self.photos = responseDictionary["data"] as! NSArray
                
                
                
                self.tableView.reloadData()
            }
            
            NSLog("\(responseDictionary)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

class PhotoCell: UITableViewCell {
    @IBOutlet var imageLink: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    

    
}
