//  ShopsTableViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 10/30/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//
import UIKit
import CoreData

class ShopsTableTableViewController: UITableViewController {
    
    var shopNames: [NSManagedObject] = []
    //var newShopNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shop Names"
        
        
    }
    
@IBAction func addShopName(_ sender: UIBarButtonItem) {
        //Alert box to add shop names
        let alert = UIAlertController (title: "Shop Name", message: "Add new shop name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction (title: "Save",
                                        style: .default) {
                                [unowned self] action in
                                guard let textField = alert.textFields?.first,
                                let shopNameToSave = textField.text else {
                                return
                                            }
                                self.save(shopName: shopNameToSave)
                                            
                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction (title: "Cancel",
                                          style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
  //Alert method for easy use
func showAlert(message: String) {
        let alert = UIAlertController (title: "Shop Name", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    //saving coredata
func save (shopName: String )  {
        if shopName == ""
        {
            showAlert(message: "Shop Name cannot be empty")
            return
        }
        if ( self.shopNameExists(newShopName: shopName)) {
            showAlert(message: "Shop Name already exists")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName : "Shops", in : managedContext)!
        
        //   let shop = Shops(context: managedContext)
        //    shop.shopName = "HEB"
        //        try! managedContext.save()
        
        let shopNamesToAdd = NSManagedObject (entity:entity, insertInto :managedContext)
        shopNamesToAdd.setValue(shopName, forKey: "shopName")
        
        do {
            try managedContext.save()
            shopNames.append(shopNamesToAdd)
        } catch  let error as NSError {
            print("couldnot save. \(error), \(error.userInfo)")
        }
    }
    //Chccking shop Name duplicate
func shopNameExists (newShopName :String) -> Bool{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName : "Shops", in : managedContext)!
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName : "Shops")
        let predicate = NSPredicate(format: "shopName == [c] %@",  newShopName)
        request.predicate = predicate
        
        
        let result = try! managedContext.fetch(request)
        
        return (result.count > 0 ) ? true : false
    }
    
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fetching from coreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let mangedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest  = NSFetchRequest<NSManagedObject>(entityName: "Shops")
        do {
            shopNames = try mangedContext.fetch(fetchRequest)}
        catch let error as NSError {
            print("Couuld not fetch.\(error),\(error.userInfo)")
        }
    }
     //define table
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shopNames.count <= 0 {
            
            let alert = UIAlertController (title: "Shops", message: "Add shop to get started", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(alertAction)
            present(alert, animated: true)
            
        } else
        {
           return shopNames.count
            
        }
        return shopNames.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopNames", for: indexPath)
        
        let displayShopName = shopNames[indexPath.row]
        cell.textLabel?.text = displayShopName.value(forKeyPath: "shopName")as? String
        
        return cell
    }
    
   // Delete Table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            managedContext.delete(shopNames[indexPath.row])
            shopNames.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch {}
        }
        self.tableView.reloadData()
    }
    
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination as! UINavigationController
        let itemTVC = navigationVC.viewControllers.first as!ItemTableViewController
        guard
            let  indexPath = self.tableView.indexPathForSelectedRow else {
                fatalError("no selection made")
        }
        itemTVC.shopNameSelected = shopNames[(indexPath.row)] as! Shops
        //itemTVC.items = shopNames
        
    }
    
}
//edit table
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        if type == .insert {
//            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        } else if type == .delete {
//            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
//        }
//    }
//



