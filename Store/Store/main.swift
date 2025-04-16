//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name : String { get set }
    func price() -> Int
}

class Item : SKU {
    var name : String
    var priceEach : Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return priceEach
    }
}

class Receipt {
    var scannedItems : [Item]
    
    init() {
        self.scannedItems = []
    }
    
    func addItem(_ item : Item) {
        scannedItems.append(item)
    }
    
    func items() -> [Item] {
        return scannedItems
    }
    
    func total() -> Int {
        var totalPrice = 0
        for item in scannedItems {
            totalPrice += item.price()
        }
        return totalPrice
    }
    
    func output() -> String {
        var stringOutput = ""
        stringOutput += "Receipt:\n"
        for item in scannedItems {
            stringOutput += "\(item.name): $\(Double(item.priceEach) / 100)\n"
        }
        stringOutput += "------------------\n"
        stringOutput += "TOTAL: $\(Double(self.total()) / 100)"
        return stringOutput
    }
}

class Register {
    var receipt : Receipt
    
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku : Item) {
        receipt.addItem(sku)
    }
    
    func subtotal() -> Int {
        return receipt.total()
    }
    
    func total() -> Receipt {
        return receipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

