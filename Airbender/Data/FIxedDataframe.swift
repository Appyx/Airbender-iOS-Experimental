//
//  FeatureFrame.swift
//  Airbender
//
//  Created by Robert Gstöttner on 12.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class FixedDataframe: Dataframe {

    init(dataframe: Dataframe) throws {
        if FixedDataframe.checkDimensions(df: dataframe) == false {
            throw FixedDataframeError.dimensionsWrong
        }
        super.init()
        self.accX = dataframe.accX
        self.accY = dataframe.accY
        self.accZ = dataframe.accZ
        self.gyrX = dataframe.gyrX
        self.gyrY = dataframe.gyrY
        self.gyrZ = dataframe.gyrZ
    }

    private static func checkDimensions(df: Dataframe) -> Bool {
        var rowCounts: [Int] = []
        rowCounts.append(df.accX.count)
        rowCounts.append(df.accY.count)
        rowCounts.append(df.accZ.count)
        rowCounts.append(df.gyrX.count)
        rowCounts.append(df.gyrY.count)
        rowCounts.append(df.gyrZ.count)

        var colCounts: [Int] = []
        colCounts.append(contentsOf: df.accX.map { $0.length })
        colCounts.append(contentsOf: df.accY.map { $0.length })
        colCounts.append(contentsOf: df.accZ.map { $0.length })
        colCounts.append(contentsOf: df.gyrX.map { $0.length })
        colCounts.append(contentsOf: df.gyrY.map { $0.length })
        colCounts.append(contentsOf: df.gyrZ.map { $0.length })

        return allEqual(arr: rowCounts) && allEqual(arr: colCounts)
    }

    private static func allEqual(arr: [Int]) -> Bool {
        return arr.allSatisfy { $0 == arr.first }
    }

    func addCol(values: [Double]) {
        
    }
}

enum FixedDataframeError: Error {
    case dimensionsWrong
}
