//
//  CSVImporter.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class CSVImporter {
    private let accXReader = FileReader().using(file: "acc_x.csv")
    private let accYReader = FileReader().using(file: "acc_y.csv")
    private let accZReader = FileReader().using(file: "acc_z.csv")
    private let gyrXReader = FileReader().using(file: "gyr_x.csv")
    private let gyrYReader = FileReader().using(file: "gyr_y.csv")
    private let gyrZReader = FileReader().using(file: "gyr_z.csv")

    func importCSVs() throws -> DataFrame {
        let frame = DataFrame()
        frame.accX.samples = try accXReader.readLines().map { s in Sample(csvString: s) }
        frame.accY.samples = try accYReader.readLines().map { s in Sample(csvString: s) }
        frame.accZ.samples = try accZReader.readLines().map { s in Sample(csvString: s) }
        frame.gyrX.samples = try gyrXReader.readLines().map { s in Sample(csvString: s) }
        frame.gyrY.samples = try gyrYReader.readLines().map { s in Sample(csvString: s) }
        frame.gyrZ.samples = try gyrZReader.readLines().map { s in Sample(csvString: s) }
        return frame
    }
}
