//
//  OrdersTableViewController.swift
//  HotCoffe
//
//  Created by Jose Manuel Malagón Alba on 9/12/21.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController, AddCoffeeOrderDelegate {
    
    var orderListViewModel = OrderListViewModel()
    
    //MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
        
    }
    
    private func populateOrders() {
        
        WebService().load(resource: Order.all) { [weak self] result in
            
            switch result {
            case .success(let orders):
                self?.orderListViewModel.ordersViewModel = orders.map({ order in
                    OrderViewModel(order: order)
                })
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: TableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.orderListViewModel.orderViewModel(atIndex: indexPath.row)
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
            
    return cell
        
    }
    
    //MARK: AddCoffeDelegate
    func addCoffeeOrderViewControllerDidSave(_ view: AddOrderViewController, order: Order) {
        view.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addCoffeeOrderViewControllerDidClose(_ view: AddOrderViewController) {
        view.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToAddOrder"){
            guard let nav = segue.destination as? UINavigationController else { return }
            
            if let addCoffeeOrderVC = nav.viewControllers.first as? AddOrderViewController {
                addCoffeeOrderVC.delegate = self
            }
        }
    }
    
    
}
