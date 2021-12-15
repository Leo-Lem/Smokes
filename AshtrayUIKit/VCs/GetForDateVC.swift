//
//  GetForDateViewController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import UIKit

class GetForDateViewController: UIViewController {

//outlets
    @IBOutlet weak var dDescL: UILabel!
    @IBOutlet weak var wDescL: UILabel!
    @IBOutlet weak var mDescL: UILabel!
    @IBOutlet weak var yDescL: UILabel!
    
    @IBOutlet weak var dCountL: UILabel!
    @IBOutlet weak var wCountL: UILabel!
    @IBOutlet weak var mCountL: UILabel!
    @IBOutlet weak var yCountL: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!
    
//setup
    override func viewDidLoad() {
        roundCorners(dDescL, topR: true, bottomR: true)
        roundCorners(wDescL, topR: true, bottomR: true)
        roundCorners(mDescL, topR: true, bottomR: true)
        roundCorners(yDescL, topR: true, bottomR: true)
        
        roundCorners(dCountL, topL: true, bottomL: true)
        roundCorners(wCountL, topL: true, bottomL: true)
        roundCorners(mCountL, topL: true, bottomL: true)
        roundCorners(yCountL, topL: true, bottomL: true)
        
        initVC()
    }
    
//declaration
    var dCount = 0, wCount = 0, mCount = 0, yCount = 0
    var selectedDate = ""
    
//getting the count for the selected date
    func getDateCountsFromDicts (forDate date: String) {
        var key = getKey(forDate: date, inCase: 1)
        dCount = getFromDict(forKey: key, inCase: 1)
        
        key = getKey(forDate: date, inCase: 2)
        wCount = getFromDict(forKey: key, inCase: 2)
                
        key = getKey(forDate: date, inCase: 3)
        mCount = getFromDict(forKey: key, inCase: 3)
            
        key = getKey(forDate: date, inCase: 4)
        yCount = getFromDict(forKey: key, inCase: 4)
    }

//initialize this VC
    func initVC () {
        selectedDate = convertCompsToString(getDateComps(datePicker.date))
        getDateCountsFromDicts(forDate: selectedDate)
        
        setCountLabel(dCountL, count: dCount); setCountLabel(wCountL, count: wCount); setCountLabel(mCountL, count: mCount); setCountLabel(yCountL, count: yCount)
    }
    
//changing the displayed count
    @IBAction func datePicked(_ sender: Any) { initVC() }
    
}
