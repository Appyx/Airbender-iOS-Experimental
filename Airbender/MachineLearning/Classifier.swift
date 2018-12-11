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
//    let model = GestureDetector()
    private let featureData: [[Double]]
    
    init(featureData: [[Double]]) {
        self.featureData = featureData
    }
    
    func predictGesture() -> String{
//        guard let gestureDetectorOutput = try? model.prediction(data: featureData) else {
//            fatalError("Unexpected runtime error.")
//        }
//        let predictedGesture = gestureDetectorOutput.gesture
//
//        return gestureFormatter.string(for: predictedGesture)
        return ""
    }
}
