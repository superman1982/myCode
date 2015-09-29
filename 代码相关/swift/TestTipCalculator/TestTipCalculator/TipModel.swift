//
//  TipModel.swift
//  TestTipCalculator
//
//  Created by lin on 14-7-7.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

class TipModel: NSObject {
    var totalTip:Double?
    var percentage:Double?
    var subTotal:Double{
    get{
        return totalTip! / (1 + percentage!);
      }
    }
    
    init(getTotal aTotal:Double, getPercentage aPercen:Double){
        totalTip = aTotal
        percentage = aPercen;
    }
    
    func calculateResult(aTax:Double) -> (taxTotal:Double,finalTotal:Double){
        var taxResult = subTotal * aTax
        var finaTotal = totalTip! + taxResult
        return (taxResult,finaTotal)
    }
    
    func getPossibleresult()->Dictionary<Int,(taxTotal:Double,finalTotal:Double)>{
        let vRates :Double[] = [0.15,0.18,0.20]
        var vResults = Dictionary<Int,(taxTotal:Double,finalTotal:Double)>()
        for item in vRates{
            var index = Int( item * 100)
            var vResult = calculateResult(item)
            vResults[index] = vResult
        }
        
        return vResults
    }
}
