//
//  CSVExporter.swift
//  Airbender
//
//  Created by Robert Gstöttner on 28.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class CSVExporter {
    let accXWriter = FileWriter().using(file: "acc_x.csv")
    let accYWriter = FileWriter().using(file: "acc_y.csv")
    let accZWriter = FileWriter().using(file: "acc_z.csv")
    let gyrXWriter = FileWriter().using(file: "gyr_x.csv")
    let gyrYWriter = FileWriter().using(file: "gyr_y.csv")
    let gyrZWriter = FileWriter().using(file: "gyr_z.csv")


    func export(recording: LabeledRecording) -> Bool {
        let header = "\(recording.user);"
            + "\(recording.name);"

        var result = true
        let accXData = recording.data.map { String($0.accX) }.joined(separator: ";")
        result = accXWriter.writeLine(line: "\(header)\(accXData)") && result

        let accYData = recording.data.map { String($0.accY) }.joined(separator: ";")
        result = accYWriter.writeLine(line: "\(header)\(accYData)") && result

        let accZData = recording.data.map { String($0.accZ) }.joined(separator: ";")
        result = accZWriter.writeLine(line: "\(header)\(accZData)") && result

        let gyrXData = recording.data.map { String($0.gyroX) }.joined(separator: ";")
        result = gyrXWriter.writeLine(line: "\(header)\(gyrXData)") && result

        let gyrYData = recording.data.map { String($0.gyroY) }.joined(separator: ";")
        result = gyrYWriter.writeLine(line: "\(header)\(gyrYData)") && result

        let gyrZData = recording.data.map { String($0.gyroZ) }.joined(separator: ";")
        result = gyrZWriter.writeLine(line: "\(header)\(gyrZData)") && result

        return result
    }

}
