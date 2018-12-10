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
    
    func interpolate(toSize: Int) {
        // https://stackoverflow.com/questions/53212548/swift-linear-interpolation-and-upsampling
        

    }
    
//    func convertTo
}

