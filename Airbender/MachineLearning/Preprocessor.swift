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
    var processed: SampleFrame

    init(frame: DataFrame) throws {
        self.raw = frame
        if raw.checkSampleLengths() == false {
            throw DimensionError.lengthsNotEqual
        }
        self.processed = raw.accX.featurelessCopy()
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
        raw.applyInPlace { resample(data: $0, toSize: toSize) }
        if raw.checkEqualDimensions() == false {
            throw DimensionError.dimensionsNotEqual
        }
    }

    func dropEmptySamples() {
        raw.filter { $0.features.count == 0 }
    }

    func generateSignalLengths() {
        processed.append(other: raw.accX) { [Double($0.count)] }
    }

    func generateMean() {
        let result=raw.applyWindow(size: 20) { mean($0) }
        processed.append(other: result.flatten())
    }
    
    
    func generateMax() {
        let result=raw.applyWindow(size: 20) { max($0) }
        processed.append(other: result.flatten())
    }
    
    func generateMin() {
        let result=raw.applyWindow(size: 20) { min($0) }
        processed.append(other: result.flatten())
    }

    func generateFFT() {
        let frequency = raw.apply { fft($0) }
        let filtered = frequency.apply { Array($0.dropLast(50)) }
        processed.append(other: filtered.flatten())
    }

    enum DimensionError: Error {
        case dimensionsNotEqual
        case lengthsNotEqual
    }
}


