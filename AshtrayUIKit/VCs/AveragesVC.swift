//
//  AveragesViewController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import UIKit

class AveragesViewController: UIViewController {

//outlets
    @IBOutlet weak var dDescL: UILabel!
    @IBOutlet weak var wDescL: UILabel!
    @IBOutlet weak var mDescL: UILabel!
    @IBOutlet weak var hDescL: UILabel!
    
    @IBOutlet weak var dCountL: UILabel!
    @IBOutlet weak var wCountL: UILabel!
    @IBOutlet weak var mCountL: UILabel!
    @IBOutlet weak var hCountL: UILabel!
    
    override func viewDidLoad() {
        roundCorners(dDescL, topR: true, bottomR: true)
        roundCorners(wDescL, topR: true, bottomR: true)
        roundCorners(mDescL, topR: true, bottomR: true)
        roundCorners(hDescL, topR: true, bottomR: true)
        
        roundCorners(dCountL, topL: true, bottomL: true)
        roundCorners(wCountL, topL: true, bottomL: true)
        roundCorners(mCountL, topL: true, bottomL: true)
        roundCorners(hCountL, topL: true, bottomL: true)
        
        calcAverages()
        setLabels()
    }
//declaration
    var dAvg = 0.00, wAvg = 0.00, mAvg = 0.00, hAvg = 0.00
        
//setting the labels
    func setLabels () {
        dCountL.text = String(format: "%.2f", dAvg)
        wCountL.text = String(format: "%.2f", wAvg)
        mCountL.text = String(format: "%.2f", mAvg)
        if hAvg < 0.1 { hCountL.text = "~0"}
        else { hCountL.text = String(format: "%.2f", hAvg) }
    }
        
//calculating the averages
    func calcAverages () {
        let installationDateComps = getCompsFromString(installationDate)
        let currentDateComps = normDateComps(getDateComps(Date()))
        let alltimeCountD = Double(alltimeCount)
            
        var diff = calendar.dateComponents([.day], from: installationDateComps, to: currentDateComps)
        if diff.day! != 0 {
            dAvg = alltimeCountD / Double(diff.day! + 1)
            hAvg = alltimeCountD / Double(diff.day! + 1) / 16.00
        } else {
            dAvg = alltimeCountD
            hAvg = alltimeCountD / 16.00
        }
            
        diff = calendar.dateComponents([.weekOfYear], from: installationDateComps, to: currentDateComps)
        if diff.weekOfYear! != 0 { wAvg = dAvg*7 /*alltimeCountD / Double(diff.weekOfYear!)*/ }
        else { wAvg = alltimeCountD }
            
        diff = calendar.dateComponents([.month], from: installationDateComps, to: currentDateComps)
        if diff.month! != 0 { mAvg = dAvg*30 /*alltimeCountD / Double(diff.month!)*/ }
        else { mAvg = alltimeCountD }
    }
}
