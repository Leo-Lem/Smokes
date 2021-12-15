//
//  ViewController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 24.03.21.
//

import UIKit

class MainViewController: UIViewController {

//outlets
    @IBOutlet weak var dDescL: UILabel!
    @IBOutlet weak var wDescL: UILabel!
    @IBOutlet weak var mDescL: UILabel!
    @IBOutlet weak var yDescL: UILabel!
    @IBOutlet weak var aDescL: UILabel!
    
    @IBOutlet weak var dCountL: UILabel!
    @IBOutlet weak var wCountL: UILabel!
    @IBOutlet weak var mCountL: UILabel!
    @IBOutlet weak var yCountL: UILabel!
    @IBOutlet weak var aCountL: UILabel!
    
    @IBOutlet weak var checkStatsB: UIButton!
    @IBOutlet weak var editCountsB: UIButton!
    
//setup before view is visible
    override func viewDidLoad() {
        roundCorners(checkStatsB, topL: true)
        roundCorners(editCountsB, topR: true)
        
        roundCorners(dDescL, topR: true, bottomR: true)
        roundCorners(wDescL, topR: true, bottomR: true)
        roundCorners(mDescL, topR: true, bottomR: true)
        roundCorners(yDescL, topR: true, bottomR: true)
        roundCorners(aDescL, topR: true, bottomR: true)
        
        roundCorners(dCountL, topL: true, bottomL: true)
        roundCorners(wCountL, topL: true, bottomL: true)
        roundCorners(mCountL, topL: true, bottomL: true)
        roundCorners(yCountL, topL: true, bottomL: true)
        roundCorners(aCountL, topL: true, bottomL: true)
        
        getCounts()
        
        //on the first launch the installation date is saved to the UD, afterwards its read from there
        /*if defaults.object(forKey:"installationDate") == nil {
            installationDate = convertCompsToString(getDateComps(Date()))
            defaults.set(installationDate, forKey: "installationDate")
        } else { installationDate = defaults.object(forKey:"installationDate") as! String }
        */
        
    }
//declaration
    var dCount = 0, wCount = 0, mCount = 0, yCount = 0
    var lastChangeDate = ""

//saving to/getting from the dicts
    func saveAllToDict (_ date: String) {
        var key = getKey(forDate: date, inCase: 1)
        saveToDict(count: dCount, forKey: key, inCase: 1)
        
        key = getKey(forDate: date, inCase: 2)
        saveToDict(count: wCount, forKey: key, inCase: 2)
        
        key = getKey(forDate: date, inCase: 3)
        saveToDict(count: mCount, forKey: key, inCase: 3)
        
        key = getKey(forDate: date, inCase: 4)
        saveToDict(count: yCount, forKey: key, inCase: 4)
    }

    func getAllFromDict (_ date: String) {
        var key = getKey(forDate: date, inCase: 1)
        dCount = getFromDict(forKey: key, inCase: 1)
        
        key = getKey(forDate: date, inCase: 2)
        wCount = getFromDict(forKey: key, inCase: 2)
        
        key = getKey(forDate: date, inCase: 3)
        mCount = getFromDict(forKey: key, inCase: 3)
        
        key = getKey(forDate: date, inCase: 4)
        yCount = getFromDict(forKey: key, inCase: 4)
    }

//setting all labels
    func setAllLabels () {
        setCountLabel(dCountL, count: dCount)
        setCountLabel(wCountL, count: wCount)
        setCountLabel(mCountL, count: mCount)
        setCountLabel(yCountL, count: yCount)
        setCountLabel(aCountL, count: alltimeCount)
    }
    
//getting and displaying the counts
    func getCounts () {
        lastChangeDate = convertCompsToString(getDateComps(Date()))
        getFromUD()
        getAllFromDict(lastChangeDate)
        setAllLabels()
    }
    
//change the counts
    func changeCounts () {
        lastChangeDate = convertCompsToString(getDateComps(Date()))
        saveAllToDict(lastChangeDate)
        saveToUD()
        setAllLabels()
    }
    
//button actions
    @IBAction func addSmoke(_ sender: Any) {
        getCounts()
        dCount += 1; wCount += 1; mCount += 1; yCount += 1; alltimeCount += 1
        changeCounts()
    }
    @IBAction func removeSmoke(_ sender: Any) {
        getCounts()
        if dCount != 0 {
            dCount -= 1; wCount -= 1; mCount -= 1; yCount -= 1; alltimeCount -= 1
            changeCounts()
        }
    }
    @IBAction func refreshCounts(_ sender: Any) { getCounts() }
    
//troubleshooting
    @IBAction func troubleshooting(_ sender: Any) {
        print(dayCountDictionary, "\n", weekCountDictionary, "\n", monthCountDictionary, "\n", yearCountDictionary, "\n", alltimeCount)
    }
    
}
