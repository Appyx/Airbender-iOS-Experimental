//
//  DeviceRowController.swift
//  Airbender WatchKit Extension
//
//  Created by Manuel Mühlschuster on 12.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
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
