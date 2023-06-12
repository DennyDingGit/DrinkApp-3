//
//  MenuTableViewController.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/2.
//

import UIKit
import Kingfisher

class MenuTableViewController: UITableViewController {
    
    var menus = [Menu]()
    var saveDrinks = [Drink]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        print("使用GitHub")
        fetchMenu()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = UserDefaults.standard.data(forKey: "drinks"),
           let drinks = try? JSONDecoder().decode([Drink].self, from: data) {
            saveDrinks = drinks
            tableView.reloadData()
        }
        
        
    }
    
    func fetchMenu() {
        let url = URL(string: "https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/Milksha.json")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    self.menus = try decoder.decode([Menu].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch  {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    @IBAction func heartButtonTap(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if let indexPath {
            let drink = menus[indexPath.section].drinks[indexPath.row]
            
            if sender.isSelected {
                let index = saveDrinks.firstIndex {
                    $0.name == drink.name
                }
                if let index {
                    saveDrinks.remove(at: index)
                }
            } else {
                saveDrinks.append(drink)
            }
            
            let data = try? JSONEncoder().encode(saveDrinks)
            if let data {
                UserDefaults.standard.set(data, forKey: "drinks")

            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") {
            view.window?.rootViewController = controller
        }
        
    }
    
    @IBSegueAction func showOrderView(_ coder: NSCoder) -> OrderTableViewController? {
        if let indexPath = tableView.indexPathForSelectedRow {
            let controller = OrderTableViewController(coder: coder)
            controller?.drink = menus[indexPath.section].drinks[indexPath.row]
            return controller
        } else {
            return nil 
        }
       
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menus[section].category
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].drinks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkTableViewCell.self)", for: indexPath) as! DrinkTableViewCell

        // Configure the cell...
        let drink = menus[indexPath.section].drinks[indexPath.row]
        cell.nameLabel.text = drink.name
        cell.priceLabel.text = "NT$\(drink.info.m)"
        cell.photoImageView.image = UIImage(named: "milkshoptea")
        
        let contain = saveDrinks.contains {
            $0.name == drink.name
        }
        
        cell.heartButton.isSelected = contain
        
        if let urlString = "https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/\(drink.name).png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let imageURL = URL(string: urlString) {

            cell.photoImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "milkshoptea"))

        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
}
