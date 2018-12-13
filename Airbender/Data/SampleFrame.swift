//
//  GeneralDaframe.swift
//  Airbender
//
//  Created by Robert Gstöttner on 12.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class SampleFrame {
    var samples: [Sample] = []

    var factors: [Sample.Factors] {
        return samples.map { $0.factors }
    }

    func featurelessCopy() -> SampleFrame {
        let frame = SampleFrame()
        frame.samples = factors.map { Sample(factors: $0, features: []) }
        return frame
    }
    
    func copy()->SampleFrame{
        let frame = featurelessCopy()
        frame.append(other: self)
        return frame
    }

    func applyInPlace(fun: ([Double]) -> [Double]) {
        samples.forEach { $0.features = fun($0.features) }
    }
    
    func slidingWindow(size: Int, fun: ([Double]) -> Double)->SampleFrame {
        let temp = featurelessCopy()
        temp.append(other: self) { features in
            var result: [Double] = []
            let windows = features.count / size
            for i in 0..<windows {
                let window = Array(features[i*size..<(i + 1)*size])
                result.append(fun(window))
            }
            return result
        }
        return temp
    }
    
    func removeFeatures(at indexes:[Int]) throws {
        let sorted=indexes.sorted(by: >)
        for sample in samples{
            if sample.features.count < sorted.first!{
                 throw SampleFrameError.indexOutOfBounds
            }else{
                for index in indexes {
                    sample.features.remove(at: index)
                }
            }
        }
    }

    func append(other: SampleFrame, fun: ([Double]) -> [Double]) {
        for (index, sample) in samples.enumerated() {
            sample.features.append(contentsOf: fun(other.samples[index].features))
        }
    }
    
    func apply(fun: ([Double]) -> [Double])->SampleFrame {
        let temp=featurelessCopy()
        for (index, sample) in samples.enumerated() {
            temp.samples[index].features.append(contentsOf:fun(sample.features))
        }
        return temp
    }

    func append(other: SampleFrame) {
        append(other: other, fun: { $0 })
    }

    func filter(fun: (Sample) -> Bool) {
        samples.removeAll { fun($0) }
    }

    func add(sample: Sample) {
        samples.append(sample)
    }
  
}

enum SampleFrameError:Error{
    case indexOutOfBounds
}
