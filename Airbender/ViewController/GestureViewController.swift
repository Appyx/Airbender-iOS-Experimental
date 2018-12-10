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

    let commManager = CommunicationManager.shared
    var recordedData = [RawData]()
    var gestureManager: GesturePresenter!
    var exporter: CSVExporter!
    var actualGestureID: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        commManager.delegate = self
        commManager.startSession()
        exporter = CSVExporter()
        startRecording()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadNextGesture()
    }

    func startRecording() {
        commManager.send(message: Message(type: .Control).with(text: "start-recording"))
    }

    func stopRecording() {
        commManager.send(message: Message(type: .Control).with(text: "stop-recording"))
    }

    private func saveGesture() {
        if let id = actualGestureID {
            let data = Sample(user: gestureManager.participant, gesture: id, rawData: recordedData)
            print("exported: \(exporter.export(recording: data))")
        }
    }

    private func loadNextGesture() {
        if gestureManager.hasNext() {
            let actualGesture = gestureManager.next()
            actualGestureID = actualGesture.id
            gestureNameLabel.text = actualGesture.name
            gestureImageView.image = actualGesture.image
            gestureDescriptionLabel.text = actualGesture.description
        } else {
            stopRecording()
            dismiss(animated: true, completion: nil)
        }
    }

    private func presentRetryAlert() {
        let alert = UIAlertController(title: "Gesture finished!", message: "Was the recording successful or do you want to retry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save Recording", style: .default, handler: { _ in
            self.saveGesture()
            self.loadNextGesture()
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { _ in
            self.recordedData = []
        }))
        present(alert, animated: true, completion: nil)
    }

    private func presentCancelAlert() {
        let alert = UIAlertController(title: "Stop Recording Pressed!", message: "Do you really want to stop the whole recording?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stop", style: .default, handler: { _ in
            self.stopRecording()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func cancelRecording(_ sender: Any) {
        presentCancelAlert()
    }
}

extension GestureViewController: CommunicationManagerDelegate {

    func managerDidReceiveMessage(message: Message) {
        if message.type == .Control && message.getText() == "start-gesture" {
            print("gesture started...")
        }
        if message.type == .Control && message.getText() == "stop-gesture" {
            print("gesture stopped...")
            presentRetryAlert()
        }
        if message.type == .Data {
            if let data = message.getData() {
                recordedData.append(data)
            }
        }
    }
}


