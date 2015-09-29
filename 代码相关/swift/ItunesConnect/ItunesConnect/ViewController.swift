//
//  SearchResultsViewController.swift
//  ItunesConnect
//
//  Created by lin on 14-7-7.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
import QuartzCore

class SearchResultsViewController: UIViewController,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate,APIControllerProtocol{

    var appsTableView:UITableView = UITableView()
    var albums:Album[] = []
    var imageCache = NSMutableDictionary()
    
    @lazy var api:APIController = APIController(aDelegate:self)
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appsTableView.frame = self.view.frame
        appsTableView.dataSource = self;
        appsTableView.delegate = self;
        
        self.view.addSubview(appsTableView)
        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Bob Dylan")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier = "SearchResultCell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? UITableViewCell
        if(cell == nil){
            cell =  UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
    
        
        let album = self.albums[indexPath.row]
        cell!.text = album.title
        
        var urlString = album.thumbnailImageURL
        var imageURL:NSURL = NSURL(string: urlString);
        
        //Download an NSData representation of the 
        cell!.image = UIImage(named: "default.png")
        var imageRequest = NSURLRequest(URL: imageURL)
        var imageData:NSData? = self.imageCache.objectForKey(urlString) as? NSData
        if(!imageData){
            NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.currentQueue(), completionHandler: {
                aResponce, aData, error in
                if(error){}
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        if let albumArtsCell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath){
                            cell!.image = UIImage(data: aData)
                        }
                        self.imageCache.setObject(aData, forKey: urlString)
                        })
                }
                })
        }else{
            cell!.image = UIImage(data: imageData)
        }

        cell!.detailTextLabel.text = album.price
        
        return cell;
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            } )
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let album = self.albums[indexPath.row]
//        var name = album.title
//        var formattedPrice = album.price
//        
//        var alert:UIAlertView = UIAlertView()
//        alert.title = name
//        alert.message = formattedPrice
//        alert.addButtonWithTitle("OK")
//        alert.show()
        
        var vDetailVC = DetailsViewController()
        vDetailVC.album = album
        self.navigationController.showViewController(vDetailVC, sender: self)
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        if results.count > 0{
            let allResuts:NSDictionary[] = results["results"] as NSDictionary[]
            for result:NSDictionary in allResuts{
                var name:String? = result["trackName"] as? String
                if !name?{
                    name = result["collectionName"] as? String
                }
                
                
                var price:String? = result["formattedPrice"] as? String
                if(!price?){
                    price = result["collectionPrice"] as? String
                    if !price?{
                        var priceFloat:Float? = result["collectionPrice"] as? Float
                        var nf:NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2;
                        if priceFloat?{
                            price = "$" + nf.stringFromNumber(priceFloat)
                        }
                    }
                }
                
                var thumbnailURL:String? = result["artworkUrl60"] as? String
                var imageURL:String? = result["artworkUrl100"] as? String
                var artistURL:String? = result["artistViewUrl"] as? String
                
                var itemURL:String? = results["collectionViewUrl"] as? String
                if !itemURL?{
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var collectionId = result["collectionId"] as? Int
                var vAlbum = Album(name: name!, price: price!, thumbnailURL: thumbnailURL!, largeImageURL: imageURL, itemURL: itemURL, artistURL: artistURL, collectionId:collectionId)
                albums.append(vAlbum)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.appsTableView.reloadData()
                })
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}
