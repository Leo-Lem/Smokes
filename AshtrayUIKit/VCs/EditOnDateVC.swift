//
//  EditOnDateViewController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import UIKit

class EditOnDateViewController: UIViewController {

//outlets
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        roundCorners(descLabel, topR: true, bottomR: true)
        roundCorners(countLabel, topL: true, bottomL: true)
        
        selectedDate = convertCompsToString(getDateComps(Date()))
        getDateCountsFromDicts(forDate: selectedDate)
            
        setCountLabel(countLabel, count: dCount)
    }
    
//declaration
    var dCount = 0, wCount = 0, mCount = 0, yCount = 0
    var selectedDate = ""
        
//saving to/getting from the dicts for selected date
    func saveDateCountsToDicts (forDate date: String) {
        var key = getKey(forDate: date, inCase: 1)
        saveToDict(count: dCount, forKey: key, inCase: 1)
            
        key = getKey(forDate: date, inCase: 2)
        saveToDict(count: wCount, forKey: key, inCase: 2)
            
        key = getKey(forDate: date, inCase: 3)
        saveToDict(count: mCount, forKey: key, inCase: 3)
            
        key = getKey(forDate: date, inCase: 4)
        saveToDict(count: yCount, forKey: key, inCase: 4)
    }
    
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

//changing the displayed count
    @IBAction func datePicked(_ sender: Any) {
        selectedDate = convertCompsToString(getDateComps(datePicker.date))
        getDateCountsFromDicts(forDate: selectedDate)
            
        setCountLabel(countLabel, count: dCount)
    }

//button actions
    @IBAction func addOnDate(_ sender: Any) {
        getDateCountsFromDicts(forDate: selectedDate)
        
        dCount += 1; wCount += 1; mCount += 1; yCount += 1; alltimeCount += 1
        
        saveDateCountsToDicts(forDate: selectedDate)
        saveToUD()
        setCountLabel(countLabel, count: dCount)
    }
    @IBAction func removeOnDate(_ sender: Any) {
        getDateCountsFromDicts(forDate: selectedDate)
        
        if dCount != 0 {
            dCount -= 1; wCount -= 1; mCount -= 1; yCount -= 1; alltimeCount -= 1
            
            saveDateCountsToDicts(forDate: selectedDate)
            saveToUD()
            setCountLabel(countLabel, count: dCount)
        }
    }
    
//sending back to the Main VC
}
