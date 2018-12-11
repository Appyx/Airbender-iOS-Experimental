//
//  ProcessingEngine.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class RecordingEngine {
    private let commManager = CommunicationManager.shared
    private var recordedData = [RawData]()
    private let frame = Dataframe()

    init() {
        commManager.delegate = self
        commManager.startSession()
    }

    func clear() {
        recordedData.removeAll()
    }

    func startRecording() {
        commManager.send(message: Message(type: .Control).with(text: "start-recording"))
    }

    func stopRecording() {
        commManager.send(message: Message(type: .Control).with(text: "stop-recording"))
    }

    func export() {
        let exporter = CSVExporter()
        do {
            try exporter.exportCSVs(frame: frame)
        } catch {
            print(error)
        }
    }

    func save(participant: String, gesture: Int) {
        frame.accX.append(Sample(user: participant, gesture: gesture, features: recordedData.compactMap { $0.accX }))
        frame.accY.append(Sample(user: participant, gesture: gesture, features: recordedData.compactMap { $0.accY }))
        frame.accZ.append(Sample(user: participant, gesture: gesture, features: recordedData.compactMap { $0.accZ }))
        frame.gyrX.append(Sample(user: participant, gesture: gesture, features: recordedData.compactMap { $0.gyrX }))
        frame.gyrY.append(Sample(user: participant, gesture: gesture, features: recordedData.compactMap { $0.gyrY }))
        frame.gyrZ.append(Sample(user: participant, gesture: gesture, features: recordedData.compactMap { $0.gyrZ }))
    }
}

extension RecordingEngine: CommunicationManagerDelegate {

    func managerDidReceiveMessage(message: Message) {
        if message.type == .Control && message.getText() == "start-gesture" {
            print("gesture started...")
        }
        if message.type == .Control && message.getText() == "stop-gesture" {
            print("gesture stopped...")
        }
        if message.type == .Data {
            if let data = message.getData() {
                recordedData.append(data)
            }
        }
    }
}
