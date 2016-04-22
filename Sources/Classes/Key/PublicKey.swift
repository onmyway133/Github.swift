//
//  PublicKey.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A public SSH key
public class PublicKey: Object {

  // The public key data itself.
  public private(set) var publicKey: String = ""

  // The name given to this key by the user.
  public private(set) var title: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.publicKey <- map.property("key")
    self.title <- map.property("title")
  }
}

extension PublicKey: JSONEncodable {
  public func toJSON() -> JSONDictionary {
    return [
      "key": publicKey,
      "title": title
    ]
  }
}
