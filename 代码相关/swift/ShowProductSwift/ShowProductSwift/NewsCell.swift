//
//  NewsCell.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-16.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    var mHeadImage:UIImageView = UIImageView(frame: CGRectMake(20, 10, 60, 60))
    var mTitleLable:UILabel = UILabel(frame: CGRectMake(90, 10, 310 - 80
, 21))
    var mDetailLable:UILabel = UILabel(frame: CGRectMake(90, 35, 310-80, 42))
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRectMake(0, 0,320, 80)
        
        var vImageView = self.viewWithTag(1000);
        vImageView?.removeFromSuperview()
        mHeadImage.tag = 1000
        self.addSubview(mHeadImage)
        
        var vTitlaLable = self.viewWithTag(1001)
        vTitlaLable?.removeFromSuperview()
        mTitleLable.tag = 10001
        self.addSubview(mTitleLable)
        
        var vDetailLable = self.viewWithTag(1002)
        vDetailLable?.removeFromSuperview()
        mDetailLable.tag = 1002
        mDetailLable.font = UIFont.systemFontOfSize(12)
        mDetailLable.numberOfLines = 0
        self.addSubview(mDetailLable)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
