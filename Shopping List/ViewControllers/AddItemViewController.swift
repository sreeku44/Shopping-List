//
//  AddItemViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 11/1/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import UIKit
import CoreData

protocol AddItemSaveDelegate {

    func addItemSave(aIS: NSManagedObject)
}


class AddItemViewController: UIViewController , UITextFieldDelegate {
    
    var shopNameSelected : Shops!
    var items : [NSManagedObject] = []


    var delegate : AddItemSaveDelegate?
  
    @IBOutlet weak var addItemTextField: UITextField!
    
    @IBOutlet var addDescriptionTextField: UITextField!
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
        dismiss(animated: true, completion: nil)
        
    }
    func showAlert(message: String) {
        let alert = UIAlertController (title: "Item", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let itemName = addItemTextField.text
        let description = addDescriptionTextField.text
        if itemName == ""
        {
            showAlert(message: "Item Name cannot be empty")
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //let itemsToAdd = NSEntityDescription.insertNewObject(forEntityName: "Items", into: managedContext)
        
        let itemsToAdd = Items(context: managedContext)
        itemsToAdd.item = itemName
        itemsToAdd.details = description
        itemsToAdd.shop = self.shopNameSelected
        
        
        //let entity = NSEntityDescription.entity(forEntityName : "Items", in : managedContext)!
        //let itemsToAdd = NSManagedObject (entity:entity, insertInto :managedContext)
        //itemsToAdd.setValue(itemName, forKey: "item")
        //itemsToAdd.setValue(description, forKey: "details")
        //itemsToAdd.setValue(self.shopNameSelected, forKey: "items")
        
        
        
        do {
            try managedContext.save()
            items.append(itemsToAdd)
            
        } catch  let error as NSError {
            print("couldnot save. \(error), \(error.userInfo)")
        }
        self.delegate?.addItemSave(aIS: itemsToAdd)
       dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.title = shopNameSelected.shopName
        super.viewDidLoad()
        
    }
    
    //return keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //retun keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
