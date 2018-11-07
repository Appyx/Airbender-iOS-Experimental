//
//  MotionManager.swift
//  Airbender
//
//  Created by Manuel Mühlschuster on 25.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionManagerDelegate {
    func motionManager(_ manager: MotionManager, didUpdateMotionData data: CMDeviceMotion)
}

class MotionManager {
    
    var delegate: MotionManagerDelegate?
    
    private let manager = CMMotionManager()
    private let queue = OperationQueue()
    
    // 50 Hz
    private let sampleInterval = 1.0 / 50
    
    init() {
        queue.name = "MotionManagerQueue"
    }
    
    func startMotionUpdates() {
        if !manager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        manager.deviceMotionUpdateInterval = sampleInterval
        manager.startDeviceMotionUpdates(to: queue) { (data, error) in
            guard let data = data else { return }
            
            self.delegate?.motionManager(self, didUpdateMotionData: data)
        }
    }
    
    func stopMotionUpdates() {
        if manager.isDeviceMotionAvailable {
            manager.stopDeviceMotionUpdates()
        }
    }   
}
