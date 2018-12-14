//
//  DeviceRowController.swift
//  Airbender WatchKit Extension
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import WatchKit

class DeviceRowController: NSObject {
    
    @IBOutlet var deviceLabel: WKInterfaceLabel!
    @IBOutlet var seperator: WKInterfaceSeparator!
    
    var device: String? {
        didSet {
            deviceLabel.setText(device)
        }
    }
}
