//
//  RefreshTableHeaderView.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-23.
//  Copyright (c) 2014 lin. All rights reserved.
//

enum PullRefreshState {
    case PullRefreshPulling
    case PullRefreshNormal
    case PullRefreshLoading
}


import UIKit
import QuartzCore

protocol EGORefreshTableHeaderDelegate{
    func egoRefreshTableHeaderDidTriggerRefresh(view:AnyObject)
    func egoRefreshTableHeaderDataSourceIsLoading(view:AnyObject)->Bool
    func egoRefreshTableHeaderDataSourceLastUpdated(view:AnyObject)->NSDate
}

class RefreshTableHeaderView: UIView {
    var _state:PullRefreshState?
    var _lastUpdatedLabel:UILabel = UILabel()
    var _statusLabel:UILabel = UILabel()
    var _activityView:UIActivityIndicatorView = UIActivityIndicatorView()
    var delegate:EGORefreshTableHeaderDelegate?
    var _circleView:CircleView?
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor(red: 226.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0)
//        self.backgroundColor = UIColor.redColor()
        _lastUpdatedLabel.frame = CGRectMake(0.0, 10.0, self.frame.size.width, 20.0)
        _lastUpdatedLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        _lastUpdatedLabel.font = UIFont.systemFontOfSize(12.0)
        _lastUpdatedLabel.textColor = UIColor(red:87.0/255.0 ,green:108.0/255.0 ,blue:137.0/255.0 ,alpha:1.0)
        _lastUpdatedLabel.shadowColor = UIColor(white: 0.9, alpha: 1.0)
        _lastUpdatedLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        _lastUpdatedLabel.backgroundColor = UIColor.clearColor()
        _lastUpdatedLabel.textAlignment = NSTextAlignment.Center
        
        self.addSubview(_lastUpdatedLabel)
        
        _statusLabel.frame = CGRectMake(0.0, 28.0, self.frame.size.width, 20.0)
        _statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        _statusLabel.font = UIFont.systemFontOfSize(13.0)
        _statusLabel.textColor = UIColor(red:87.0/255.0 ,green:108.0/255.0 ,blue:137.0/255.0 ,alpha:1.0)
        _statusLabel.shadowColor = UIColor(white: 0.9, alpha: 1.0);
        _statusLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        _statusLabel.backgroundColor = UIColor.clearColor()
        _statusLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(_statusLabel)
        
        var circleView:CircleView = CircleView(frame: CGRectMake(10, 5, 35, 35))
        _circleView = circleView
        self.addSubview(_circleView)
        
        self.setState(PullRefreshState.PullRefreshNormal)
    }

    func setState(aState:PullRefreshState){
        switch aState{
        case .PullRefreshPulling:
            _statusLabel.text = "Release to refresh..."
            break
        case .PullRefreshNormal:
            if _state == PullRefreshState.PullRefreshPulling{

            }else {
                _circleView!.progress = 0
                _circleView!.setNeedsDisplay()
                _statusLabel.text = "Release to refresh..."
            }
            self.refreshLastUpdatedDate()
            break;
        case .PullRefreshLoading:
            _statusLabel.text = "loading..."
            
            var rotate:CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
            rotate.removedOnCompletion = false;
            rotate.fillMode = kCAFillModeForwards
            rotate.toValue = NSNumber(double: M_PI / 2.0)
            rotate.duration = 0.25
            rotate.repeatCount = 11
            rotate.cumulative = true;
            rotate.timingFunction = CAMediaTimingFunction(name: "linear")
            _circleView!.layer.addAnimation(rotate, forKey: "rotateAnimation")
            break
        }
        
        _state = aState
    }
    
    func refreshLastUpdatedDate(){
        if self.delegate?{
            var date:NSDate = delegate!.egoRefreshTableHeaderDataSourceLastUpdated(self)
            var formatter:NSDateFormatter = NSDateFormatter()
            formatter.AMSymbol = "AM"
            formatter.PMSymbol = "PM"
            formatter.dateFormat = "MM/dd/yyyy hh:mm:a"
            _lastUpdatedLabel.text = "Last Updated: \(formatter.stringFromDate(date))"
           NSUserDefaults.standardUserDefaults().setObject(_lastUpdatedLabel.text, forKey: "RefreshTableView_LastRefresh")
            NSUserDefaults.standardUserDefaults().synchronize()
        }else{
            _lastUpdatedLabel.text = nil;
        }
    }
    
    func refreshScrollViewDataSourceDidFinishedLoading(scrollView:UIScrollView){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        UIView.commitAnimations()
        
        var delayInSeconds:Double = 0.2;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double( NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_current_queue(), {
            })
        _circleView!.layer .removeAllAnimations()
    }
    
    func forceToRefresh(aScrollView:UIScrollView){
        var _loading:Bool = false;
        delegate? .egoRefreshTableHeaderDataSourceIsLoading(self)
        if (!_loading){
            delegate?.egoRefreshTableHeaderDidTriggerRefresh(self)
            self.setState(PullRefreshState.PullRefreshLoading)
            UIView.beginAnimations(nil, context: nil)
            aScrollView.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0);
            UIView.commitAnimations()
            _circleView!.progress = 1;
            _circleView!.setNeedsDisplay()
        }
    }
    
    func egoRefreshScrollViewWillBeginScroll(scrollView: UIScrollView){
        var _loading:Bool = false
        if(delegate?){
            _loading = delegate!.egoRefreshTableHeaderDataSourceIsLoading(self)
        }
        if(!_loading){
            self .setState(PullRefreshState.PullRefreshNormal)
        }
    }
    
    func egoRefreshScrollViewDidEndDragging(scrollView:UIScrollView){
        var _loading:Bool = false
        if(delegate?){
            _loading = delegate!.egoRefreshTableHeaderDataSourceIsLoading(self)
        }
        
        if(scrollView.contentOffset.y <= -65.0
            && !_loading){
                if(delegate?){
                    delegate!.egoRefreshTableHeaderDidTriggerRefresh(self)
                }
                self.setState(PullRefreshState.PullRefreshLoading)
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                scrollView.contentInset = UIEdgeInsetsMake(60.0, 0, 0, 0)
                UIView.commitAnimations()
        }
    }
    
    func egoRefreshScrollViewDidScroll(scrollView:UIScrollView){
        if(_state == PullRefreshState.PullRefreshLoading){
            var offset:CGFloat = max(scrollView.contentOffset.y * -1, 0)
            offset = min(offset, 60)
            scrollView.contentInset = UIEdgeInsetsMake(offset
                , 0.0, 0.0, 0.0)
        }else if (scrollView.dragging){
            var _loading:Bool = false
            if(delegate?){
                _loading = delegate!.egoRefreshTableHeaderDataSourceIsLoading(self)
            }
            
            if(_state == PullRefreshState.PullRefreshPulling
              && scrollView.contentOffset.y > -65.0
              && scrollView.contentOffset.y < 0.0
              && !_loading){
                self.setState(PullRefreshState.PullRefreshNormal)
            }else if (_state == PullRefreshState.PullRefreshNormal
                      && scrollView.contentOffset.y < -15.0
                      && !_loading){
                        var moveY:CGFloat = fabsf(scrollView.contentOffset.y)
                        if (moveY > 65){
                            moveY = 65
                        }
                        _circleView!.progress = (moveY - 15) / (65 - 15)
                        _circleView!.setNeedsDisplay()
                    
                        if (scrollView.contentOffset.y < -65.0){
                            self.setState(PullRefreshState.PullRefreshPulling)
                        }
            }
            
            if(scrollView.contentInset.top != 0){
                scrollView.contentInset = UIEdgeInsetsZero
            }
        }
        
    }
    
}
