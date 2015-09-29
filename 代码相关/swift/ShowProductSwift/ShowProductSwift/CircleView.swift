//
//  CircleView.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-23.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var progress:Float = 0
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect)
    {
        // Drawing code
       var context:CGContextRef = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 2.0);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor);
      
        var startAngle:CGFloat = CGFloat( M_PI) / 3.0;
        var step:Float = Float( 11 * M_PI ) / Float( 6.0);
        step = step  * progress
        CGContextAddArc(context, self.bounds.size.width / 2.0 , self.bounds.size.height /  2.0, self.bounds.size.width / 2.0 - 3, startAngle, startAngle+step, 0);
        CGContextStrokePath(context);
    }

}
