//
//  Order.swift
//  HotCoffe
//
//  Created by Jose Manuel Malagón Alba on 9/12/21.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case lattee
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let coffeeName: CoffeeType
    let total: Double
    let size: CoffeeSize
}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://island-bramble.glitch.me/orders") else {
            fatalError("URL incorrect")
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(vm)
        
        guard let url = URL(string: "https://island-bramble.glitch.me/orders") else {
            fatalError("URL incorrect")
        }
        
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Encode error")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.method = .post
        resource.body = data
        
        return resource
    }
}

extension Order {
    
    init?(_ vm: AddCoffeeOrderViewModel) {
        
        guard let name = vm.name,
              let price = vm.price,
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
                  return nil
              }
        
        self.name = name
        self.total = price
        self.coffeeName = selectedType
        self.size = selectedSize
        
    }
}
