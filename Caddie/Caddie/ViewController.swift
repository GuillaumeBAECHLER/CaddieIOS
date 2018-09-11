//
//  ViewController.swift
//  Caddie
//
//  Created by Guillaume BAECHLER on 11/09/2018.
//  Copyright © 2018 Guillaume BAECHLER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let headers: [String] = ["Mon panier", "Produits"]
    var tableViewData: [[String]] = [[], []]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewData[1] = ["🍍 Ananas", "🍊 Mandarine", "🍋 Citron", "🍌 Banane", "🍉 Pastèque", "🍇 Raisin", "🍓 Fraise", "🍈 Melon", "🍑 Pêche", "🥥 Noix de coco", "🥝 Kiwi", "🍅 Tomate", "🍒 Cerise", "🍐 Poire", "🍎 Pomme rouge", "🍏 Pomme verte", "🍆 Aubergine", "🥑 Avocat", "🥦 Brocolis", "🥒 Concombre"]
        tableView.isEditing = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
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
        if(indexPath.section == 0){
            return true
        } else {
            return true
        }
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
        if(indexPath.section == 0){
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.insert
        }
    }
    
    func saveUserCartFromUserDefaults() {
        UserDefaults.standard.set(tableViewData, forKey: "liste")
    }
    
    func loadUserCartToUserDefaults() {
        tableViewData = UserDefaults.standard.object(forKey: "liste") as! [[String]]
    }
    
}

