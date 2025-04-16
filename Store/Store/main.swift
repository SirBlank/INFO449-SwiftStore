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
    var used : Bool
    
    init(discountedItem: String, discountPerc: Int, used: Bool) {
        self.discountedItem = discountedItem
        self.discountPerc = discountPerc
        self.used = used
    }
    
    func useCoupon() {
        used = true
    }
    
    func getDiscount() -> Double {
        return Double(100 - discountPerc) / 100
    }
}

class RainCheck {
    var rainChecks : [String : Int]
    
    init(_ rainChecks: [String : Int]) {
        self.rainChecks = rainChecks
    }
    
    func getRainChecks() -> [String : Int]{
        return rainChecks
    }
    
    func addRainCheck(_ itemName : String, _ specialPrice : Int) {
        if rainChecks.keys.contains(itemName) {
            print("Rain check already exist, updating to given special price")
            rainChecks[itemName] = specialPrice
        } else {
            rainChecks[itemName] = specialPrice
        }
    }
    
    func removeRainCheck(_ itemName : String) {
        if rainChecks.keys.contains(itemName) {
            rainChecks.removeValue(forKey: itemName)
        } else {
            print("The given rain check does not exist")
        }
    }
}

class Receipt {
    var scannedItems : [SKU]
    var scannedCoupons : [Coupon]
    
    init() {
        self.scannedItems = []
        self.scannedCoupons = []
    }
    
    func addItem(_ item : SKU) {
        scannedItems.append(item)
    }
    
    func addCoupon(_ coupon : Coupon) {
        scannedCoupons.append(coupon)
    }
    
    func items() -> [SKU] {
        return scannedItems
    }
    
    func coupons() -> [Coupon] {
        return scannedCoupons
    }
    
    func total() -> Int {
        var totalPrice = 0
        for item in scannedItems {
            if let couponIndex = scannedCoupons.firstIndex(where: { coupon in !coupon.used && item.name.contains(coupon.discountedItem)}) {
                let coupon = scannedCoupons[couponIndex]
                totalPrice += Int(round(Double(item.price()) * coupon.getDiscount()))
                coupon.useCoupon()
            } else {
                totalPrice += item.price()
            }
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
    var rainCheck : RainCheck?
    
    init(_ rainCheck : RainCheck? = RainCheck([String : Int]())) {
        self.receipt = Receipt()
        self.rainCheck = rainCheck
    }
    
    func scan(_ sku : SKU, _ coupon : Coupon? = nil) {
        if let coupon = coupon {
            receipt.addCoupon(coupon)
        }
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

