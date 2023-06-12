//
//  SaveDrinkTableViewController.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/8.
//

import UIKit

class SaveDrinkTableViewController: UITableViewController {
    
    var drinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.data(forKey: "drinks"),
           let drinks = try? JSONDecoder().decode([Drink].self, from: data) {
            self.drinks = drinks
        }
    }
    
    // MARK: - Table view data source
    
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        drinks.remove(at: indexPath.row)
        let data = try? JSONEncoder().encode(drinks)
        if let data {
            UserDefaults.standard.set(data, forKey: "drinks")

        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkTableViewCell.self)", for: indexPath) as! DrinkTableViewCell

        // Configure the cell...
        let drink = drinks[indexPath.row]
        cell.nameLabel.text = drink.name
        cell.priceLabel.text = "NT$\(drink.info.m)"
        cell.photoImageView.image = UIImage(named: "milkshoptea")
        
        if let urlString = "https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/\(drink.name).png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let imageURL = URL(string: urlString) {

            cell.photoImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "milkshoptea"))

        }
        
        return cell
    }

}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "SaveDrinkTableViewController")
}
