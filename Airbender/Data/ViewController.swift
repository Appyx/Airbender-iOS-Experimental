//
//  ViewController.swift
//  SensorRecordingApp
//
//  Created by Christopher Ebner on 20.08.18.
//  Copyright © 2018 appyx. All rights reserved.
//

import UIKit
import CoreMotion
import CloudKit

class ViewController: UIViewController {
    let testInterval = 1.0
    
    var recordingsPath: URL!
    var accRawPath: URL!
    var gyroRawPath: URL!
    var magRawPath: URL!
    var altiRawPath: URL!
    var attiProcessedPath: URL!
    var accProcessedPath: URL!
    var gyroProcessedPath: URL!
    var magProcessedPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHeaderFiles()
        
        motionManager = CMMotionManager()
        altimeter = CMAltimeter()
        pedometer = CMPedometer()
    }
    
    func createHeaderFiles() {
        // create target directory
        let fileManager = FileManager.default
        
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        recordingsPath = documentDirectory.appendingPathComponent("SensorRecordings")
        
        if !fileManager.fileExists(atPath: recordingsPath.path) {
            do {
                try fileManager.createDirectory(atPath: recordingsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        
        // create all files with header
        accRawPath = recordingsPath.appendingPathComponent(String(describing: AccelerometerRawData.self) + ".csv")
        gyroRawPath = recordingsPath.appendingPathComponent(String(describing: GyroscopeRawData.self) + ".csv")
        magRawPath = recordingsPath.appendingPathComponent(String(describing: MagnetometerRawData.self) + ".csv")
        altiRawPath = recordingsPath.appendingPathComponent(String(describing: AltitudeRawData.self) + ".csv")
        attiProcessedPath = recordingsPath.appendingPathComponent(String(describing: AttitudeProcessedData.self) + ".csv")
        accProcessedPath = recordingsPath.appendingPathComponent(String(describing: AccelerometerProcessedData.self) + ".csv")
        gyroProcessedPath = recordingsPath.appendingPathComponent(String(describing: GyroscopeProcessedData.self) + ".csv")
        magProcessedPath = recordingsPath.appendingPathComponent(String(describing: MagnetometerProcessedData.self) + ".csv")
        
        do {
            try AccelerometerRawData.getCSVHeaderString().write(to: accRawPath, atomically: false, encoding: .utf8)
            try GyroscopeRawData.getCSVHeaderString().write(to: gyroRawPath, atomically: false, encoding: .utf8)
            try MagnetometerRawData.getCSVHeaderString().write(to: magRawPath, atomically: false, encoding: .utf8)
            try AltitudeRawData.getCSVHeaderString().write(to: altiRawPath, atomically: false, encoding: .utf8)
            try AttitudeProcessedData.getCSVHeaderString().write(to: attiProcessedPath, atomically: false, encoding: .utf8)
            try AccelerometerProcessedData.getCSVHeaderString().write(to: accProcessedPath, atomically: false, encoding: .utf8)
            try GyroscopeProcessedData.getCSVHeaderString().write(to: gyroProcessedPath, atomically: false, encoding: .utf8)
            try MagnetometerProcessedData.getCSVHeaderString().write(to: magProcessedPath, atomically: false, encoding: .utf8)
        } catch {
            NSLog("Couldn't create csv file with header content")
        }
        
        write(to: altiRawPath, text: AltitudeRawData.getCSVHeaderString())
        write(to: altiRawPath, text: AltitudeRawData.getCSVHeaderString())
        write(to: altiRawPath, text: AltitudeRawData.getCSVHeaderString())
        
        write(to: magRawPath, text: MagnetometerRawData.getCSVHeaderString())
        
        
        
        // check if the files are there
        let recordingContents = try? fileManager.contentsOfDirectory(at: recordingsPath, includingPropertiesForKeys: nil, options: [])
        let file1 = fileManager.contents(atPath: recordingContents!.first!.path)
        let string1 = String(data: file1!, encoding: String.Encoding.utf8) as String!
        let file2 = fileManager.contents(atPath: recordingContents!.last!.path)
        let string2 = String(data: file2!, encoding: String.Encoding.utf8) as String!
        print(recordingContents?.count)
        
    }
    
    
    
    func write(to fileURL: URL, text: String) {
        if let outputStream = OutputStream(url: fileURL, append: true) {
            outputStream.open()
            let bytesWritten = outputStream.write(text)
            if bytesWritten < 0 { print("write failure") }
            outputStream.close()
        } else {
            print("Unable to open file")
        }
    }
    
    @IBAction func startRecordingPressed(_ sender: Any) {
        startAllSensorRecordings()
    }
    
    @IBAction func stopRecordingPressed(_ sender: Any) {
        stopAllSensorRecordings()
    }
    
    @IBAction func exportFilesPressed(_ sender: Any) {
        
    }
    
    private func startAllSensorRecordings() {
        startAccelerometer()
        startGyroscope()
        startMagnetometer()
        startAltimeter()
        startDeviceMotion()
        //        startPedometer()
    }
    
    private func stopAllSensorRecordings() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        altimeter.stopRelativeAltitudeUpdates()
        //        pedometer.stopUpdates()
    }
    
    // MARK: Raw Sensor Data
    var motionManager: CMMotionManager!
    
    func startAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 1.0 / testInterval
            
            // TODO: own queue!
            self.motionManager.startAccelerometerUpdates( to: .main, withHandler: { (data, error) in
                if let validData = data {
                    let accData = AccelerometerRawData(
                        timestamp: validData.timestamp,
                        x: validData.acceleration.x,
                        y: validData.acceleration.y,
                        z: validData.acceleration.z
                    )
                    self.write(to: self.accRawPath, text: accData.getCSVString())
                    print(accData.getCSVString())
                }
            })
        }
    }
    
    func startGyroscope() {
        if motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = 1.0 / testInterval
            
            // TODO: own queue!
            self.motionManager.startGyroUpdates( to: .main, withHandler: { (data, error) in
                if let validData = data {
                    let gyroData = GyroscopeRawData(
                        timestamp: validData.timestamp,
                        x: validData.rotationRate.x,
                        y: validData.rotationRate.y,
                        z: validData.rotationRate.z
                    )
                    print(gyroData.getCSVString())
                }
            })
        }
    }
    
    func startMagnetometer() {
        if motionManager.isMagnetometerAvailable {
            self.motionManager.magnetometerUpdateInterval = 1.0 / testInterval
            
            // TODO: own queue!
            self.motionManager.startMagnetometerUpdates( to: .main, withHandler: { (data, error) in
                if let validData = data {
                    let magData = MagnetometerRawData(
                        timestamp: validData.timestamp,
                        x: validData.magneticField.x,
                        y: validData.magneticField.y,
                        z: validData.magneticField.z
                    )
                    print(magData.getCSVString())
                }
            })
        }
    }
    
    // MARK: Processed Sensor Data
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / testInterval
            self.motionManager.showsDeviceMovementDisplay = true // TODO: RESEARCH!
            
            // TODO: own queue!
            self.motionManager.startDeviceMotionUpdates(
                using: .xArbitraryCorrectedZVertical,
                to: .main, withHandler: { (data, error) in
                    
                    if let validData = data {
                        
                        let attData = AttitudeProcessedData(
                            timestamp: validData.timestamp,
                            roll: validData.attitude.roll,
                            pitch: validData.attitude.pitch,
                            yaw: validData.attitude.yaw,
                            rotationMatrix: validData.attitude.rotationMatrix,
                            quaternion: validData.attitude.quaternion
                        )
                        print(attData.getCSVString())
                        
                        let accProcessedData = AccelerometerProcessedData(
                            timestamp: validData.timestamp,
                            gravityX: validData.gravity.x,
                            gravityY: validData.gravity.y,
                            gravityZ: validData.gravity.z,
                            userAccX: validData.userAcceleration.x,
                            userAccY: validData.userAcceleration.y,
                            userAccZ: validData.userAcceleration.z
                        )
                        print(accProcessedData.getCSVString())
                        
                        let gyroProcessedData = GyroscopeProcessedData(
                            timestamp: validData.timestamp,
                            x: validData.rotationRate.x,
                            y: validData.rotationRate.y,
                            z: validData.rotationRate.z
                        )
                        print(gyroProcessedData.getCSVString())
                        
                        let magProcessedData = MagnetometerProcessedData(
                            timestamp: validData.timestamp,
                            x: validData.magneticField.field.x,
                            y: validData.magneticField.field.y,
                            z: validData.magneticField.field.z,
                            accuracy: CMMagneticFieldCalibrationAccuracy(rawValue: validData.magneticField.accuracy.rawValue).debugDescription
                        )
                        print(magProcessedData.getCSVString())
                    }
            })
        }
    }
    
    
    // MARK: Altimeter
    var altimeter: CMAltimeter!
    
    func startAltimeter() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            
            altimeter.startRelativeAltitudeUpdates(to: .main) { data, error in
                if let validData = data {
                    let altData = AltitudeRawData(
                        timestamp: validData.timestamp,
                        pressure: validData.pressure.doubleValue,
                        relativeAltitude: validData.relativeAltitude.doubleValue
                    )
                    print(altData.getCSVString())
                }
            }
        }
    }
    
    // MARK: Pedometer
    var pedometer: CMPedometer!
    
    //    func startPedometer() {
    //        pedometer.startUpdates(from: Date(), withHandler: { data, error in
    //            if let validData = data {
    //                let pedoData = PedometerData(
    //                    timestamp: 0, // TODO: how handle no timestamp?
    //                    startDate: Int64(validData.startDate.timeIntervalSince1970),
    //                    endDate: Int64(validData.endDate.timeIntervalSince1970),
    //                    numberOfSteps: validData.numberOfSteps.int64Value,
    //                    distance: validData.distance?.doubleValue,
    //                    averageActivePace: validData.averageActivePace?.doubleValue,
    //                    currentPace: validData.currentPace?.doubleValue,
    //                    currentCadence: validData.currentCadence?.doubleValue,
    //                    floorsAscended: validData.floorsAscended?.int64Value,
    //                    floorsDescended: validData.floorsDescended?.int64Value
    //                )
    //                print("\(pedoData.id) - \(Int(pedoData.timestamp) % 1000)")
    //            }
    //        })
    //    }
    
    
    // MARK: File Management
    
    //    private func setupFileStorage() {
    //        if let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
    //            if (!FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil)) {
    //                do {
    //                    try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
    //                } catch {
    //                    print("---CREATE DIR FAILED!")
    //                }
    //            }
    //        }
    //    }
    
}









