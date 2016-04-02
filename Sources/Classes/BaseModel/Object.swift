//
//  Object.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// The base model class for any objects retrieved through the GitHub API.
public class Object: Mappable, Hashable, Equatable {
  
  // The unique ID for this object. This is only guaranteed to be unique among
  // objects of the same type, from the same server.
  //
  // By default, the JSON representation for this property assumes a numeric
  // representation (which is the case for most API objects). Subclasses may
  // override the `+objectIDJSONTransformer` method to change this behavior.
  public var objectID: String = ""
  
  // The server this object is associated with.
  //
  // This object is not encoded into JSON.
  public var server: Server?
  
  public required init(_ map: JSONDictionary) {
    objectID <- map.transform("id", transformer: Transformer.numberToString)
  }
  
  // MARK: - Hash
  public var hashValue: Int {
    return server?.hashValue ?? 0 ^ objectID.hashValue
  }
}

public func ==(lhs: Object, rhs: Object) -> Bool {
  if lhs === rhs {
    return true
  }
  
  return lhs.hashValue == rhs.hashValue
}
