//
//  ProcessingEngine.swift
//  Airbender
//
//  Created by Robert Gstöttner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

protocol ProcessingEngineDelegate {
    func gestureDestected(gesture:Gesture)
}

class ProcessingEngine {
    static let shared = ProcessingEngine()
    
    let commManager = CommunicationManager.shared
    var buffer = [RawData]()
    var delegate:ProcessingEngineDelegate?=nil
    var lastDetected:Gesture?=nil
    
    private init() {
        commManager.delegate = self
        commManager.startSession()
    }
    
    func clear() {
        buffer.removeAll()
    }
    
    
    func gestureComplete(){
        let df=DataFrame()
        df.addSamples(factors: Sample.Factors(), rawData: buffer)
        let proc = try! Preprocessor(frame: df)
        
        try! proc.applyResampling(toSize: 50)
        proc.generateFrequencies(cutoff: 20)
        proc.generateMean(windowSize: 50)
        proc.generateMedian(windowSize: 50)
        
        let classifier=Classifier(frame: proc.processed)
        let gesture=classifier.predictGesture()
        
        let gestures=CoreGestures()
        lastDetected=gestures.get(id: gesture)
        DispatchQueue.main.sync {
            delegate?.gestureDestected(gesture: lastDetected!)
        }
    }
    
}

extension ProcessingEngine: CommunicationManagerDelegate {
    
    func managerDidReceiveMessage(message: Message) {
        if message.type == .Control && message.getText() == "start-gesture" {
            print("gesture started...")
            clear()
        }
        if message.type == .Control && message.getText() == "stop-gesture" {
            print("gesture stopped...")
            gestureComplete()
        }
        if message.type == .Data {
            if let data = message.getData() {
                buffer.append(data)
            }
        }
    }
}
