//
//  AllListViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {

    //MARK: - Variables
//    var documentDirectory: URL {
//        get{
//            return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
//        }
//    }
//
//    var dataFileUrl: URL {
//        get {
//            return documentDirectory.appendingPathComponent("allCkecklists").appendingPathExtension("json")
//        }
//    }
    var dataModel = DataModel.shared
    var listOfChecklists = [Checklist]()

    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: - Require Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        listOfChecklists = dataModel.loadChecklists()
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dataModel.saveChecklists()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toChecklistItems":
            let destVC = segue.destination as! ChecklistViewController
            destVC.checkList = listOfChecklists[(tableView.indexPath(for: sender as! UITableViewCell)?.row)!]
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
        //dataModel.saveChecklists()
    }
    
    //MARK:- persistance Locale
//    func saveChecklists() {
//        let jsonEncoder = JSONEncoder()
//        do {
//            let jsonData = try jsonEncoder.encode(listOfChecklists)
//            try jsonData.write(to: dataFileUrl)
//        }
//        catch {
//            print("error")
//        }
//    }
//
//    func loadChecklists() {
//        do {
//            let jsonDecoder = JSONDecoder()
//            let data = try Data.init(contentsOf: dataFileUrl)
//            listOfChecklists = try jsonDecoder.decode([Checklist].self, from: data)
//            for item in listOfChecklists {
//                print(item.name)
//            }
//        }
//        catch {
//            print("error")
//        }
//    }
}

//MARK: - Extension ListDetailViewControllerDelegate
extension AllListViewController : ListDetailViewControllerDelegate {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
        //dataModel.saveChecklists()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        listOfChecklists.append(item)
        let newIndexPath = IndexPath(row: listOfChecklists.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        //dataModel.saveChecklists()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        let row = listOfChecklists.index(where: {$0 === item})!
        let newIndexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        //dataModel.saveChecklists()
    }
    
    
}
