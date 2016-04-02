//
//  Password.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

// The medium used to deliver the one-time password.
//
// OCTClientOneTimePasswordMediumSMS - Delivered via SMS.
// OCTClientOneTimePasswordMediumApp - Delivered via an app.
public enum OneTimePasswordMedium {
  case SMS
  case App
}
