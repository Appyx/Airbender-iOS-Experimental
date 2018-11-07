//
//  InterfaceController.swift
//  Airbender WatchKit Extension
//
//  Created by Manuel Mühlschuster on 25.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import HealthKit

class InterfaceController: WKInterfaceController,HKWorkoutSessionDelegate {
    
    let motionManager = MotionManager()
    let connectivityManager = WatchSessionManager.shared
    var workoutSession:HKWorkoutSession?=nil
    let healthStore=HKHealthStore()
    var workItem: DispatchWorkItem?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        connectivityManager.delegate=self
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .indoor
        workoutSession = try? HKWorkoutSession(healthStore: healthStore,configuration: configuration)
        if let session=workoutSession {
            session.delegate = self
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        motionManager.delegate = self
        connectivityManager.startSession()
        print(connectivityManager.session?.isReachable)
        
        
        //        workItem?.cancel()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        //        workItem = DispatchWorkItem {
        //            self.workoutSession!.end()
        //            self.workoutSession!.stopActivity(with: Date())
        //            self.motionManager.stopMotionUpdates()
        //        }
        //
        //        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: workItem!)
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
}

extension InterfaceController: MotionManagerDelegate {
    func motionManager(_ manager: MotionManager, didUpdateMotionData data: CMDeviceMotion) {
        
        let rawData = RawData(timestamp: Int64((data.timestamp*1000.0).rounded()),
                              accX: data.userAcceleration.x,
                              accY: data.userAcceleration.y,
                              accZ: data.userAcceleration.z,
                              gyroX: data.rotationRate.x,
                              gyroY: data.rotationRate.y,
                              gyroZ: data.rotationRate.z)
        print(rawData.timestamp)
        connectivityManager.sendMessage(message: rawData.toDictionary())
    }
}

extension InterfaceController: WatchSessionManagerDelegate {
    func managerDidReceiveMessage(message: [String : Any]) {
        if let msg = message["control"] as? String, msg == "stop" {
            self.workoutSession!.end()
            self.workoutSession!.stopActivity(with: Date())
            self.motionManager.stopMotionUpdates()
        } else if let msg = message["control"] as? String, msg == "start" {
           
            motionManager.startMotionUpdates()
            workoutSession!.startActivity(with: Date())
        }
    }
    
    
}

extension Date {
    var secondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970*1.0).rounded())
    }
    
    init(seconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
}



