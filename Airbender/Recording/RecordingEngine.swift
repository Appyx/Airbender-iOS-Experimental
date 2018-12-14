//
//  ProcessingEngine.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation

protocol RecordingEngineDelegate {
    func gestureComplete()
}

class RecordingEngine {
    private let commManager = CommunicationManager.shared
    private var recordedData = [RawData]()
    private let frame = DataFrame()
    var delegate:RecordingEngineDelegate?=nil

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
        let exporter = CSVExporter(appending: false)
        do {
            try exporter.exportCSVs(frame: frame)
        } catch {
            print(error)
        }
    }

    func save(participant: String, gesture: Int) {
        let factors=Sample.Factors(user:participant,gesture:gesture)
        frame.addSamples(factors: factors, rawData: recordedData)
        export()
    }
}

extension RecordingEngine: CommunicationManagerDelegate {

    func managerDidReceiveMessage(message: Message) {
        if message.type == .Control && message.getText() == "start-gesture" {
            clear()
            print("gesture started...")
        }
        if message.type == .Control && message.getText() == "stop-gesture" {
            delegate?.gestureComplete()
            print("gesture stopped...")
        }
        if message.type == .Data {
            if let data = message.getData() {
                recordedData.append(data)
            }
        }
    }
}
