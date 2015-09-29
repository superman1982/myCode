//
//  DetailsViewController.swift
//  ItunesConnect
//
//  Created by lin on 14-7-9.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore

class DetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,APIControllerProtocol{
    
    var album:Album?
    var albumCOver:UIImageView = UIImageView()
    var titleLable:UILabel = UILabel()
    var detailsTextView:UITextView = UITextView()
    var openButton:UIButton = UIButton()
    var tracksTableView = UITableView()
    var tracks:Track[] = []
    var mediaPlayer:MPMoviePlayerController = MPMoviePlayerController()
    var selectedRow:Int?
    
    @lazy var api:APIController = APIController(aDelegate: self)
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (IS_IOS7) {
//            self.edgesForExtendedLayout =UIRectEdgeNone ;
//        }
        self.edgesForExtendedLayout = .None
        
        // Do any additional setup after loading the view.
        albumCOver.frame = CGRectMake((320-100)/2, 10, 100, 100)
        titleLable.frame = CGRectMake(100, 130, 200, 32)
        tracksTableView.frame = CGRectMake(0, 170, 320, 200)
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        
        titleLable.text = self.album?.title
        self.view.addSubview(albumCOver)
        self.view.addSubview(titleLable)
        self.view.addSubview(tracksTableView)
        
        var request = NSURLRequest(URL: NSURL(string: self.album?.largeImageURL))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response,data,error in
            if (error){}
            else{
                self.albumCOver.image = UIImage(data: data)
            }
            })

        
        if self.album?.collectionId?{
            api.lookupAlbum(self.album!.collectionId!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }

    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = TrackCell(style: UITableViewCellStyle.Default, reuseIdentifier: "kCell")  as TrackCell
//        tableView.dequeueReusableCellWithIdentifier("TrackCell") as? TrackCell
    
        var track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        if Int(indexPath.row) == selectedRow
        {
            cell.playIcon.text = "🔼"
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        selectedRow = Int(indexPath.row)
        var track = tracks[indexPath.row]
        if(mediaPlayer.playbackState == MPMoviePlaybackState.Playing){
            mediaPlayer.pause()
        }else{
            mediaPlayer.contentURL = NSURL(string: track.previewUrl)
            mediaPlayer.play()
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell
            {
                cell.playIcon.text = "🔼"
            }
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
    
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            } )
    }

    func didReceiveAPIResults(results:NSDictionary)
    {
        if let allRessults = results["results"] as? NSDictionary[]{
            for trackInfo in allRessults{
                if let kind = trackInfo["kind"] as? String{
                    if kind == "song"{
                        var track = Track(dict: trackInfo)
                        tracks.append(track)
                    }
                }
            }

        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tracksTableView.reloadData()
            })
    }
    
    
}
