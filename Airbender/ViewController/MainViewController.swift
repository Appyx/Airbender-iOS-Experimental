//
//  ViewController.swift
//  Airbender
//
//  Created by Manuel Mühlschuster on 25.10.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,WatchSessionManagerDelegate {
    func managerDidReceiveMessage(message: [String : Any]) {
        
    }
    
    @IBOutlet weak var participantIdTextField: UITextField!
    @IBOutlet weak var recordingsNoTextField: UITextField!
    @IBOutlet weak var randomizedGesturesSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        WatchSessionManager.shared.delegate=self
        WatchSessionManager.shared.startSession()

        
    }
    
    @IBAction func startRecording(_ sender: Any) {
        if WatchSessionManager.shared.session!.isReachable {
            WatchSessionManager.shared.session!.sendMessage(["control": "start"], replyHandler: nil, errorHandler: nil)
            guard let name=participantIdTextField.text else{return}
            if let number = Int(recordingsNoTextField.text ?? "1"){
                let manger=GestureManager(participant: name,numberOfRecordings: number)
                performSegue(withIdentifier: "GestureControllerSegue", sender: manger)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! GestureViewController
        vc.gestureManager=sender as? GestureManager
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}


