//
//  Tests.swift
//  Construction
//
//  Created by Khoa Pham on 24/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import XCTest
import Construction

struct Person {
  var name: String = ""
  var age: Int = 0
  var website: NSURL?

  init() {

  }
}

extension Person: Initable {}

class Car {
  var model: String = ""
  var price: Int = 0
}

extension Car: Configurable {}

public class Tests: XCTestCase {
  func testConstruct() {
    let person: Person = construct {
      $0.name = "Luffy"
      $0.age = 17
    }

    XCTAssertEqual(person.name, "Luffy")
    XCTAssertEqual(person.age, 17)
    XCTAssertNil(person.website)
  }

  func testBuildStruct() {
    var person = Person()
    build(&person) {
      $0.name = "Luffy"
      $0.age = 17
    }

    XCTAssertEqual(person.name, "Luffy")
    XCTAssertEqual(person.age, 17)
    XCTAssertNil(person.website)
  }

  func testBuildObject() {
    let car = build(Car()) {
      $0.model = "Tesla Model 3"
      $0.price = 35_000
    }

    XCTAssertEqual(car.model, "Tesla Model 3")
    XCTAssertEqual(car.price, 35_000)
  }

  func testConfigurable() {
    let car = Car().configure {
      $0.model = "Tesla Model 3"
      $0.price = 35_000
    }

    XCTAssertEqual(car.model, "Tesla Model 3")
    XCTAssertEqual(car.price, 35_000)
  }
}
