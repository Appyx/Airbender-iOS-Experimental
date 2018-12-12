//
//  DevicesInterfaceController.swift
//  Airbender WatchKit Extension
//
//  Created by Manuel Mühlschuster on 12.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import WatchKit
import Foundation


class DevicesInterfaceController: WKInterfaceController {

    var devices = ["Televison", "MacBook", "Spotify", "Youtube"]
    
    @IBOutlet weak var devicesTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        devicesTable.setNumberOfRows(devices.count, withRowType: "DeviceRow")
        
        for index in 0..<devicesTable.numberOfRows {
            guard let controller = devicesTable.rowController(at: index) as? DeviceRowController else { continue }
            
            controller.device = devices[index]
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let device = devices[rowIndex]
        
        pushController(withName: "Control", context: device)
    }
}
