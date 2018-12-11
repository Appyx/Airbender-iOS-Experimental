//
//  MLPreProcessor.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import Accelerate

class PreProcessor {

    var frame: Dataframe

    init(frame: Dataframe) {
        self.frame = frame
    }

    func resample(toSize: Int) {
        frame.apply{resample(data: $0, toSize: toSize)}
    }

    private func resample(data: [Double], toSize: Int) -> [Double] {
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

        print("resampled to size: \(sampledData.count)")
        return sampledData
    }

    func dropEmptySamples(){
        frame.filterSamples{$0.features.count == 0}
    }
}

