//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook Air on 21/05/2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
//    var itemArray = ["go fishing", "buy coffee", "call brianna"]
    var itemArray = [Item]()
    
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //
    
   // let defaults  = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       

// let request : NSFetchRequest<Item> = Item.fetchRequest()
        loadItems()
        
         print(FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask))
        
    
    }

    // MARK: CREATE TABLEVIEW DATASOURCE methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
      
        
        return cell
    }

    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//     // delete items from context
//        context.delete(itemArray[indexPath.row])
//           itemArray.remove(at: indexPath.row)
       
        saveItems()

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items on the Todo list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when the user clicks the Add Item Button on the UIAlert
            print("Success!")
//            self.itemArray.append(textField.text!)
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
           
          
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print(alertTextField.text as Any)
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK -  Model Manipulation Methods
    
    func saveItems()  {
      
        
        do {
           try context.save()
            
        } catch {
            print("Error saving context \(error)")
        
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray =  try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
tableView.reloadData()
    }

    
}

// MARK - search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate  = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        
       
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       loadItems(with: request)
//
//
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
            
           
        }
        
 }
}
