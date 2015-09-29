//
//  ViewController.swift
//  Cell
//
//  Created by lin on 14-7-10.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return 4;
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell:TestCell = tableView.dequeueReusableCellWithIdentifier("testCell") as TestCell
        cell.lable.text = "this is the\(indexPath.row)"
        return cell;
    }
}

