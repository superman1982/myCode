//
//  DownLoadMoreCell.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-28.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class DownLoadMoreCell: UITableViewCell {
    let activityView:UIActivityIndicatorView  = UIActivityIndicatorView()
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.text = "cliked to load more"
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityView.frame = CGRectMake(270, 40, activityView.frame.size.width, activityView.frame.size.height);
    
        self.addSubview(activityView);
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
