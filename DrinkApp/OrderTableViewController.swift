//
//  OrderTableViewController.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/2.
//

import UIKit

enum OrderTableSection: Int {
    case size, sugar, ice
}

class OrderTableViewController: UITableViewController {
    var drink: Drink!
    
    let sizeLargeIndexPath = IndexPath(row: 1, section: OrderTableSection.size.rawValue)
    var order: Order?
    @IBOutlet var sizeCells: [UITableViewCell]!
    @IBOutlet var sugarCells: [UITableViewCell]!
    @IBOutlet var iceCells: [UITableViewCell]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = drink.name
        order = Order(name: "小宇", drink: drink.name, size: Size.m.rawValue, iceLevel: IceLevel.noIce.rawValue, sugarLevel: SugarLevel.halfSugar.rawValue, price: drink.info.m)
        
        updateSizeCells()
        updateSugerCells()
        updateIceCells()
       
    }
    
    func updateSugerCells() {
        for cell in sugarCells {
            cell.accessoryType = .none
        }
        
        for (i, suger) in SugarLevel.allCases.enumerated() {
            if suger.rawValue == order?.sugarLevel {                sugarCells[i].accessoryType = .checkmark
                break
            }
        }
    }
    
    func updateIceCells() {
        for cell in iceCells {
            cell.accessoryType = .none
        }
        
        for (i, ice) in IceLevel.allCases.enumerated() {
            if ice.rawValue == order?.iceLevel {
                iceCells[i].accessoryType = .checkmark
                break
            }
        }
    }
    
    func updateSizeCells() {
        for cell in sizeCells {
            cell.accessoryType = .none
        }
        
        for (i, size) in Size.allCases.enumerated() {
            if size.rawValue == order?.size {
                sizeCells[i].accessoryType = .checkmark
                break
            }
        }
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "訂購成功", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    
    @IBAction func done(_ sender: Any) {
        guard let order else {
            return
        }
        
        let url = URL(string: "https://sheetdb.io/api/v1/ib1p6zbgu02av")!
        var reqeust = URLRequest(url: url)
        reqeust.httpMethod = "POST"
        reqeust.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        
        let orderBody = OrderBody(data: [order])
        reqeust.httpBody = try? encoder.encode(orderBody)
        URLSession.shared.dataTask(with: reqeust) { data, response, error in
            if let data {
                let decoder = JSONDecoder()
                do {
                    let dic = try decoder.decode([String:Int].self, from: data)
                    if dic["created"] == 1 {
                        DispatchQueue.main.async {
                            self.showSuccessAlert()
                        }
                    }
                } catch  {
                    print(error)
                }
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == sizeLargeIndexPath,
           drink?.info.l == nil {
            
            return 0

        } else {
            return UITableView.automaticDimension

        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let orderTableSection = OrderTableSection(rawValue: indexPath.section)
        
        switch orderTableSection {
        case .size:
            order?.size = Size.allCases[indexPath.row].rawValue
            if order?.size == Size.m.rawValue {
                order?.price = drink.info.m
            } else {
                order?.price = drink.info.l!

            }
            updateSizeCells()
        case .sugar:
            order?.sugarLevel = SugarLevel.allCases[indexPath.row].rawValue
            updateSugerCells()
        case .ice:
            order?.iceLevel = IceLevel.allCases[indexPath.row].rawValue
            updateIceCells()
        default:
            break
        }
        
        
    }
    

}
