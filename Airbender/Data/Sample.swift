//
//  LabeledRawData.swift
//  Airbender
//
//  Created by Christopher Ebner on 27.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class Sample{
    var user: String
    var gesture: Int
    var features: [Double]
    var csvString:String{
        let featureString=features.map{String($0)}.joined(separator: ";")
        return "\(user);\(gesture);\(featureString)"
    }
    
    init(user:String,gesture:Int,features:[Double]) {
        self.user=user
        self.gesture=gesture
        self.features=features
    }
    
    init(csvString:String) {
        var components=csvString.split(separator: ";").map{String($0)}
        user=components.remove(at: 0)
        gesture=Int(components.remove(at: 0))!
        features=components.map{Double($0)!}
    }
    
    
  
}
