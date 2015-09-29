//
//  TableVC.swift
//  SwiftForTable
//
//  Created by lin on 14-7-2.
//
/*test bug cell 每隔一行居然无法点击*/

import Foundation
import UIKit

class TableVC:UITableViewController{

    
    var dataSource = []
    
    var thumbQueue = NSOperationQueue()
    
    let hackerNewsApiUrl = "http://qingbin.sinaapp.com/api/lists?ntype=%E5%9B%BE%E7%89%87&pageNo=1&pagePer=10&list.htm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string:"drag down to refresh")
        refreshControl.addTarget(self, action: "loadDataSource",forControlEvents:UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        self.tableView!.registerClass(UITableViewCell.self,forCellReuseIdentifier:"XHNewsCell");
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        loadDataSource()
    }
    
    override func didReceiveMemoryWarning() {}
    
    func loadDataSource(){
        self.refreshControl.beginRefreshing()
        var loadURL = NSURL.URLWithString(hackerNewsApiUrl)
        var request = NSURLRequest(URL:loadURL)
        var loadDataSourceQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: {response,data,error in
            if error{
                println(error)
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl.endRefreshing();
                    })
            }
            else{
                let vJson = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                let newsDataSource = vJson["item"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.dataSource = newsDataSource;
                    self.tableView.reloadData();
                    self.refreshControl.endRefreshing();
                    })
            }
            })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if(segue.identifier == "showWebDetail"){
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("XHNewsCell",forIndexPath: indexPath) as UITableViewCell;

        let object = dataSource[indexPath.row] as NSDictionary
        
        cell.textLabel.text = object["title"] as String
//        cell.detailTextLabel.text = object["id"] as String
        
        
        cell.imageView.image = UIImage(named:"cell_photo_default_small");
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let request = NSURLRequest(URL:NSURL.URLWithString(object["thumb"] as String))
        NSURLConnection.sendAsynchronousRequest(request, queue:thumbQueue, completionHandler: {
            responce, vData, error in
            if(error){
                println(error);
            }else{
                let image = UIImage(data:vData)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView.image = image;
                    })
            }
            })
        
        return cell;
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 44.0;
    }
    
    override func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var vDetailVC = DetailVC()
        self.navigationController.pushViewController(vDetailVC, animated: true)
    }
    
}