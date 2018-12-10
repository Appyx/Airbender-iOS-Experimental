//
//  AccelerometerProcessedData.swift
//  SensorRecordingApp
//
//  Created by Christopher Ebner on 22.08.18.
//  Copyright © 2018 appyx. All rights reserved.
//

import Foundation

class RawData {
    let timestamp: Int64
    
    let accX: Double
    let accY: Double
    let accZ: Double
    
    let gyroX: Double
    let gyroY: Double
    let gyroZ: Double
    
    init(timestamp: Int64, accX: Double, accY: Double, accZ: Double, gyroX: Double, gyroY: Double, gyroZ: Double) {
        self.timestamp = timestamp
        self.accX = accX
        self.accY = accY
        self.accZ = accZ
        self.gyroX = gyroX
        self.gyroY = gyroY
        self.gyroZ = gyroZ
    }
    
    init(copy: RawData) {
        self.timestamp = copy.timestamp
        self.accX = copy.accX
        self.accY = copy.accY
        self.accZ = copy.accZ
        self.gyroX = copy.gyroX
        self.gyroY = copy.gyroY
        self.gyroZ = copy.gyroZ
    }
    
    init(dict:[String: Any]) {
        self.timestamp = dict["timestamp"] as! Int64
        self.accX = dict["accX"] as! Double
        self.accY = dict["accY"] as! Double
        self.accZ = dict["accZ"] as! Double
        self.gyroX = dict["gyroX"] as! Double
        self.gyroY = dict["gyroY"] as! Double
        self.gyroZ = dict["gyroZ"] as! Double
    }
    
    public func toDictionary() -> [String: Any] {
        return ["timestamp": timestamp,
                "accX": accX,
                "accY": accY,
                "accZ": accZ,
                "gyroX": gyroX,
                "gyroY": gyroY,
                "gyroZ": gyroZ]
    }
    
    // MARK: CSV
    class var CSV_HEADER: String {
       return "timestamp,accX,accY,accZ,gyroX,gyroY,gyroZ"
    }
    
    var csvString: String {
        return "\(timestamp),\(accX),\(accY),\(accZ),\(gyroX),\(gyroY),\(gyroZ)"
    }
}

//extension Encodable {
//    subscript(key: String) -> Any? {
//        return dictionary[key]
//    }
//    var dictionary: [String: Any] {
//        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
//    }
//}
