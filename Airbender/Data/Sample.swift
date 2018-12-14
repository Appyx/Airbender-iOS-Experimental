//
//  LabeledRawData.swift
//  Airbender
//
//  Created by Christopher Ebner on 27.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class Sample{
    let factors: Factors
    var features: [Double]
    var csvString:String{
        let featureString=features.map{String($0)}.joined(separator: ";")
        return "\(factors.csvString);\(featureString)"
    }
    var length:Int{
        return features.count+2
    }
    
    init(factors:Factors,features:[Double]) {
        self.factors=factors
        self.features=features
    }
    
    init(csvString:String) {
        var components=csvString.split(separator: ";").map{String($0)}
        factors=Factors(user: components.remove(at: 0), gesture: Int(components.remove(at: 0))!)
        features=components.map{Double($0)!}
    }
    
    class Factors {
        let user: String
        let gesture: Int
        
        var csvString:String{
            return "\(user);\(gesture)"
        }
        
        init(user:String,gesture:Int) {
            self.user=user
            self.gesture=gesture
        }
        
        convenience init(){
            self.init(user: "unknown",gesture: -1)
        }
    }

}
