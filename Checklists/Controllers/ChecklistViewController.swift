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
    
    var listCheckedItems: [ChecklistItem] = []
    var list: Checklist!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "editItem":
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            let item = sender as! ChecklistItemCell
            let position = self.tableView.indexPath(for: item)!
            destVC.itemToEdit = listCheckedItems[position.row]
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
        loadChecklistItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = list.name
        // Do any additional setup after loading the view, typically from a nib.
        
//        let check1 = ChecklistItem(text: "Finir le cours d’iOS")
//        let check2 = ChecklistItem(text: "Réviser", true)
//        let check3 = ChecklistItem(text: "Faire les courses", false)
//        let check4 = ChecklistItem(text: "Java", true)
//        let check5 = ChecklistItem(text: "React Native", true)
//        let check6 = ChecklistItem(text: "Forge Of Empire", true)
//
//
//        listCheckedItems.append(contentsOf: [check1, check2, check3, check4, check5, check6])
        
        //print(dataFileUrl)
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCheckedItems.count
    }
    
    
    //MARK:- TableView methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        configureCheckmark(for: cell, withItem: listCheckedItems[indexPath.item] )
        configureText(for: cell, withItem: listCheckedItems[indexPath.item] )

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listCheckedItems[indexPath.item].toggleChecked()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            listCheckedItems.remove(at: indexPath.item)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    

    
    
    // MARK:- Cell contents
    func configureCheckmark(for cell: UITableViewCell, withItem item: ChecklistItem) {
        let checkmark  = cell as! ChecklistItemCell
        checkmark.checkmarkCell.isHidden = !item.checked
        saveChecklistItems()
    }
    
    func configureText(for cell: UITableViewCell, withItem item: ChecklistItem) {
        let label = cell as! ChecklistItemCell
        label.labelCell.text = item.text
        saveChecklistItems()
    }
    
    //MARK:- persistance Locale
    func saveChecklistItems() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(listCheckedItems)
            try jsonData.write(to: dataFileUrl)
        }
        catch {
            print("error")
        }
    }
    
    func loadChecklistItems() {
        do {
            let jsonDecoder = JSONDecoder()
            let data = try Data.init(contentsOf: dataFileUrl)
            listCheckedItems = try jsonDecoder.decode([ChecklistItem].self, from: data)
            for item in listCheckedItems {
                print(item.text)
                print("\(item.checked)\n")
            }
        }
        catch {
            print("error")
        }
    }
    
}


//MARK:- ItemDetailViewControllerDelegate
extension ChecklistViewController : ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        listCheckedItems.append(item)
        let newIndexPath = IndexPath(row: listCheckedItems.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        let row = listCheckedItems.index(where: {$0 === item})!
        let newIndexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        saveChecklistItems()
    }
    
}

