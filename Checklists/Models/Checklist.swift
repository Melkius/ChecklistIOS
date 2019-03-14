//
//  Checklist.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class Checklist : Codable  {
    var name: String
    var items: [ChecklistItem]?
    
    init(name: String, listItems: [ChecklistItem]? = []) {
        self.name = name
        self.items = listItems
    }
}
