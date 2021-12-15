//
//  InfoViewController.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import UIKit

class InfoViewController: UIViewController {

//outlets
    @IBOutlet weak var artworkLabel: UILabel!
    @IBOutlet weak var artworkText: UITextView!
    
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesText: UITextView!
    
    @IBOutlet weak var installedLabel: UILabel!
    @IBOutlet weak var installationDateLabel: UILabel!
    
    override func viewDidLoad() {
        roundCorners(artworkLabel, topL: true, topR: true)
        roundCorners(artworkText, bottomL: true, bottomR: true)
        
        roundCorners(notesLabel, topL: true, topR: true)
        roundCorners(notesText, bottomL: true, bottomR: true)
        
        roundCorners(installedLabel, topL: true, bottomL: true)
        roundCorners(installationDateLabel, topR: true, bottomR: true)
        installationDateLabel.text = installationDate
    }
}
