//
//  OrderViewModel.swift
//  HotCoffe
//
//  Created by Jose Manuel Malagón Alba on 9/12/21.
//

import Foundation

//MARK: - OrderListViewModel
class OrderListViewModel {
    
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
    
}

extension OrderListViewModel {
    
    func orderViewModel(atIndex index: Int) -> OrderViewModel {
        return self.ordersViewModel[index]
    }
    
}

//MARK: - OrderViewModel
struct OrderViewModel {
    let order: Order
    
}

extension OrderViewModel {
    var name: String {
        return self.order.name
    }
    
    var price: Double {
        return self.order.total
    }
    
    var type: String {
        return self.order.coffeeName.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}

