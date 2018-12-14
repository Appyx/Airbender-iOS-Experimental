//
//  RawDataAdapter.swift
//  Airbender
//
//  Created by Christopher Ebner on 14.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation


class Adapter: DataFrameAdapter {
    var dim:[SampleFrame]=[]
    
    init() {
        dim.append(SampleFrame())
        dim.append(SampleFrame())
        dim.append(SampleFrame())
        dim.append(SampleFrame())
        dim.append(SampleFrame())
        dim.append(SampleFrame())
    }
    func getDimensions() -> [SampleFrame] {
        return dim
    }
    
    func add(factors:Sample.Factors, rawData:[RawData]){
        dim[0].add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accX }))
        dim[1].add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accY }))
        dim[2].add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accZ }))
        dim[3].add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accX }))
        dim[4].add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accY }))
        dim[5].add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accZ }))
    }
    
    
}
