//
//  CSVExporterBase.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
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
