//
//  AddItemViewController.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/02/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate{

    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var tf_newTODO: UITextField!
    @IBOutlet weak var icone: UIImageView!
    
    var delegate: ItemDetailViewControllerDelegate!
    var itemToEdit: ChecklistItem?
    var itemPath: IndexPath?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf_newTODO.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        
        if let item: ChecklistItem = itemToEdit {
            tf_newTODO.text = item.text
            btnDone.isEnabled = true
            navigationItem.title = "Edition"
        } else {
            navigationItem.title = "Ajout"
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
    

    @IBAction func cancel() {
        delegate.itemDetailViewControllerDidCancel(self)
    }
    
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = tf_newTODO.text!
            delegate.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            let newCheckItem = ChecklistItem(text: tf_newTODO.text!)
            delegate.itemDetailViewController(self, didFinishAddingItem: newCheckItem)
        }
    }
}


protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}
