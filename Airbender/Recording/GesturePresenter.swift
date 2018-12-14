//
//  GestureManager.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation
import UIKit

class GesturePresenter {
    let participant: String
    let coreGestures: [Gesture]
    private var performingGestures: [Gesture] = []

    private var iteratorPos = 0

    init(participant: String, numberOfRecordings: Int) {
        self.participant = participant
        self.coreGestures=CoreGestures().gestures
        
        for _ in 1...numberOfRecordings {
            self.performingGestures.append(contentsOf: coreGestures)
        }
    }

    public func hasNext() -> Bool {
        return performingGestures.count > iteratorPos
    }

    public func next() -> Gesture {
        let returnGesture = performingGestures[iteratorPos]
        iteratorPos += 1
        return returnGesture
    }

    // TODO: add different radomize functions, number of recordings,....
}




