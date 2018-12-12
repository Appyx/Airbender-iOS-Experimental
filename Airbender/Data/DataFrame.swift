//
//  Dataframe.swift
//  Airbender
//
//  Created by Robert Gstöttner on 11.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class DataFrame {
    var accX = SampleFrame()
    var accY = SampleFrame()
    var accZ = SampleFrame()
    var gyrX = SampleFrame()
    var gyrY = SampleFrame()
    var gyrZ = SampleFrame()

    func addSamples(factors: Sample.Factors, rawData: [RawData]) {
        accX.append(Sample(factors: factors, features: rawData.compactMap { $0.accX }))
        accY.append(Sample(factors: factors, features: rawData.compactMap { $0.accY }))
        accZ.append(Sample(factors: factors, features: rawData.compactMap { $0.accZ }))
        gyrX.append(Sample(factors: factors, features: rawData.compactMap { $0.gyrX }))
        gyrY.append(Sample(factors: factors, features: rawData.compactMap { $0.gyrY }))
        gyrZ.append(Sample(factors: factors, features: rawData.compactMap { $0.gyrZ }))
    }

    func apply(fun: ([Double]) -> [Double]) {
        accX.apply(fun: fun)
        accY.apply(fun: fun)
        accZ.apply(fun: fun)
        gyrX.apply(fun: fun)
        gyrY.apply(fun: fun)
        gyrZ.apply(fun: fun)
    }

    func crossApply(target: DataFrame, fun: ([Double]) -> [Double]) {
        accX.crossApply(target: target.accX, fun: fun)
        accY.crossApply(target: target.accY, fun: fun)
        accZ.crossApply(target: target.accZ, fun: fun)
        gyrX.crossApply(target: target.gyrX, fun: fun)
        gyrY.crossApply(target: target.gyrY, fun: fun)
        gyrZ.crossApply(target: target.gyrZ, fun: fun)

    }

    func featurelessCopy() -> DataFrame {
        let frame = DataFrame()
        frame.accX = accX.featurelessCopy()
        frame.accY = accY.featurelessCopy()
        frame.accZ = accZ.featurelessCopy()
        frame.gyrX = gyrX.featurelessCopy()
        frame.gyrY = gyrY.featurelessCopy()
        frame.gyrZ = gyrZ.featurelessCopy()
        return frame
    }

    func filter(fun: (Sample) -> Bool) {
        accX.filter(fun: fun)
        accY.filter(fun: fun)
        accZ.filter(fun: fun)
        gyrX.filter(fun: fun)
        gyrY.filter(fun: fun)
        gyrZ.filter(fun: fun)
    }

    func checkEqualDimensions() -> Bool {
        var rowCounts: [Int] = []
        rowCounts.append(accX.samples.count)
        rowCounts.append(accY.samples.count)
        rowCounts.append(accZ.samples.count)
        rowCounts.append(gyrX.samples.count)
        rowCounts.append(gyrY.samples.count)
        rowCounts.append(gyrZ.samples.count)

        var colCounts: [Int] = []
        colCounts.append(contentsOf: accX.samples.map { $0.length })
        colCounts.append(contentsOf: accY.samples.map { $0.length })
        colCounts.append(contentsOf: accZ.samples.map { $0.length })
        colCounts.append(contentsOf: gyrX.samples.map { $0.length })
        colCounts.append(contentsOf: gyrY.samples.map { $0.length })
        colCounts.append(contentsOf: gyrZ.samples.map { $0.length })

        func allEqual(arr: [Int]) -> Bool {
            return arr.allSatisfy { $0 == arr.first }
        }

        return allEqual(arr: rowCounts) && allEqual(arr: colCounts)
    }

    func checkSampleLengths() -> Bool {
        let accXLengths = accX.samples.map { $0.features.count }
        let accYLengths = accY.samples.map { $0.features.count }
        let accZLengths = accZ.samples.map { $0.features.count }
        let gyrXLengths = gyrX.samples.map { $0.features.count }
        let gyrYLengths = gyrY.samples.map { $0.features.count }
        let gyrZLengths = gyrZ.samples.map { $0.features.count }

        return accXLengths == accYLengths &&
            accYLengths == accZLengths &&
            accZLengths == gyrXLengths &&
            gyrXLengths == gyrYLengths &&
            gyrYLengths == gyrZLengths
    }

}
