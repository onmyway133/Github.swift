//
//  Organization.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// An organization.
public class Organization: Entity {
  
  // The OCTTeams in this organization.
  //
  // OCTClient endpoints do not actually set this property. It is provided as
  // a convenience for persistence and model merging.
  var teams: [Team] = []
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    teams <- map.relations("teams")
  }
}