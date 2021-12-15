//
//  FunctionsLayout.swift
//  Ashtray
//
//  Created by Leopold Lemmermann on 31.03.21.
//

import Foundation; import UIKit

//rounding Corners
func roundCorners (_ view: UIView, topL:Bool = false, topR:Bool = false, bottomL:Bool = false, bottomR:Bool = false) {
    view.layer.maskedCorners = []
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 20
        
    if topL == true { view.layer.maskedCorners.insert(.layerMinXMinYCorner) }
    if topR == true { view.layer.maskedCorners.insert(.layerMaxXMinYCorner) }
    if bottomL == true { view.layer.maskedCorners.insert(.layerMinXMaxYCorner) }
    if bottomR == true { view.layer.maskedCorners.insert(.layerMaxXMaxYCorner) }
}

func setCountLabel (_ label: UILabel, count: Int) { label.text = String(count) }
