//
//  CSVExporter.swift
//  Airbender
//
//  Created by Robert Gstöttner on 28.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class CSVExporter {
    private let accXWriter: FileWriter
    private let accYWriter: FileWriter
    private let accZWriter: FileWriter
    private let gyrXWriter: FileWriter
    private let gyrYWriter: FileWriter
    private let gyrZWriter: FileWriter
    
    init(appending: Bool = true) {
        accXWriter = FileWriter(appending: appending).using(file: "acc_x.csv")
        accYWriter = FileWriter(appending: appending).using(file: "acc_y.csv")
        accZWriter = FileWriter(appending: appending).using(file: "acc_z.csv")
        gyrXWriter = FileWriter(appending: appending).using(file: "gyr_x.csv")
        gyrYWriter = FileWriter(appending: appending).using(file: "gyr_y.csv")
        gyrZWriter = FileWriter(appending: appending).using(file: "gyr_z.csv")
    }

    func exportCSVs(frame: DataFrame) throws {
        try accXWriter.writeLines(lines: frame.accX.samples.map { $0.csvString })
        try accYWriter.writeLines(lines: frame.accY.samples.map { $0.csvString })
        try accZWriter.writeLines(lines: frame.accZ.samples.map { $0.csvString })
        try gyrXWriter.writeLines(lines: frame.gyrX.samples.map { $0.csvString })
        try gyrYWriter.writeLines(lines: frame.gyrY.samples.map { $0.csvString })
        try gyrZWriter.writeLines(lines: frame.gyrZ.samples.map { $0.csvString })
    }
}
