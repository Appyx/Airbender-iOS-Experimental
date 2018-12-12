//
//  GeneralDaframe.swift
//  Airbender
//
//  Created by Robert Gstöttner on 12.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class SampleFrame {
    var samples:[Sample]=[]
    
    var factors:[Sample.Factors]{
        return samples.map{$0.factors}
    }
    
    func featurelessCopy()->SampleFrame{
        let frame = SampleFrame()
        frame.samples=factors.map{Sample(factors: $0, features: [])}
        return frame
    }
    
    func apply(fun: ([Double]) -> [Double]) {
        samples.forEach { $0.features = fun($0.features) }
    }
    
    func crossApply(target:SampleFrame,fun: ([Double]) -> [Double]){
        for (index,sample) in samples.enumerated() {
            target.samples[index].features=fun(sample.features)
        }
    }
    
    func filter(fun: (Sample) -> Bool) {
        samples.removeAll { fun($0) }
    }
    
    func append(_ sample:Sample){
        samples.append(sample)
    }
    
}
