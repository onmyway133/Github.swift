# Construction

The many ways to construct and configure your entity. Work for struct and class

[![CI Status](http://img.shields.io/travis/onmyway133/Construction.svg?style=flat)](https://travis-ci.org/onmyway133/Construction)
[![Version](https://img.shields.io/cocoapods/v/Construction.svg?style=flat)](http://cocoadocs.org/docsets/Construction)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Construction.svg?style=flat)](http://cocoadocs.org/docsets/Construction)
[![Platform](https://img.shields.io/cocoapods/p/Construction.svg?style=flat)](http://cocoadocs.org/docsets/Construction)

## Usage

### construct

- Free function
- Construct a struct and configure it

`Person`
```swift
struct Person {
  var name: String = ""
  var age: Int = 0
  var website: NSURL?

  init() {

  }
}

extension Person: Initable {}
```

```swift
let person: Person = construct {
  $0.name = "Luffy"
  $0.age = 17
}

XCTAssertEqual(person.name, "Luffy")
XCTAssertEqual(person.age, 17)
XCTAssertNil(person.website)
```

### build

- Free function
- Build an existing struct

```swift
var person = Person() // Declare as `var`
build(&person) {      // Use `&`
  $0.name = "Luffy"
  $0.age = 17
}

XCTAssertEqual(person.name, "Luffy")
XCTAssertEqual(person.age, 17)
XCTAssertNil(person.website)
```

- Build an existing object

`Car`
```swift
class Car {
  var model: String = ""
  var price: Int = 0
}

extension Car: Configurable {}
```

```swift
let car = build(Car()) {
  $0.model = "Tesla Model 3"
  $0.price = 35_000
}

XCTAssertEqual(car.model, "Tesla Model 3")
XCTAssertEqual(car.price, 35_000)
```

### configure

- Member function
- Configure existing object

```swift
let car = Car().configure {
  $0.model = "Tesla Model 3"
  $0.price = 35_000
}

XCTAssertEqual(car.model, "Tesla Model 3")
XCTAssertEqual(car.price, 35_000)
```

## Installation

**Construction** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Construction'
```

**Construction** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "onmyway133/Construction"
```

## Author

Khoa Pham, onmyway133@gmail.com

## Contributing

We would love you to contribute to **Construction**, check the [CONTRIBUTING](https://github.com/onmyway133/Construction/blob/master/CONTRIBUTING.md) file for more info.

## License

**Construction** is available under the MIT license. See the [LICENSE](https://github.com/onmyway133/Construction/blob/master/LICENSE.md) file for more info.
