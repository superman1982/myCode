//
//  APIController.swift
//  testItunesConnect
//
//  Created by lin on 14-7-8.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

protocol APIControllerProtocol{
     func APIControllerDidReceiveResult(result:NSDictionary)
}

class APIController: NSObject,NSURLConnectionDataDelegate {
   
    //            var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
    var data = NSMutableData()
    var delegate:APIControllerProtocol?
    
    init(delegate:APIControllerProtocol?){
        self.delegate = delegate
    }
    
    func searchAPIResult(searchTerm:String){
        var escapedSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        escapedSearchTerm = escapedSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath  = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        var url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url)
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        println("requestURL:\(url)")
        connection.start()
    }
    
     func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
     {
        self.data = NSMutableData()
    }
     func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
     {
        self.data.appendData(data)
    }
    
     func connectionDidFinishLoading(connection: NSURLConnection!)
     {
        var jsonStr:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        delegate?.APIControllerDidReceiveResult(jsonStr)
        
     }
    
}
