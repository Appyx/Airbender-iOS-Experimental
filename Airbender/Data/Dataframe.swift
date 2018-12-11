//
//  Dataframe.swift
//  Airbender
//
//  Created by Robert Gstöttner on 11.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class Dataframe {
    var accX:[Sample]=[]
    var accY:[Sample]=[]
    var accZ:[Sample]=[]
    var gyrX:[Sample]=[]
    var gyrY:[Sample]=[]
    var gyrZ:[Sample]=[]
    
    func apply(fun:([Double])->[Double]){
        accX.forEach{$0.features=fun($0.features)}
        accY.forEach{$0.features=fun($0.features)}
        accZ.forEach{$0.features=fun($0.features)}
        gyrX.forEach{$0.features=fun($0.features)}
        gyrY.forEach{$0.features=fun($0.features)}
        gyrZ.forEach{$0.features=fun($0.features)}
    }
    
    func filterSamples(fun: (Sample)->Bool){
        accX.removeAll{fun($0)}
        accY.removeAll{fun($0)}
        accZ.removeAll{fun($0)}
        gyrX.removeAll{fun($0)}
        gyrY.removeAll{fun($0)}
        gyrZ.removeAll{fun($0)}
    }

}
