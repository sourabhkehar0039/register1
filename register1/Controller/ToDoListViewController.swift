//
//  ViewController.swift
//  register1
//
//  Created by Sourabh kehar on 2020-04-26.
//  Copyright © 2020 Sourabh kehar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeCellViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if   let colourHex = selectedCategory?.colour{
            
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError("navigationBar does not exist")
            }
            if let navBarColour = UIColor(hexString: colourHex){
            navBar.backgroundColor = navBarColour
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :ContrastColorOf(navBarColour, returnFlat: true)]
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                searchBar.barTintColor = navBarColour
            }}
    }
     
    //Mark:- TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row]{
        cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)){
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "NO ITEM ADDED"
        }
        return cell
    }
    
    //Mark:- Data Manupulation Method
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //Mark:- delete item while swipe
    
    override func updateModel(at indexpath: IndexPath) {
        
        if let item = toDoItems?[indexpath.row]{
            do{
             try  realm.write{
            realm.delete(item)
                }}catch{
                    print("error deleting item, \(error)")
            }
        }
    }
    
    //Mark:- Add New Button
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
            do{
                try  self.realm.write{
            let newItem = Item()
            newItem.title = textField.text!
            currentCategory.items.append(newItem)
                }}catch{
                    print("error adding new item \(error)")
                }
        }
            self.tableView.reloadData()
    }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add New Item"
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
           if searchBar.text?.count == 0{
                loadItems()
            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


