//
//  Track.swift
//  ItunesConnect
//
//  Created by lin on 14-7-9.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class Track: NSObject {
   
    var title:String?
    var price:String?
    var previewUrl:String?
    
    init(dict:NSDictionary!){
        self.title = dict["trackName"] as? String
        self.price = dict["trackPrice"] as? String
        self.previewUrl = dict["previewUrl"] as? String
    }
}
