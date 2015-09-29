//
//  APIController.swift
//  ItunesConnect
//
//  Created by lin on 14-7-8.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

protocol APIControllerProtocol{
    func didReceiveAPIResults(results:NSDictionary)
}

class APIController: NSObject {
    var delegate:APIControllerProtocol?
    
    init(aDelegate:APIControllerProtocol?){
        self.delegate = aDelegate
    }
    
    func searchItunesFor(searchTerm:String){
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
        get(urlPath)
    }
    
    func lookupAlbum(collectionId:Int){
         get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
    func get(path:String){
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler:{
            data,responce,error in
            if(error){
                println("ERROR:(error.localizeDescription)")
            }
            else {
                var error:NSError?
                let jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                if(error?){
                    println("HTTP Error:(error?.localizeDescription)")
                }
                self.delegate?.didReceiveAPIResults(jsonResult)
            }
            } )
        task.resume()
    }

}
