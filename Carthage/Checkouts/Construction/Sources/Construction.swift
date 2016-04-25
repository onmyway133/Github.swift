//
//  Construction.swift
//  Construction
//
//  Created by Khoa Pham on 24/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

// MARK: - Initable

/**
 Anything that can be init
*/
public protocol Initable {
  init()
}

// MARK: - Construct

/**
 Construct a struct and configure it
*/
public func construct<T: Initable>(@noescape block: inout T -> Void) -> T {
  var entity = T()
  block(&entity)

  return entity
}

// MARK: - Build

/**
 Build an existing struct
*/
public func build<T>(inout entity: T, @noescape block: inout T -> Void) -> T {
  block(&entity)
  return entity
}

/**
 Build an existing object
 */
public func build<T>(object: T, @noescape block: T -> Void) -> T {
  block(object)
  return object
}

// MARK: - Configurable

/**
 Anything that can be configured
*/
public protocol Configurable {}

public extension Configurable {

  /**
   Configure an object
  */
  func configure(@noescape block: Self -> Void) -> Self {
    block(self)
    return self
  }
}

