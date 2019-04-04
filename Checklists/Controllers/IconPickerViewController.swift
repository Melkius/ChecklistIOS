//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 04/04/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import Foundation
import UIKit

class IconPickerViewController : UITableViewController {
    
    var delegate: IconPickerViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell")! as UITableViewCell
        cell.textLabel?.text = IconAsset.allValues[indexPath.row].rawValue
        cell.imageView?.image = IconAsset.allValues[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.iconPickerViewController(self, didFinishEditingItem: IconAsset.allValues[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IconAsset.allValues.count
    }
    
    
}

protocol IconPickerViewControllerDelegate : class {
    func iconPickerViewControllerDelegateDidCancel(_ controller: IconPickerViewController)
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishEditingItem item: IconAsset)
}


