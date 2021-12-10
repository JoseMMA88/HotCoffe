//
//  AddOrderViewController.swift
//  HotCoffe
//
//  Created by Jose Manuel Malagón Alba on 9/12/21.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(_ view: AddOrderViewController, order: Order)
    func addCoffeeOrderViewControllerDidClose(_ view: AddOrderViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    //MARK: Variables
    private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    var delegate: AddCoffeeOrderDelegate?
    
    //MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    private func setupUI() {
        
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: vm.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell")
        
        cell?.textLabel?.text = self.vm.types[indexPath.row]
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    
    //MARK: UITextFieldDelegate
    
    
    //MARK: Actions
    @IBAction func saveButtonTapped(){
        
        let name = self.nameTextField.text
        let price = self.priceTextField.text
        
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error selecting coffee")
        }
        
        self.vm.name = name
        self.vm.price = Double(price ?? "0.00")
        self.vm.selectedType = self.vm.types[indexPath.row]
        self.vm.selectedSize = selectedSize
    
        WebService().load(resource: Order.create(vm: self.vm)) { result in
            
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(self, order: order)
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
    @IBAction func closeButtonTapped() {
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(self)
        }
        
    }
    
    
    
}
