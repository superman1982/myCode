//
//  HorizontalMenu.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

let ButtonItemHeight:CGFloat =  40
let LengthKey:String = "itemLength"
let NormalImageKey:String = "normalImage"
let HelightImageKey:String = "helightImage"
let TitleKey:String = "title"

protocol HorizontalMenuDelegate{
    func didClickedButtonItemAtIndex(aIndex:Int)
}

class HorizontalMenu: UIView {
    let scrowView:UIScrollView = UIScrollView()
    var itemButtons:AnyObject[] = AnyObject[]()
    var delegate:HorizontalMenuDelegate?
    
    init(frame: CGRect,delegate:HorizontalMenuDelegate) {
        super.init(frame: frame )
        // Initialization code
        println("frame(\(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height))")
        scrowView.frame = self.frame
        self.addSubview(scrowView);
        
        self.delegate = delegate
    }
    
    func createMenu(ItemInfos:NSDictionary[]){
        itemButtons.removeAll(keepCapacity: true)
        var totalLength:Float = 0
        var vIndex:Int = 100;
        for item:NSDictionary in ItemInfos {
            var itemLength:Float = item[LengthKey] as Float
            var lButton = UIButton(frame: CGRectMake(totalLength, 0, itemLength, ButtonItemHeight))
            lButton.setBackgroundImage(UIImage(named: String( item[NormalImageKey] as String)), forState: UIControlState.Normal)
            lButton.setBackgroundImage(UIImage(named: String( item[HelightImageKey] as String)), forState: UIControlState.Selected)
            lButton.setTitle(item[TitleKey] as String, forState: UIControlState.Normal)
            lButton.addTarget(self, action: "itemClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            lButton.tag = vIndex
            
            self.scrowView.addSubview(lButton)
            totalLength = itemLength + totalLength
            
            self.itemButtons.append(lButton)
            vIndex++
        }
        
        scrowView.contentSize = CGSizeMake(totalLength, self.frame.size.height)
    }
    
    
    func clearOtherButtonItemState(){
        for lButton:AnyObject  in itemButtons{
            var vButton = lButton as UIButton
            vButton.selected = false
        }
    }
    
    func itemClicked(sender:UIButton){
        self.clearOtherButtonItemState();
        sender.selected = true;
        self.moveScrollViewToLocation(CGPointMake(sender.frame.origin.x + sender.frame.size.width, sender.frame.origin.y))
        self.delegate?.didClickedButtonItemAtIndex((sender.tag - 100))
    }
    
    func clickedButtonAtIndex(aIndex:Int){
        if itemButtons.count <= aIndex{
            return;
        }
        
        self.clearOtherButtonItemState();
        var vButton:UIButton = itemButtons[aIndex] as UIButton
        vButton.selected = true;
        self.moveScrollViewToLocation(CGPointMake(vButton.frame.origin.x + vButton.frame.size.width, vButton.frame.origin.y))
        self.delegate?.didClickedButtonItemAtIndex((vButton.tag - 100))
    }
    
    func changeButtonStateImageAtIndex(aIndex:Int){
        self.clearOtherButtonItemState()
        var vButton:UIButton = itemButtons[aIndex] as UIButton
        vButton.selected = true;
        self.moveScrollViewToLocation(CGPointMake(vButton.frame.origin.x + vButton.frame.size.width, vButton.frame.origin.y))
    }
    
    func moveScrollViewToLocation(aPoint:CGPoint){
        if aPoint.x > 250 {
            //compare the lenth to the end ,
            var lengthCompareToEnd :CGFloat = scrowView.contentSize.width - aPoint.x
            if (lengthCompareToEnd <= 150){
                scrowView.setContentOffset(CGPointMake(scrowView.contentSize.width - 320, scrowView.contentOffset.y), animated: true)
                return
            }
            var vMoveLocationAtHorizontal:CGFloat = aPoint.x - 180
            scrowView.setContentOffset(CGPointMake(vMoveLocationAtHorizontal, scrowView.contentOffset.y), animated: true)
   
        }else{
            scrowView.setContentOffset(CGPointMake(0, scrowView.contentOffset.y), animated: true)
        }
    }

}
