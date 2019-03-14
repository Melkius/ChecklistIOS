//
//  AllListViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {

    var listOfChecklists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfChecklists.append(Checklist(name: "list1"))
        listOfChecklists.append(Checklist(name: "list2"))
        listOfChecklists.append(Checklist(name: "list3"))
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ChecklistViewController
        destVC.list = listOfChecklists[(tableView.indexPath(for: sender as! UITableViewCell)?.row)!]
    }
 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chosenList")! as UITableViewCell
        cell.textLabel?.text = listOfChecklists[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfChecklists.count
    }
}

