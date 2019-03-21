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
    var icon: IconAsset?
    
    var uncheckedItemsCount : Int {
        get {
            return items?.filter({ (item) -> Bool in
                !item.checked
            }).count ?? 0
        }
       
    }
    
    init(name: String, listItems: [ChecklistItem]? = [], icon: IconAsset = .NoIcon) {
        self.name = name
        self.items = listItems
        self.icon = icon
    }
}
