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
    private let frame = DataFrame()

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
        let factors=Sample.Factors(user:participant,gesture:gesture)
        frame.addSamples(factors: factors, rawData: recordedData)
    }
}

extension RecordingEngine: CommunicationManagerDelegate {

    func managerDidReceiveMessage(message: Message) {
        if message.type == .Control && message.getText() == "start-gesture" {
            clear()
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
