//
//  GeneralDaframe.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation

class SampleFrame {
    var samples: [Sample] = []

    var factors: [Sample.Factors] {
        return samples.map { $0.factors }
    }

    func featurelessCopy() -> SampleFrame {
        let new = SampleFrame()
        new.samples = factors.map { Sample(factors: $0, features: []) }
        return new
    }
    
    func copy()->SampleFrame{
        let new = SampleFrame()
        samples.forEach{
            new.samples.append($0)
        }
        return new
    }

    func applyInPlace(fun: ([Double]) -> [Double]) {
        samples.forEach { $0.features = fun($0.features) }
    }
    
    func slidingWindow(size: Int, fun: ([Double]) -> Double)->SampleFrame { //TODO: export function
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
    
    func apply(fun: ([Double]) -> [Double])->SampleFrame {
        let temp=featurelessCopy()
        for (index, sample) in samples.enumerated() {
            temp.samples[index].features.append(contentsOf:fun(sample.features))
        }
        return temp
    }

    func append(other: SampleFrame, fun: ([Double]) -> [Double]) {
        //TODO: check for equal row count and col count
        for (index, sample) in samples.enumerated() {
            sample.features.append(contentsOf: fun(other.samples[index].features))
        }
    }

    func append(other: SampleFrame) {
        append(other: other, fun: { $0 })
    }

    func filter(fun: (Sample) -> Bool) { //TODO: rename
        samples.removeAll { fun($0) }
    }

    func add(sample: Sample) {
        samples.append(sample)
    }
}

enum SampleFrameError:Error{
    case indexOutOfBounds
}
