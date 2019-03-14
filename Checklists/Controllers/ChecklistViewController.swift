//
//  ViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/02/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var documentDirectory: URL {
        get{
            return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        }
    }
    
    var dataFileUrl: URL {
        get {
            return documentDirectory.appendingPathComponent("Ckecklists").appendingPathExtension("json")
        }
    }
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var checkList: Checklist!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "editItem":
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            let item = sender as! ChecklistItemCell
            let position = self.tableView.indexPath(for: item)!
            destVC.itemToEdit = checkList.items![position.row]
            destVC.delegate = self
        case "addItem":
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            destVC.delegate = self
        default:
            return
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = checkList.name
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (checkList.items ?? []).count
    }
    
    
    //MARK:- TableView methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        configureCheckmark(for: cell, withItem: checkList.items![indexPath.item] )
        configureText(for: cell, withItem: checkList.items![indexPath.item] )

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkList.items![indexPath.item].toggleChecked()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            checkList.items!.remove(at: indexPath.item)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    // MARK:- Cell contents
    func configureCheckmark(for cell: UITableViewCell, withItem item: ChecklistItem) {
        let checkmark  = cell as! ChecklistItemCell
        checkmark.checkmarkCell.isHidden = !item.checked
    }
    
    func configureText(for cell: UITableViewCell, withItem item: ChecklistItem) {
        let label = cell as! ChecklistItemCell
        label.labelCell.text = item.text
    }
    
}


//MARK:- ItemDetailViewControllerDelegate
extension ChecklistViewController : ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        checkList.items?.append(item)
        let newIndexPath = IndexPath(row: checkList.items!.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        let row = checkList.items!.index(where: {$0 === item})!
        let newIndexPath = IndexPath(row: row, section: 0)
        checkList.items?[newIndexPath.row] = item
        self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
    }
    
}

