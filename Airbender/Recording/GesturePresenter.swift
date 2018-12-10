//
//  GestureManager.swift
//  Airbender
//
//  Created by Christopher Ebner on 28.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import UIKit

class GesturePresenter {
    let participant: String
    private let coreGestures: [Gesture]
    private var performingGestures: [Gesture] = []

    private var iteratorPos = 0

    init(participant: String, numberOfRecordings: Int) {
        self.participant = participant

        let instruction1 = "1. Press Start Gesture.\n"
        let instruction2 = "2. Wake up your Apple Watch.\n"
        let instruction3 = "4. Press Stop Gesture."

        self.coreGestures = [
            Gesture(id: 0, name: "rotate", image: #imageLiteral(resourceName: "Gesture1"), description: "\(instruction1)\(instruction2)3. Rotate your wrist to the left and back.\n\(instruction3)"),
            Gesture(id: 1, name: "rotate2x", image: #imageLiteral(resourceName: "Gesture2"), description: "\(instruction1)\(instruction2)3. Rotate your wrist to the left and back two times.\n\(instruction3)"),
            Gesture(id: 2, name: "flickLeft", image: #imageLiteral(resourceName: "Gesture3"), description: "\(instruction1)\(instruction2)3. Move your hand to the left and back.\n\(instruction3)"),
            Gesture(id: 3, name: "flickRight", image: #imageLiteral(resourceName: "Gesture4"), description: "\(instruction1)\(instruction2)3. Move your hand to the right and back.\n\(instruction3)"),
            Gesture(id: 4, name: "flickUp", image: #imageLiteral(resourceName: "Gesture5"), description: "\(instruction1)\(instruction2)3. Move your hand up and back.\n\(instruction3)"),
            Gesture(id: 5, name: "flickDown", image: #imageLiteral(resourceName: "Gesture6"), description: "\(instruction1)\(instruction2)3. Move your hand down and back.\n\(instruction3)"),
            Gesture(id: 6, name: "circleCW", image: #imageLiteral(resourceName: "Gesture7"), description: "\(instruction1)\(instruction2)3. Draw a circle in front of you - clockwise.\n\(instruction3)"),
            Gesture(id: 7, name: "circleCCW", image: #imageLiteral(resourceName: "Gesture8"), description: "\(instruction1)\(instruction2)3. Draw a circle in front of you - counter-clockwise.\n\(instruction3)"),
            Gesture(id: 8, name: "clap", image: #imageLiteral(resourceName: "Gesture9"), description: "\(instruction1)\(instruction2)3. Clap with both hands one time.\n\(instruction3)"),
            Gesture(id: 9, name: "clap2x", image: #imageLiteral(resourceName: "Gesture10"), description: "\(instruction1)\(instruction2)3. Clap with both hands two times.\n\(instruction3)"),
            Gesture(id: 10, name: "imaginaryButton", image: #imageLiteral(resourceName: "Gesture11"), description: "\(instruction1)\(instruction2)3.Imagine a button in front of you - click hin once.\n\(instruction3)"),
            Gesture(id: 11, name: "checkmark", image: #imageLiteral(resourceName: "Gesture12"), description: "\(instruction1)\(instruction2)3. Draw a ckeckmark to the left.\n\(instruction3)")
        ]

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
    
    class Gesture {
        let id: Int
        let name: String
        let image: UIImage
        let description: String
        
        init(id: Int, name: String, image: UIImage, description: String) {
            self.id = id
            self.name = name
            self.image = image
            self.description = description
        }
    }
}




