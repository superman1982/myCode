//
//  TestCell.swift
//  ell
//
//  Created by lin on 14-7-10.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {

    @IBOutlet var button: UIButton
    @IBOutlet var lable: UILabel
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        println("nib awake")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
