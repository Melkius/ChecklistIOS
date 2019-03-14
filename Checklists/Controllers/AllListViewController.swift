//
//  AllListViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {

    var documentDirectory: URL {
        get{
            return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        }
    }
    
    var dataFileUrl: URL {
        get {
            return documentDirectory.appendingPathComponent("allCkecklists").appendingPathExtension("json")
        }
    }
    
    var listOfChecklists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        listOfChecklists.append(Checklist(name: "list1"))
//        listOfChecklists.append(Checklist(name: "list2"))
//        listOfChecklists.append(Checklist(name: "list3"))
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadChecklistItems()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toChecklistItems":
            let destVC = segue.destination as! ChecklistViewController
            destVC.list = listOfChecklists[(tableView.indexPath(for: sender as! UITableViewCell)?.row)!]
        case "editChecklist":
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ListDetailViewController
            let item = sender as! UITableViewCell
            let position = self.tableView.indexPath(for: item)!
            destVC.itemToEdit = listOfChecklists[position.row]
            destVC.delegate = self
        case "addChecklist":
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ListDetailViewController
            destVC.delegate = self
        default:
            return
        }
    }
 
    //MARK: - tableView methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chosenList")! as UITableViewCell
        
        cell.textLabel?.text = listOfChecklists[indexPath.row].name
        configureText(for: cell, withItem: listOfChecklists[indexPath.row] )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfChecklists.count
    }
    
    //MARK: - Configure Text
    func configureText(for cell: UITableViewCell, withItem item: Checklist) {
        cell.textLabel?.text = item.name
//        let label = cell as! ChecklistItem
//        label.labelCell.text = item.text
        saveChecklistItems()
    }
    
    //MARK:- persistance Locale
    func saveChecklistItems() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(listOfChecklists)
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
            listOfChecklists = try jsonDecoder.decode([Checklist].self, from: data)
            for item in listOfChecklists {
                print(item.name)
            }
        }
        catch {
            print("error")
        }
    }
}

extension AllListViewController : ListDetailViewControllerDelegate {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
        saveChecklistItems()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        listOfChecklists.append(item)
        let newIndexPath = IndexPath(row: listOfChecklists.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        saveChecklistItems()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        let row = listOfChecklists.index(where: {$0 === item})!
        let newIndexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        saveChecklistItems()
    }
    
    
}
