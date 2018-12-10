//
//  ProcessingEngine.swift
//  Airbender
//
//  Created by Robert Gstöttner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class ProcessingEngine {
    
    let commManager = CommunicationManager.shared
    var buffer = [RawData]()
    
    init() {
        commManager.delegate = self
        commManager.startSession()
    }
    
    func clear() {
        buffer.removeAll()
    }
    
    
    func gestureComplete(){
        //do something with recorded data
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
