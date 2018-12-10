//
//  ProcessingEngine.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class RecordingEngine {
    let commManager = CommunicationManager.shared
    var recordedData = [RawData]()

    init() {
        commManager.delegate = self
        commManager.startSession()
    }
    
    func clear() {
        recordedData.removeAll()
    }
    
    func startRecording(){
        commManager.send(message: Message(type: .Control).with(text: "start-recording"))
    }
    
    func stopRecording(){
        commManager.send(message: Message(type: .Control).with(text: "stop-recording"))
    }
    
    func save(participant:String,gesture:Int){
        let data = Sample(user: participant, gesture: gesture, rawData: recordedData)
        let exporter=CSVExporter()
        print("exported: \(exporter.export(recording: data))")
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
