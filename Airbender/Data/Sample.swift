//
//  LabeledRawData.swift
//  Airbender
//
//  Created by Christopher Ebner on 27.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class Sample{
    var user: String
    var name: Int
    var data: [RawData]
    
    init(user: String, gesture: Int, rawData: [RawData]) {
        self.user = user
        self.name = gesture
        self.data = rawData
    }
    
}
