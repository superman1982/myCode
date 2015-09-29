//
//  ScrollContentView.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-28.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

protocol ScrollContentViewDelegate{
    func didScrollToContentAtIndex(aIndex:Int);
}

class ScrollContentView: UIView,UIScrollViewDelegate,NewsPageViewDataSource {
    let scrollView:UIScrollView = UIScrollView()
    var pageInfos:NewsTableView[] = NewsTableView[]()
    var delegate:ScrollContentViewDelegate?
    var currentPage:Int = 0
    var needUserScrollViewDelegate:Bool = false;
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        scrollView.pagingEnabled = true;
        scrollView.delegate = self;
        self.addSubview(scrollView);
    }
    
    func addPages(aPageInfos:(NewsTableView)[]!){
        var index:CGFloat = 0;
        pageInfos = aPageInfos
        for page in aPageInfos{
            if page .isKindOfClass(NewsTableView){
                page.frame = CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height)
                self.scrollView.addSubview(page)
                page.datasource = self;
            }
            index++
        }
        scrollView.contentSize = CGSizeMake( self.frame.size.width * Float( pageInfos.count), self.frame.size.height)
        delegate? .didScrollToContentAtIndex(0)
    }
    
    func moveContentViewToPage(aPage:Int){
        if (pageInfos.count > aPage){
            scrollView.scrollRectToVisible(CGRectMake(self.frame.size.width * CGFloat(aPage), 0, self.frame.size.width, self.frame.size.height), animated: true);
            needUserScrollViewDelegate = false;
            delegate?.didScrollToContentAtIndex(aPage)
        }
    }
    
    func forceRefreshPageAtIndex(aPage:Int){
        if pageInfos.count > aPage{
            var vTableView = pageInfos[aPage]
            vTableView.forceToRefresh()
        }
    }
    
//NewsPageViewDataSource
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int ,FromView:AnyObject ) -> Int{
        var vNewsTableView:NewsTableView = FromView as NewsTableView
        return vNewsTableView.newsInfo.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath! ,FromView:AnyObject) -> UITableViewCell!
    {
        let cell:NewsCell = NewsCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.mHeadImage.image = UIImage(named: String("new\((indexPath.row%4 + 1))"));
        cell.mTitleLable.text = "Big News BigNews BigNews BigNews"
        cell.mDetailLable.text = "today someone was killed at the lake,so scaried"
        return cell
    }
    
//UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView!)
    {
        needUserScrollViewDelegate = true;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!){
        var page:CGFloat = (Float( scrollView.contentOffset.x ) + 320.0 / 2.0) /  320.0;
        if (currentPage == Int( page)) {
            return;
        }
        currentPage = Int(page);
        if(delegate? && needUserScrollViewDelegate){
            delegate!.didScrollToContentAtIndex(Int(page))
        }
    }
}
