//
//  ItemTableViewController.swift
//  Shopping List
//
//  Created by Sreekala Santhakumari on 10/30/17.
//  Copyright © 2017 Klas Solution LLC. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController, AddItemSaveDelegate, mapViewDelegate {
    
    var shopNameSelected : Shops!
    
    var items : [NSManagedObject] = []
    

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    func addItemSave(aIS:NSManagedObject) {
        
           items.append(aIS)
            self.tableView.reloadData()
            
        }
    func mapView( mV : Shops){}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.title = shopNameSelected.shopName
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Items")

        do {
            items = try managedContext.fetch(fetchRequest)
        }
        catch let error  as NSError {

            print("CouldNot fetch. \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    //define table
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if self.shopNameSelected.items?.count <= 0 {
//
//            let alert = UIAlertController (title: "Item", message: "Add items to shop", preferredStyle: .alert)
//
//            let alertAction = UIAlertAction(title: "OK", style: .default)
//
//            alert.addAction(alertAction)
//            present(alert, animated: true)
//
//        } else
//
//        {
//        return (self.shopNameSelected.items?.count)!
//    }
        return (self.shopNameSelected.items?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Items", for: indexPath)
        //multiple lines  in cell
        cell.textLabel?.numberOfLines = 0 // line wrap
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        let item = shopNameSelected.items?.allObjects as! [Items]
        let specificItemName = item[(indexPath.row)]
        cell.textLabel?.text = specificItemName.value(forKeyPath: "item")as? String
        cell.detailTextLabel?.text = specificItemName.value(forKey: "details") as? String
        cell.accessoryType = .disclosureIndicator
    
        return cell
    }
    
    //Delete Table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let appDel = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDel.persistentContainer.viewContext
            let item = shopNameSelected.items?.allObjects as! [Items]
            let specificItemName  = item[indexPath.row]
            managedContext.delete(specificItemName)
            
            do {
                try managedContext.save()
            } catch {}
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddItemSegue"){
            let navigationC = segue.destination as! UINavigationController
            let addItemVC = navigationC.viewControllers.first as! AddItemViewController
            addItemVC.shopNameSelected = self.shopNameSelected
            addItemVC.delegate = self
        } else {
            let navigationC = segue.destination as! UINavigationController
            let mapVC = navigationC.viewControllers.first as! MapViewController
            mapVC.nameOfTheShop = shopNameSelected.shopName
            
            print (mapVC.nameOfTheShop)
        }
    }
    
    
}
