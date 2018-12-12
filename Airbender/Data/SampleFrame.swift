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

    func apply(fun: ([Double]) -> [Double]) {
        samples.forEach { $0.features = fun($0.features) }
    }

    func append(other: SampleFrame, fun: ([Double]) -> [Double]) {
        for (index, sample) in samples.enumerated() {
            sample.features.append(contentsOf: fun(other.samples[index].features))
        }
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
