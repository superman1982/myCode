//
//  Album.swift
//  ItunesConnect
//
//  Created by lin on 14-7-8.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class Album: NSObject {
    var title:String?
    var price:String?
    var thumbnailImageURL:String?
    var largeImageURL:String?
    var itemURL:String?
    var artistURL:String?
    var collectionId:Int?
    
    init(name:String?,price:String?,thumbnailURL:String?,largeImageURL:String?,
        itemURL:String?,artistURL:String?,collectionId:Int?){
            self.title = name;
            self.price = price
            self.thumbnailImageURL = thumbnailURL
            self.largeImageURL = largeImageURL
            self.itemURL = itemURL
            self.artistURL = artistURL
            self.collectionId = collectionId
    }
}
