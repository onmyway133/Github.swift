//
//  String+Extensions.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public extension String {
  public var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
