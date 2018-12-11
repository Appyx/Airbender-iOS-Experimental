//
//  StartViewController.swift
//  Airbender
//
//  Created by Christopher Ebner on 28.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController {
    @IBOutlet weak var gestureNameLabel: UILabel!
    @IBOutlet weak var gestureImageView: UIImageView!
    @IBOutlet weak var gestureDescriptionLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!

    var presenter: GesturePresenter!
    var gestureID: Int = -1
    let engine=RecordingEngine()
    
    override func viewWillAppear(_ animated: Bool) {
        loadNextGesture()
        engine.startRecording()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        engine.stopRecording()
    }


    private func loadNextGesture() {
        if presenter.hasNext() {
            let actualGesture = presenter.next()
            gestureID = actualGesture.id
            gestureNameLabel.text = actualGesture.name
            gestureImageView.image = actualGesture.image
            gestureDescriptionLabel.text = actualGesture.description
        } else {
            dismiss(animated: true, completion: nil)
            engine.export()
        }
    }

    private func presentRetryAlert() {
        let alert = UIAlertController(title: "Gesture finished!", message: "Was the recording successful or do you want to retry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save Recording", style: .default, handler: { _ in
            self.engine.save(participant: self.presenter.participant, gesture: self.gestureID)
            self.loadNextGesture()
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { _ in
            self.engine.clear()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func presentCancelAlert() {
        let alert = UIAlertController(title: "Stop Recording Pressed!", message: "Do you really want to stop the whole recording?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stop", style: .default, handler: { _ in
            self.engine.stopRecording()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func cancelRecording(_ sender: Any) {
        presentCancelAlert()
    }
}


