//
//  NewsPageView.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-16.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
//loadWebData Delegate, you could user those two function where you needed
protocol NewsPageViewDelegate{
    func loadData(completion:(( aNewRowCount:Int)->Void)!,FromView:AnyObject)
    func refreshData(completion:(()->Void)!,FromView:AnyObject)
}

//TableViewDataSource ,you could implement the function where you need, and then
//the tableView‘s refreshView and download  Cell are alread there ,don't need 
//recreate them 
protocol NewsPageViewDataSource{
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int,FromView:AnyObject) -> Int
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!,FromView:AnyObject) -> UITableViewCell!
}

class NewsTableView: UIView,UITableViewDataSource,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UITableViewDelegate {
    let tableView:UITableView = UITableView()
    //refresh view
    let _refreshHeaderView:RefreshTableHeaderView!
    //user for refreshing data
    var _reloading:Bool = false
    var delegate:NewsPageViewDelegate?
    var datasource:NewsPageViewDataSource?
    //save the data of the news
    var newsInfo:NSMutableArray = NSMutableArray()
    //recored the current rowCount, user for insert new data to the table
    var currentRowCount:Int = 0
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        _refreshHeaderView = RefreshTableHeaderView(frame:  CGRectMake(0, 0, 320, 200))
        _refreshHeaderView.delegate = self;
        //        self.insertSubview(_refreshHeaderView, belowSubview: tableView)
        self.addSubview(_refreshHeaderView)
        tableView.frame = CGRectMake(0, 0, 320, self.frame.size.height)
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 80;
        tableView.backgroundColor = UIColor.clearColor()
        self.addSubview(tableView)
        
        newsInfo = [
            "0",
            "0",
            "0",
            "0",
                   ]
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount:Int = 0
        if ( datasource?){
            rowCount = datasource!.tableView(tableView, numberOfRowsInSection: section, FromView: self)
            if(rowCount > 0){
                rowCount += 1;
            }
        }
        return rowCount;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        if(indexPath.row == (newsInfo.count)){
            let cell:DownLoadMoreCell = DownLoadMoreCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loadCell")
            cell.textAlignment = NSTextAlignment.Center;
            
            return cell
        }else{
            if( datasource? ){
                let cell = datasource!.tableView(tableView, cellForRowAtIndexPath: indexPath, FromView: self)
                return cell;
            }
        }
        return nil;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        if(indexPath.row == newsInfo.count){
            currentRowCount = tableView.numberOfRowsInSection(indexPath.section) - 1
            var cell:DownLoadMoreCell = tableView.cellForRowAtIndexPath(indexPath) as DownLoadMoreCell
            cell.activityView.startAnimating()
            cell.activityView.hidden = false
            self.loadMoreData({(aNewRowCount:Int) in
                cell.activityView.stopAnimating()
                cell.activityView.hidden = true;
                if(aNewRowCount > 0){
                    tableView.beginUpdates()
                    var indexPathes:NSMutableArray = NSMutableArray()
                    for(var index:Int = self.currentRowCount; index < self.currentRowCount + aNewRowCount; index++){
                        var path: NSIndexPath = NSIndexPath(forItem: index, inSection: indexPath.section)
                        indexPathes.addObject(path)
                    }
                    
                    self.currentRowCount += aNewRowCount
                    tableView.insertRowsAtIndexPaths(indexPathes, withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.endUpdates()
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
                }

                })
        }
    }
//force refresh
    func forceToRefresh(){
        tableView.setContentOffset(CGPointMake(tableView.contentOffset.x, -66), animated: true)
        var delayInSeconds:Double = 0.2;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double( NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_current_queue(), {
            self._refreshHeaderView.forceToRefresh(self.tableView);
        })
    }
    
//helper function
    func loadMoreData(complete:(( aNewRowCount:Int)->Void)!){
        if(delegate?){
            //代理，加载网络数据，需实现代理方法，
            delegate!.loadData({(aNewRowCount:Int) in
                if complete{
                    complete(aNewRowCount:4)
                }
                }, FromView: self)
        }else{
            //模拟加载网络数据，延时2秒执行
            var delayInSeconds:Double = 2.0;
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double( NSEC_PER_SEC)));
            dispatch_after(popTime, dispatch_get_current_queue(), {
                for var i:Int = 0; i < 4 ; i++
                {
                    self.newsInfo.addObject("0")
                }
                if complete{
                    complete(aNewRowCount: (4))
                }
                })
        }
    }
    
//Data Source Loading / Reloading Methods
    func reloadTableViewDataSource(){
        _reloading = true
        //检查是否实现代理方法，数据请求成功后，刷新列表
        if(delegate?){
            delegate!.refreshData({
                self.doneLoadingTableViewData()
                }, FromView: self)
        }else {
            //模拟请求网络数据，
            var delayInSeconds:Double = 2.0;
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double( NSEC_PER_SEC)));
            dispatch_after(popTime, dispatch_get_current_queue(), {
                self.newsInfo.removeAllObjects()
                for var i:Int = 0; i < 4 ; i++
                {
                    self.newsInfo.addObject("0")
                }
                self.doneLoadingTableViewData()
                })
        }
    }
    //完成数据请求
    func doneLoadingTableViewData(){
        _reloading = false;
        _refreshHeaderView.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
        self.tableView.reloadData()
    }
    
// UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView!){
        _refreshHeaderView.egoRefreshScrollViewWillBeginScroll(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!){
        _refreshHeaderView.egoRefreshScrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool){
        _refreshHeaderView.egoRefreshScrollViewDidEndDragging(scrollView)
    }
    
// EGORefreshTableHeaderDelegate
    func egoRefreshTableHeaderDidTriggerRefresh(view:AnyObject){
        self.reloadTableViewDataSource()
    }
    func egoRefreshTableHeaderDataSourceIsLoading(view:AnyObject)->Bool
    {
        return _reloading
    }
    func egoRefreshTableHeaderDataSourceLastUpdated(view:AnyObject)->NSDate{
        return NSDate(timeIntervalSinceNow: 1.0)
    }
}
