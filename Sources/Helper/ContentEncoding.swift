//
//  ContentEncoding.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

// The types of content encodings
//   OCTContentEncodingUTF8   - utf-8
//   OCTContentEncodingBase64 - base64
public enum ContentEncoding: String {
  case UTF8 = "utf-8"
  case Base64 = "base64"
}
