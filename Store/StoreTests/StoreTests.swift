//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
//    ---MY TESTS---
    func testOneItemSubtotal() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
    }
    
    func testOneWeighedItem() {
        register.scan(WeighedItem(name: "Steak", lbs: 1.1, pricePerLB: 899))
        XCTAssertEqual(989, register.subtotal())
    }
    
    func testThreeDifferentWeighedItems() {
        register.scan(WeighedItem(name: "Steak", lbs: 1.1, pricePerLB: 899))
        register.scan(WeighedItem(name: "Apple", lbs: 2.3, pricePerLB: 499))
        register.scan(WeighedItem(name: "Eggplant", lbs: 3, pricePerLB: 149))
        XCTAssertEqual(2584, register.subtotal())
    }
    
    func testWeighedAndUnweighedItem() {
        register.scan(WeighedItem(name: "Steak", lbs: 1.1, pricePerLB: 899))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(1188, register.subtotal())
    }
    
    func testOneCoupon() {
        let beansCoupon = Coupon(discountedItem: "Beans", discountPerc: 15, used: false)
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199), beansCoupon)
        XCTAssertEqual(169, register.subtotal())
    }
    
    func testOneUnusedCouponsOneUsedCouponAndUndiscountedItems() {
        let beansCoupon = Coupon(discountedItem: "Beans", discountPerc: 15, used: false)
        let usedBeansCoupon = Coupon(discountedItem: "Beans", discountPerc: 15, used: true)
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199), beansCoupon)
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199), usedBeansCoupon)
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(467, register.subtotal())
    }
}
