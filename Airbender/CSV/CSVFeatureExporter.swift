//
//  CSVExporterBase.swift
//  Airbender
//
//  Created by Robert Gstöttner on 14.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class CSVFeatureExporter {
       private let writer: FileWriter
    
    init(appending: Bool = true) {
        writer = FileWriter(appending: appending).using(file: "features.csv")
    }
    
    func exportCSV(frame: SampleFrame) throws {
        try writer.writeLines(lines: frame.samples.map { $0.csvString })
    }
}
