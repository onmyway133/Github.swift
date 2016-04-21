//
//  JSONEncodable.swift
//  GithubSwift
//
//  Created by Khoa Pham on 21/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar

public protocol JSONEncodable {
  func toJSON() -> JSONDictionary
}
