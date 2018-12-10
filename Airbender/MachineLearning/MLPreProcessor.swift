//
//  MLPreProcessor.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import Accelerate

class MLPreProcessor {
    let rawData: Sample
    var processedData: [[Double]]?
    
    init(data: Sample) {
        rawData = data               
    }
    
//    init(data: [[Double]]) {
//        rawData = data
//    }
    
//    func resample(toSize: Int) {
//        let dataCount = rawData.data.count
//        if dataCount < toSize {
//            upsample(from: toSize, to: toSize)
//        } else if dataCount > toSize {
//            downsample(from: toSize, to: toSize)
//        }
//    }
    
    private func resample(data: [Double], toSize: Int) {
        let sampleFactor = Double(data.count) / Double(toSize)
        var fraction = 0.00
        
        print("sample factor: \(sampleFactor)")
        print("dataSize: \(data.count)")
        
        var sampledData = [Double]()
        var i = 0
        while i < data.count {
            let step = Int(floor(sampleFactor + fraction))
            fraction = (sampleFactor + fraction).truncatingRemainder(dividingBy: 1) + 0.000001
            
            sampledData.append(data[i])
            i += step
        }
        
        print("dataSizeDownSampled: \(sampledData.count)")
    }
    
    
    
//    func convertTo
    
}

