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

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {

    let motionManager = MotionManager()
    let commSession = CommunicationManager.shared
    var workoutSession: HKWorkoutSession? = nil
    let healthStore = HKHealthStore()
    @IBOutlet weak var buttonBackground: WKInterfaceGroup!
    var isRecording = false

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        commSession.delegate = self
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        motionManager.delegate = self
        commSession.startSession()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {

    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }

    func createWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .indoor
        workoutSession = try? HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        workoutSession?.delegate = self
    }

    func startWorkout() {
        createWorkoutSession()
        workoutSession?.prepare()
        workoutSession?.startActivity(with: Date())
        buttonBackground.setBackgroundColor(UIColor.red)
    }

    func stopWorkout() {
        workoutSession?.stopActivity(with: Date())
        workoutSession?.end()
        buttonBackground.setBackgroundColor(UIColor.green)
    }

    func startGesture() {
        motionManager.startMotionUpdates()
        startWorkout()
        sendStart()
    }

    func stopGesture() {
        motionManager.stopMotionUpdates()
        stopWorkout()
        sendStop()
    }

    func sendStart() {
        let msg = Message(type: MessageType.Control).with(text: "start-gesture")
        commSession.send(message: msg)
    }

    func sendStop() {
        let msg = Message(type: MessageType.Control).with(text: "stop-gesture")
        commSession.send(message: msg)
    }

    @IBAction func buttonPressed() {
        isRecording = !isRecording
        if isRecording { //recording started
            startGesture()
        } else {
            stopGesture()
        }
    }
    func sendData(data: RawData) {
        let msg = Message(type: MessageType.Data).with(data: data)
        commSession.send(message: msg)
    }

}

extension InterfaceController: MotionManagerDelegate {
    func motionManager(_ manager: MotionManager, didUpdateMotionData data: CMDeviceMotion) {
        let rawData = RawData(timestamp: Int64((data.timestamp * 1000.0).rounded()),
                              accX: data.userAcceleration.x,
                              accY: data.userAcceleration.y,
                              accZ: data.userAcceleration.z,
                              gyroX: data.rotationRate.x,
                              gyroY: data.rotationRate.y,
                              gyroZ: data.rotationRate.z)
        sendData(data: rawData)
    }
}

extension InterfaceController: CommunicationManagerDelegate {
    func managerDidReceiveMessage(message: Message) {
        if message.type == .Control && message.getText() == "start-recording" {
            print("recording started")
        }
        if message.type == .Control && message.getText() == "stop-recording" {
            print("recording stopped")
            stopWorkout()
        }
    }
}





