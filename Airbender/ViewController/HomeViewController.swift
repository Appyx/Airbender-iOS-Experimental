//
//  HomeViewController.swift
//  Airbender
//
//  Created by Manuel Mühlschuster on 10.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import UIKit
import Surge
class HomeViewController: UIViewController {

    @IBOutlet weak var gestureNameLabel: UILabel!
    @IBOutlet weak var gestureImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let importer = CSVImporter()
//        let df = try! importer.importCSVs()
        
        
        
        
//        let proc = try! Preprocessor(frame: df)
//        proc.dropEmptySamples()
//        try! proc.resample(toSize: 100)
        
        
//        let dummy=DataFrame()
//        let data=RawData(timestamp: 0, accX: 1, accY: 2, accZ: 3, gyroX: 4, gyroY: 5, gyroZ: 6)
//        let arr=[data,data,data]
//        dummy.addSamples(factors: Sample.Factors(user: "bobs", gesture: 1), rawData: arr)
//        dummy.addSamples(factors: Sample.Factors(user: "gix", gesture: 2), rawData: arr)
//
//        let copied=dummy.copy()
//        copied.apply{$0.map{$0*$0}}
//        dummy.append(other: copied)
//        let slided=dummy.applyWindow(size: 3){mean($0)}
//        dummy.append(other: dummy.featurelessCopy())
//        dummy.featurelessCopy().append(other: dummy)
//        dummy.append(other: dummy, fun: {[Double($0.count)]})
//        let flat=dummy.flatten()
//        flat.append(other: flat){[Double($0.count)]}
//        try! flat.removeFeatures(at: [41])
        
        
        
        //let df2=proc.raw
        //let exporter = CSVExporter(appending: false)
        //try! exporter.exportCSVs(frame: df2)

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
