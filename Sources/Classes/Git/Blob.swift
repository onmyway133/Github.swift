//
//  Blob.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

public class Blob: Mappable {

  public private(set) var data: NSData?

  public required init(_ map: JSONDictionary) {

  }
}