//
//  ViewController.swift
//  TestTipCalculator
//
//  Created by lin on 14-7-7.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
   
    let tipMode:TipModel = TipModel(getTotal: 10.0, getPercentage: 0.3)
    
    var dataSource = Dictionary<Int,(taxTotal:Double,finalTotal:Double)>()
    var allKeys:Int[] = []
    
    @IBOutlet var totalTax: UITextField
    
    @IBOutlet var sliderPct: UISlider
    
    @IBOutlet var pctLable: UILabel
    
    @IBOutlet var textView: UITextView
    
    var tableView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       totalTax.text = "10"
        sliderPct.value = 0.3 * 10
        pctLable.text = "%\(sliderPct.value)"
        
        tableView.frame = textView.frame
        tableView.dataSource = self;
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUI(){
        var vPctStr = String(format:"%.2f",sliderPct.value)
        pctLable.text = vPctStr
//        totalTax.text = "10"
    }
    
    @IBAction func caculateClicked(sender: AnyObject) {
        tipMode.totalTip = Double( totalTax.text.bridgeToObjectiveC().doubleValue)
        dataSource = tipMode.getPossibleresult()
        allKeys = Array( dataSource.keys )
        allKeys = sort(allKeys)
        var vResultStr = ""
        sort(allKeys)
        for vKeyItem in allKeys{
            let vItem = dataSource[vKeyItem]!
            let vItemStr = String(format:"%.2f",vItem.taxTotal)
            vResultStr += "%\(vKeyItem):\(vItemStr)\n"
        }
        
        textView.text = vResultStr
        tableView.reloadData()
    }
    
    @IBOutlet var sliderValueChanged: UISlider
    
    @IBAction func valueChanged(sender: AnyObject) {
        tipMode.percentage = Double(sliderPct.value)
        refreshUI()
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return dataSource.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        let vCell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        let vKey = allKeys[Int(indexPath.row)]
        var vItem = dataSource[vKey]!
        let vToal = vItem.taxTotal
        let vFinal = vItem.finalTotal
        vCell.textLabel.text = "\(vToal)+++\(vFinal)"
        return vCell;
    }
    
//    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
//    }
}

