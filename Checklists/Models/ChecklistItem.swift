//
//  ChecklistItem.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/02/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import Foundation

class ChecklistItem : Codable {
    
    var text : String
    var checked : Bool
    
    init(text: String, _ checked: Bool = false) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    
}
