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

protocol PricingSchema {
    func calculatePrice(_ scannedItems : [Item]) -> Int
}

class StandardPricing : PricingSchema {
    func calculatePrice(_ scannedItems : [Item]) -> Int {
        var totalPrice = 0
        for item in scannedItems {
            totalPrice += item.price()
        }
        return totalPrice
    }
}

class WeighedItem : SKU {
    var name : String
    var lbs : Double
    var pricePerLB : Int
    
    init(name: String, lbs: Double, pricePerLB: Int) {
        self.name = name
        self.lbs = lbs
        self.pricePerLB = pricePerLB
    }
    
    func price() -> Int {
        return Int(round(Double(pricePerLB) * lbs))
    }
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

class Coupon {
    var discountedItem : String
    var discountPerc : Int
    
    init(discountedItem: String, discountPerc: Int) {
        self.discountedItem = discountedItem
        self.discountPerc = discountPerc
    }
    
    
}

class Receipt {
    var scannedItems : [SKU]
    
    init() {
        self.scannedItems = []
    }
    
    func addItem(_ item : SKU) {
        scannedItems.append(item)
    }
    
    func items() -> [SKU] {
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
            stringOutput += "\(item.name): $\(Double(item.price()) / 100)\n"
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
    
    func scan(_ sku : SKU) {
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

