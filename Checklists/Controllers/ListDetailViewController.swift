//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class ListDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_newChecklist: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var icone: UIImageView!
    
    var delegate: ListDetailViewControllerDelegate!
    var itemToEdit: Checklist?
    var itemPath: IndexPath?
    private var selectedIcon: IconAsset? = nil
    
    //MARK: - Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf_newChecklist.becomeFirstResponder()
        
    }
    
    //MARK: - Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        
        if let item: Checklist = itemToEdit {
            navigationItem.title = "Edit"
            tf_newChecklist.text = item.name
            icone.image = item.icon?.image
        } else {
            navigationItem.title = "Add"
            btnDone.isEnabled = false
            selectedIcon = IconAsset.Folder
            icone.image = selectedIcon?.image
        }
    
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowIconList", sender: nil)
    }
    
    //MARK : - manage choice done or cancel
    @IBAction func cancel() {
        delegate.listDetailViewControllerDidCancel(self)
    }
    
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.name = tf_newChecklist.text!
            delegate.listDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            let newCheckItem = Checklist(name: tf_newChecklist.text!)
            newCheckItem.icon = self.selectedIcon
            delegate.listDetailViewController(self, didFinishAddingItem: newCheckItem)
        }
    }
    
    //MARK:- textField func
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text! as NSString
        let newString = nsString.replacingCharacters(in: range, with: string)
        if (newString.isEmpty)  {
            btnDone.isEnabled = false
        } else {
            btnDone.isEnabled = true
        }
        return true
    }

    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowIconList" {
            let destVC = segue.destination as! IconPickerViewController
            destVC.delegate = self
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
    }
    

}

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem item: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem item: Checklist)
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPickerViewControllerDelegateDidCancel(_ controller: IconPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishEditingItem item: IconAsset) {
        self.selectedIcon = item
        self.itemToEdit?.icon = item
        self.icone.image = item.image
        navigationController?.popViewController(animated: true)
    }
    
    
}
