//
//  PreprocessorV2.swift
//  Airbender
//
//  Created by Christopher Ebner on 14.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import Surge

class PreprocessorV2 {
    var raw: DataFrame
    
    init(frame: DataFrame) throws {
        self.raw = frame
        if raw.checkSampleLengths() == false {
            throw DimensionError.lengthsNotEqual
        }
    }
    
    func applyResampling(toSize: Int) throws {
        func resample(data: [Double], toSize: Int) -> [Double] {
            let sampleFactor = Double(data.count) / Double(toSize)
            var fraction = 0.00
            
            print("sample factor: \(sampleFactor)")
            print("original data size: \(data.count)")
            
            var sampledData = [Double]()
            var i = 0
            while i < data.count {
                let step = Int(floor(sampleFactor + fraction))
                fraction = (sampleFactor + fraction).truncatingRemainder(dividingBy: 1) + 0.000001
                
                sampledData.append(data[i])
                i += step
            }
            return sampledData
        }
        raw.applyInPlace { resample(data: $0, toSize: toSize) }
        if raw.checkEqualDimensions() == false {
            throw DimensionError.dimensionsNotEqual
        }
    }
    
    func applyEmptySampleFilter() {
        raw.filter { $0.features.count == 0 }
    }
    
    func applyLowpass(cutoff: Int) {  //TODO: check math
        let transformed = raw.apply { fft($0) }
        let filtered = transformed.apply {
            let step = 50 / $0.count
            let validRange = cutoff / step
            let toDrop = $0.count - validRange
            return Array($0.dropLast(toDrop)) }
        filtered.applyInPlace { fft($0) }
        raw = filtered
    }
    
    
    enum DimensionError: Error {
        case dimensionsNotEqual
        case lengthsNotEqual
    }
}
