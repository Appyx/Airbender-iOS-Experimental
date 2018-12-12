//
//  MLPreProcessor.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import Surge

class Preprocessor {

    var raw: DataFrame
    var frequency: DataFrame
    var computed: SampleFrame

    init(frame: DataFrame) throws {
        self.raw = frame
        if raw.checkSampleLengths() == false {
            throw DimesnsionError.lengthsNotEqual
        }
        self.computed = raw.accX.featurelessCopy()
        self.frequency=raw.featurelessCopy()
    }

    func resample(toSize: Int) throws {
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
        raw.apply { resample(data: $0, toSize: toSize) }
        if raw.checkEqualDimensions() == false {
            throw DimesnsionError.dimensionsNotEqual
        }
    }

    func dropEmptySamples() {
        raw.filter { $0.features.count == 0 }
    }

    func generateSignalLengths() {
        for (index, sample) in raw.accX.samples.enumerated() {
            let count=sample.features.count
            computed.samples[index].features.append(Double(count))
        }
    }
    
    func generateFFT(){
        raw.crossApply(target: frequency){fft($0)}
    }
    
    enum DimesnsionError: Error {
        case dimensionsNotEqual
        case lengthsNotEqual
    }
}


