//
//  AccelerometerProcessedData.swift
//  SensorRecordingApp
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation

class RawData {
    let timestamp: Int64
    
    let accX: Double
    let accY: Double
    let accZ: Double
    
    let gyrX: Double
    let gyrY: Double
    let gyrZ: Double
    
    init(timestamp: Int64, accX: Double, accY: Double, accZ: Double, gyroX: Double, gyroY: Double, gyroZ: Double) {
        self.timestamp = timestamp
        self.accX = accX
        self.accY = accY
        self.accZ = accZ
        self.gyrX = gyroX
        self.gyrY = gyroY
        self.gyrZ = gyroZ
    }
    
    init(copy: RawData) {
        self.timestamp = copy.timestamp
        self.accX = copy.accX
        self.accY = copy.accY
        self.accZ = copy.accZ
        self.gyrX = copy.gyrX
        self.gyrY = copy.gyrY
        self.gyrZ = copy.gyrZ
    }
    
    init(dict:[String: Any]) {
        self.timestamp = dict["timestamp"] as! Int64
        self.accX = dict["accX"] as! Double
        self.accY = dict["accY"] as! Double
        self.accZ = dict["accZ"] as! Double
        self.gyrX = dict["gyroX"] as! Double
        self.gyrY = dict["gyroY"] as! Double
        self.gyrZ = dict["gyroZ"] as! Double
    }
    
    public func toDictionary() -> [String: Any] {
        return ["timestamp": timestamp,
                "accX": accX,
                "accY": accY,
                "accZ": accZ,
                "gyroX": gyrX,
                "gyroY": gyrY,
                "gyroZ": gyrZ]
    }
    
   
    
   
}
