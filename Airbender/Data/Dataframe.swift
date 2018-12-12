//
//  Dataframe.swift
//  Airbender
//
//  Created by Robert Gstöttner on 11.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class Dataframe {
    var accX: [Sample] = []
    var accY: [Sample] = []
    var accZ: [Sample] = []
    var gyrX: [Sample] = []
    var gyrY: [Sample] = []
    var gyrZ: [Sample] = []

    func addRow(factors: Sample.Factors, rawData: [RawData]) {
        accX.append(Sample(factors: factors, features: rawData.compactMap { $0.accX }))
        accY.append(Sample(factors: factors, features: rawData.compactMap { $0.accY }))
        accZ.append(Sample(factors: factors, features: rawData.compactMap { $0.accZ }))
        gyrX.append(Sample(factors: factors, features: rawData.compactMap { $0.gyrX }))
        gyrY.append(Sample(factors: factors, features: rawData.compactMap { $0.gyrY }))
        gyrZ.append(Sample(factors: factors, features: rawData.compactMap { $0.gyrZ }))
    }

    func apply(fun: ([Double]) -> [Double]) {
        accX.forEach { $0.features = fun($0.features) }
        accY.forEach { $0.features = fun($0.features) }
        accZ.forEach { $0.features = fun($0.features) }
        gyrX.forEach { $0.features = fun($0.features) }
        gyrY.forEach { $0.features = fun($0.features) }
        gyrZ.forEach { $0.features = fun($0.features) }
    }

    func filterSamples(fun: (Sample) -> Bool) {
        accX.removeAll { fun($0) }
        accY.removeAll { fun($0) }
        accZ.removeAll { fun($0) }
        gyrX.removeAll { fun($0) }
        gyrY.removeAll { fun($0) }
        gyrZ.removeAll { fun($0) }
    }

}
