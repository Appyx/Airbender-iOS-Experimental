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
        accX.add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accX }))
        accY.add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accY }))
        accZ.add(sample: Sample(factors: factors, features: rawData.compactMap { $0.accZ }))
        gyrX.add(sample: Sample(factors: factors, features: rawData.compactMap { $0.gyrX }))
        gyrY.add(sample: Sample(factors: factors, features: rawData.compactMap { $0.gyrY }))
        gyrZ.add(sample: Sample(factors: factors, features: rawData.compactMap { $0.gyrZ }))
    }

    func apply(fun: ([Double]) -> [Double]) {
        accX.apply(fun: fun)
        accY.apply(fun: fun)
        accZ.apply(fun: fun)
        gyrX.apply(fun: fun)
        gyrY.apply(fun: fun)
        gyrZ.apply(fun: fun)
    }

    func append(other: DataFrame, fun: ([Double]) -> [Double]) {
        accX.append(other: other.accX, fun: fun)
        accY.append(other: other.accY, fun: fun)
        accZ.append(other: other.accZ, fun: fun)
        gyrX.append(other: other.gyrX, fun: fun)
        gyrY.append(other: other.gyrY, fun: fun)
        gyrZ.append(other: other.gyrZ, fun: fun)
    }
    func append(other: DataFrame) {
        accX.append(other: other.accX)
        accY.append(other: other.accY)
        accZ.append(other: other.accZ)
        gyrX.append(other: other.gyrX)
        gyrY.append(other: other.gyrY)
        gyrZ.append(other: other.gyrZ)
    }

    func flatten() -> SampleFrame {
        let temp = accX.featurelessCopy()
        temp.append(other: accX)
        temp.append(other: accY)
        temp.append(other: accZ)
        temp.append(other: gyrX)
        temp.append(other: gyrY)
        temp.append(other: gyrZ)
        return temp
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
    
    func copy() -> DataFrame {
        let frame = DataFrame()
        frame.accX = accX.copy()
        frame.accY = accY.copy()
        frame.accZ = accZ.copy()
        frame.gyrX = gyrX.copy()
        frame.gyrY = gyrY.copy()
        frame.gyrZ = gyrZ.copy()
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
