//
//  StartViewController.swift
//  Airbender
//
//  Created by Christopher Ebner on 28.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController, WatchSessionManagerDelegate {
    @IBOutlet weak var gestureNameLabel: UILabel!
    @IBOutlet weak var gestureImageView: UIImageView!
    @IBOutlet weak var gestureDescriptionLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!

    var gestureIsRecoring = false

    let connectivityManager = WatchSessionManager.shared

    var gestureManager: GestureManager!
    var exporter: CSVExporter!
    var actualGestureID: Int? = nil

    var recordedData = [RawData]()
    var lastRecordedGesture = [RawData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        connectivityManager.delegate = self
        connectivityManager.startSession()
        exporter = CSVExporter()
        startRecording()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadNextGesture()

    }


    @IBAction func StartStopButtonPressed(_ sender: UIButton) {
        gestureIsRecoring = !gestureIsRecoring
        if gestureIsRecoring {
            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            sender.setTitle("Stop Gesture", for: .normal)
            startGestureRecording()
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            sender.setTitle("Start Gesture", for: .normal)
            lastRecordedGesture = recordedData
            presentRetryAlert()
        }
    }

    func startRecording() {
    }

    private func startGestureRecording() {
        recordedData.removeAll()
    }

    private func retryRecording() {
        recordedData.removeAll()
    }

    private func saveRecordedGesture() {
        if let id = actualGestureID {
            let data = LabeledRecording(user: gestureManager.participant, gesture: id, rawData: lastRecordedGesture)
            print("exported: \(exporter.export(recording: data))")
        }
    }

    private func recordingFinished() {
        connectivityManager.session?.sendMessage(["control": "stop"], replyHandler: nil, errorHandler: nil)
    }

    private func recordingCancled() {
        connectivityManager.session?.sendMessage(["control": "stop"], replyHandler: nil, errorHandler: nil)
    }

    private func loadNextGesture() {
        if gestureManager.hasNext() {
            let actualGesture = gestureManager.next()
            actualGestureID = actualGesture.id
            gestureNameLabel.text = actualGesture.name
            gestureImageView.image = actualGesture.image
            gestureDescriptionLabel.text = actualGesture.description
        } else {
            recordingFinished()
            dismiss(animated: true, completion: nil)
        }
    }



    private func presentRetryAlert() {
        let alert = UIAlertController(title: "Gesture finished!", message: "Was the recording successful or do you want to retry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save Recording", style: .default, handler: { _ in
            self.saveRecordedGesture()
            self.loadNextGesture()
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { _ in
            self.retryRecording()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func presentRCancelAlert() {
        let alert = UIAlertController(title: "Stop Recording Pressed!", message: "Do you really want to Stop the whole recording?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stop and go back", style: .default, handler: { _ in
            self.recordingCancled()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Resume the Recording", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    @IBAction func cancelRecordingPressed(_ sender: Any) {
        presentRCancelAlert()
    }

    func managerDidReceiveMessage(message: [String: Any]) {
        recordedData.append(RawData(dict: message))
    }
}


