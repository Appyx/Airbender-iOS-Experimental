//
//  WatchSessionManager.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol CommunicationManagerDelegate {
    func managerDidReceiveMessage(message: Message)
}

class CommunicationManager: NSObject, WCSessionDelegate {
    static let shared = CommunicationManager()
    var delegate: CommunicationManagerDelegate?

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
        session?.delegate = self
        session?.activate()
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

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let msg = Message(dict: message) {
            delegate?.managerDidReceiveMessage(message: msg)
        }

    }

    func send(message: Message) {
        session?.sendMessage(message.toDictionary(), replyHandler: nil, errorHandler: nil)
    }

}
