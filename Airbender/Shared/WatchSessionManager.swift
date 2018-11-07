//
//  WatchSessionManager.swift
//  Airbender
//
//  Created by Manuel Mühlschuster on 28.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol WatchSessionManagerDelegate {
    func managerDidReceiveMessage( message: [String : Any])
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    var delegate: WatchSessionManagerDelegate!
    
    private override init() {
        super.init()
    }
    
    public let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
        #if os(iOS)
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
        #elseif os(watchOS)
        return session
        #endif
    }
    
    func startSession() {
        session!.delegate = self
        session!.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ workoutSession: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ workoutSession: WCSession) {
        print("sessionDidDeactivate")
    }
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        delegate!.managerDidReceiveMessage(message: message)
    }
    
    func sendMessage(message: [String : Any]){
        session!.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }

}
