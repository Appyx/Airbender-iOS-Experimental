//
//  HomeViewController.swift
//  Airbender
//
//  Created by Manuel Mühlschuster on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var gestureNameLabel: UILabel!
    @IBOutlet weak var gestureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        // used for dissmissing info view controller
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
