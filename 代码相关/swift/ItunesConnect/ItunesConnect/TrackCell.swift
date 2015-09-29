//
//  TrackCell.swift
//  ItunesConnect
//
//  Created by lin on 14-7-9.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
   /* @IBOutlet*/ var playIcon:UILabel = UILabel()
    /*@IBOutlet*/ var titleLabel:UILabel = UILabel ()
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        playIcon.frame = CGRectMake(10, 20, 40, 21)
        titleLabel.frame = CGRectMake(60, 20, 150, 21)
        self.addSubview(playIcon)
        self.addSubview(titleLabel)
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
