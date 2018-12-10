//
//  HistoryTableViewController.swift
//  Airbender
//
//  Created by Manuel Mühlschuster on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var gestures = [Gesture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestures.append(Gesture(id: 1,
                                name: "Wristbreaker",
                                image: nil,
                                description: "Injuries occur pretty sure"))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gestures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell",
                                                       for: indexPath) as? HistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of HistoryTableViewCell.")
        }
        
        let gesture = gestures[indexPath.row]
        
        cell.historyNameLabel.text = gesture.name
        cell.dateLabel.text = "00"

        return cell
    }
}
