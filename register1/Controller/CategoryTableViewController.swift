//
//  CategoryTableViewController.swift
//  register1
//
//  Created by Sourabh kehar on 2020-04-26.
//  Copyright © 2020 Sourabh kehar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var categories: Results<Category>?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        loadCategories()
       
    }
    //Mark:- TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO CATEGORIES ADDED YET"
        
        return cell
    }
    
    //Mark:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    //MARK:- Data Manupulation Methods
    
    func saveCategory(category: Category) {
        do{
       try realm.write{
            realm.add(category)
            }}catch{
                print("error saving category \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
  //Mark:- Add New Item
    
    @IBAction func barbuttonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW REGISTER ITEM", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD NEW ITEM", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategory(category: newCategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "ADD NEW ITEM"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
