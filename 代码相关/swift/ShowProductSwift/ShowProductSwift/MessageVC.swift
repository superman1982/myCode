//
//  MessageVC.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-14.
//  Copyright (c) 2014 lin. All rights reserved.
/* -----------------------------！！！！read me first！！！！！-----------------
1、本人搞IOS开发的，下载demo的朋友，如果你是IOS开发初学者，有兴趣的人可以查看下面的链接
http://item.taobao.com/item.htm?spm=a230r.1.14.137.drLUj5&id=39818151361&ns=1#detail

2、如果你是IOS开发老手，请多多包含。

3、本人之前用Object-c写了一个类似的demo,功能几乎相仿，有兴趣者请点击
http://code4app.com/ios/%E6%96%B0%E9%97%BB%E5%B1%95%E7%A4%BA%E7%95%8C%E9%9D%A2/53a267b6933bf051468b54b8
-------------------------------------------end-------------------------*/
import UIKit

let vHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
let vWidth:CGFloat = UIScreen.mainScreen().bounds.size.width


class MessageVC: UIViewController,HorizontalMenuDelegate,ScrollContentViewDelegate {
    
    @lazy var horizontalMenu:HorizontalMenu = HorizontalMenu(frame: CGRectMake(0,0, 320, ButtonItemHeight), delegate: self)
    var scrollContentView:ScrollContentView = ScrollContentView(frame:CGRectMake(0, ButtonItemHeight, 320, vHeight - ButtonItemHeight - 20 - 44))
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My news "
        // Do any additional setup after loading the view.
        var systemVersion = UIDevice.currentDevice().systemVersion.bridgeToObjectiveC().floatValue
        if systemVersion > 7.0{
            self.edgesForExtendedLayout = .None
        }
        println("systemVersion:\(systemVersion)")
        println("vHeight:\(vHeight)")

        let itemInfos:NSDictionary[] = [
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 80 ),
                TitleKey:"Music" ,
            ],
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 140 ),
                TitleKey:"Recomend News" ,
            ],
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 80 ),
                TitleKey:"TopNews" ,
            ],
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 80 ),
                TitleKey:"Sports" ,
            ],
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 80 ),
                TitleKey:"Boys" ,
            ],
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 80 ),
                TitleKey:"Girls" ,
            ],
            [
                NormalImageKey:"normal",
                HelightImageKey:"helight" ,
                LengthKey:Float( 80 ),
                TitleKey:"Economic" ,
            ],
        ]

       horizontalMenu.createMenu(itemInfos)
        
        var vPageInfos = NewsTableView[]()
        for( var index :NSInteger = 0; index < itemInfos.count; index++){
            var pageView:NewsTableView = NewsTableView(frame: CGRectMake(0, 0, 320, vHeight - ButtonItemHeight - 20 - 44 ))
            vPageInfos.append(pageView)
        }
        scrollContentView.addPages(vPageInfos)
        scrollContentView.delegate = self;
        self.view.addSubview(horizontalMenu)
        self.view.addSubview(scrollContentView)
        
        horizontalMenu.clickedButtonAtIndex(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //HorizontalMenuDelegate
    func didClickedButtonItemAtIndex(aIndex:Int)
    {
        println("clicked the \(aIndex) Button!");
        scrollContentView.moveContentViewToPage(aIndex)
    }
    
    //ScrollContentViewDelegate
    func didScrollToContentAtIndex(aIndex:Int){
        horizontalMenu.changeButtonStateImageAtIndex(aIndex)
        scrollContentView.forceRefreshPageAtIndex(aIndex)
    }

}
