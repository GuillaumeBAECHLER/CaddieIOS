//
//  ViewController.swift
//  Caddie
//
//  Created by Guillaume BAECHLER on 11/09/2018.
//  Copyright © 2018 Guillaume BAECHLER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAchat: UIButton!
    @IBOutlet weak var btnAnnuler: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let headers: [String] = ["Mon panier", "Produits"]
    var tableViewData: [[String]] = [[], []]
    var filtered: [String] = []
    var products: [String] = ["🍍 Ananas", "🍊 Mandarine", "🍋 Citron", "🍌 Banane", "🍉 Pastèque", "🍇 Raisin", "🍓 Fraise", "🍈 Melon", "🍑 Pêche", "🥥 Noix de coco", "🥝 Kiwi", "🍅 Tomate", "🍒 Cerise", "🍐 Poire", "🍎 Pomme rouge", "🍏 Pomme verte", "🍆 Aubergine", "🥑 Avocat", "🥦 Brocolis", "🥒 Concombre"]
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewData[1] = products
        tableView.isEditing = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        searchBar.delegate = self
        loadUserCartToUserDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "cart_cell")!
        cell.textLabel?.text = tableViewData[indexPath.section][indexPath.row]
        cell.isEditing = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // Si on delete, on est dans la liste panier
            tableViewData[1].append(tableViewData[indexPath.section][indexPath.row])
            tableViewData[indexPath.section].remove(at: indexPath.row)
        } else if (editingStyle == .insert){
            // Si on insert, on est dans la liste produits
            tableViewData[0].append(tableViewData[indexPath.section][indexPath.row])
            tableViewData[indexPath.section].remove(at: indexPath.row)
        }
        tableView.reloadData()
        saveUserCartFromUserDefaults()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.section == 0) {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.insert
    }
    
    func saveUserCartFromUserDefaults() {
        UserDefaults.standard.set(tableViewData, forKey: "liste")
    }
    
    func loadUserCartToUserDefaults() {
        let userData = UserDefaults.standard.object(forKey: "liste") as? [[String]]
        if ( userData != nil ) {
            tableViewData = userData!
        }
    }
    
    @IBAction func acheter(_ sender: Any) {
        cleanUI()
    }
    
    @IBAction func annuler(_ sender: Any) {
        cleanUI()
    }
    
    func cleanUI() {
        UserDefaults.standard.removeObject(forKey: "liste")
        tableViewData[1].insert(contentsOf: tableViewData[0], at: 0)
        tableViewData[0].removeAll()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var fullProducts:Set<String> = Set(products)
        fullProducts.subtract(tableViewData[0])
        if(searchText == ""){
            filtered = Array(fullProducts)
        } else {
            filtered = fullProducts.filter({ (text) -> Bool in
                let tmp: NSString = text as NSString as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        tableViewData[1] = filtered
        tableView.reloadData()
    }
    
}

