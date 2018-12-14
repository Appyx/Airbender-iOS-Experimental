//
//  MLClassifier.swift
//  Airbender
//
//  Created by Christopher Ebner on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation
import CoreML

class Classifier {
    let model = RandomForest()
    private let frame: SampleFrame
    
    init(frame: SampleFrame) {
        self.frame = frame
    }
    
    func predictGesture() -> Int{
        guard let input = try? MLMultiArray(shape:[1,132], dataType:MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        for (index, element) in frame.samples[0].features.enumerated() {
            input[index] = NSNumber(floatLiteral: element)
        }
        let model = RandomForest()
        guard let gestureDetectorOutput = try? model.prediction(input: input) else {
            fatalError("Unexpected runtime error. model.prediction")
        }
        return Int(gestureDetectorOutput.classLabel)
    }
}
