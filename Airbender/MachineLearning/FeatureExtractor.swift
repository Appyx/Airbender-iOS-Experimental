//
//  FeatureExtractor.swift
//  Airbender
//
//  Created by Christopher Ebner on 14.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import Surge

class FeatureExtractor{
    private let input:DataFrame
    var processed: SampleFrame
    var featureInfo: [String] = []
    
    init(input: DataFrame) {
        self.input=input
        processed=input.featurelessCopy().flatten()
    }
    
    func generateSignalLengths() {
        featureInfo.append("SignalLength")
        processed.append(other: input.accX) { [Double($0.count)] }
    }
    
    func generateMean(windowSize: Int) {
        featureInfo.append("\(windowSize) times mean accX")
        featureInfo.append("\(windowSize) times mean accY")
        featureInfo.append("\(windowSize) times mean accZ")
        featureInfo.append("\(windowSize) times mean gyrX")
        featureInfo.append("\(windowSize) times mean gyrY")
        featureInfo.append("\(windowSize) times mean gyrZ")
        let result = input.applyWindow(size: windowSize) { mean($0) }
        processed.append(other: result.flatten())
    }
    
    func generateMax(windowSize: Int) {
        featureInfo.append("\(windowSize) times max accX")
        featureInfo.append("\(windowSize) times max accY")
        featureInfo.append("\(windowSize) times max accZ")
        featureInfo.append("\(windowSize) times max gyrX")
        featureInfo.append("\(windowSize) times max gyrY")
        featureInfo.append("\(windowSize) times max gyrZ")
        let result = input.applyWindow(size: windowSize) { max($0) }
        processed.append(other: result.flatten())
    }
    
    func generateMin(windowSize: Int) {
        featureInfo.append("\(windowSize) times min accX")
        featureInfo.append("\(windowSize) times min accY")
        featureInfo.append("\(windowSize) times min accZ")
        featureInfo.append("\(windowSize) times min gyrX")
        featureInfo.append("\(windowSize) times min gyrY")
        featureInfo.append("\(windowSize) times min gyrZ")
        let result = input.applyWindow(size: windowSize) { min($0) }
        processed.append(other: result.flatten())
    }
    
    func generateMedian(windowSize:Int) { //TODO: check math
        featureInfo.append("\(windowSize) times median accX")
        featureInfo.append("\(windowSize) times median accY")
        featureInfo.append("\(windowSize) times median accZ")
        featureInfo.append("\(windowSize) times median gyrX")
        featureInfo.append("\(windowSize) times median gyrY")
        featureInfo.append("\(windowSize) times median gyrZ")
        func median(_ input:[Double])->Double{
            let arr=input.sorted()
            let index=arr.count/2
            return arr[index]
        }
        let result = input.applyWindow(size: windowSize) {median($0)}
        processed.append(other: result.flatten())
    }
    
    func generateZeroCrossingRate() {  //TODO: check math
        featureInfo.append("zero-crossing-rate accX")
        featureInfo.append("zero-crossing-rate accY")
        featureInfo.append("zero-crossing-rate accZ")
        featureInfo.append("zero-crossing-rate gyrX")
        featureInfo.append("zero-crossing-rate gyrY")
        featureInfo.append("zero-crossing-rate gyrZ")
        let result = input.apply { arr in
            var counter = 0
            var high = true
            arr.forEach { it in
                if(high == true && it < 0) {
                    high = false
                    counter += 1
                }
                else if(high == false && it > 0) {
                    high = true
                    counter += 1
                }
            }
            return [Double(counter)]
        }
        processed.append(other: result.flatten())
    }
    
    
    func generateFrequencies(cutoff: Int) {  //TODO: check math
        let transformed = input.apply { fft($0) }
        var validRange = 0
        let filtered = transformed.apply {
            let step = 50 / $0.count
            validRange = cutoff / step
            let toDrop = $0.count - validRange - 1
            return Array($0.dropFirst().dropLast(toDrop)) }
        featureInfo.append("\(validRange) freqencies accX")
        featureInfo.append("\(validRange) freqencies accY")
        featureInfo.append("\(validRange) freqencies accZ")
        featureInfo.append("\(validRange) freqencies gyrX")
        featureInfo.append("\(validRange) freqencies gyrY")
        featureInfo.append("\(validRange) freqencies gyrZ")
        
        processed.append(other: filtered.flatten())
    }
    
    
}
