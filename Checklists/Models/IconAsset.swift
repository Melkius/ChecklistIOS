//
//  IconAsset.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 21/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

enum IconAsset : String, CaseIterable, Codable {
    case Appointments
    case Birthdays
    case Chores
    case Drinks
    case Folder
    case Groceries
    case Inbox
    case NoIcon = "No Icon"
    case Photos
    case Trips
    
    var image : UIImage {
        return UIImage(named: self.rawValue)!
    }
}
