//
//  Currency.swift
//  Currency
//
//  Created by Robert O'Connor and John Ryan on 16/03/2018.
//  Copyright © 2018 IrishTwitApps. All rights reserved.
//


import Foundation

class Currency {
    //MARK: Properties
    var name:String
    var rate:Double
    var flag:String
    var symbol:String
    
    //MARK: initiaizer
    init?(name:String, rate:Double, flag:String, symbol:String){
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rate < 0  || flag.isEmpty || symbol.isEmpty {
            return nil
        }
        
        self.name = name
        self.rate = rate
        self.flag = flag
        self.symbol = symbol
    }
}

