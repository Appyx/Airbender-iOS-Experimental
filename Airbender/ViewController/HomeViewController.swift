//
//  HomeViewController.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import UIKit
import Surge
class HomeViewController: UIViewController {

    @IBOutlet weak var gestureNameLabel: UILabel!
    @IBOutlet weak var gestureImageView: UIImageView!
    private let engine = ProcessingEngine.shared


    override func viewWillAppear(_ animated: Bool) {
        engine.delegate = self
        if let gesture = engine.lastDetected {
            setGesture(gesture: gesture)
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        engine.delegate = nil
    }

    // MARK: - Actions
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        // used for dissmissing info view controller
    }

    private func setGesture(gesture: Gesture) {
        gestureNameLabel.text = gesture.name
        gestureImageView.image = gesture.image
    }
}

extension HomeViewController: ProcessingEngineDelegate {
    func gestureDestected(gesture: Gesture) {
        setGesture(gesture: gesture)
    }
}
