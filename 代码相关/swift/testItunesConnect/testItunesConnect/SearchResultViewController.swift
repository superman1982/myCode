//
//  SearchResultViewController.swift
//  testItunesConnect
//
//  Created by lin on 14-7-8.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController,UITableViewDataSource,APIControllerProtocol {
    var tableView:UITableView = UITableView()
    var tableDataSource:NSArray = NSArray()
    
    @lazy var api:APIController = APIController(delegate:self)
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.frame = self.view.frame;
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        api.searchAPIResult("Angry Birds")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.tableDataSource.count
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "testCell")
        
        var rowData:NSDictionary = self.tableDataSource[indexPath.row] as NSDictionary
        cell.text = rowData["trackName"] as String
        /*"artworkUrl60,formattedPrice"*/
        
        var urlPath = rowData["artworkUrl60"] as String
        var url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url)
        
        cell.image = UIImage(named: "default.png")
        NSURLConnection.sendAsynchronousRequest(request
            , queue: NSOperationQueue.currentQueue(), completionHandler:{
                response,data,error in
                if(error){}
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.image = UIImage(data: data)
                        })
                }
            } )
        var price = rowData["formattedPrice"] as String
        cell.detailTextLabel.text = price
        
        return cell
    }
    
    
    func APIControllerDidReceiveResult(result: NSDictionary) {
        
        if result.count > 0{
            self.tableDataSource = result["results"] as NSArray
            self.tableView.reloadData()
        }
        
    }
    

}
