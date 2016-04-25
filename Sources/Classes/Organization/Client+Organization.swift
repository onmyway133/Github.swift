//
//  Client+Organization.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Construction

public extension Client {

  // Fetches the organizations that the current user is a member of.
  //
  // Returns a signal which sends zero or more OCTOrganization objects. Private
  // organizations will only be included if the client is `authenticated`. If no
  // `user` is set, the signal will error immediately.
  public func fetchUserOrganizations() -> Observable<[Organization]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/orgs"
    }

    return enqueueUser(requestDescriptor).map {
      return Parser.all($0)
    }
  }


  // Fetches the specified organization's full information.
  //
  // Returns a signal which sends a new OCTOrganization.
  public func fetchOrganizationInfo(organization: Organization) -> Observable<Organization> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/orgs/\(organization.login)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }

  // Fetches the specified organization's teams.
  //
  // Returns a signal which sends zero or more OCTTeam objects. If the client is
  // not `authenticated`, the signal will error immediately.
  public func fetchTeams(organization: Organization) -> Observable<[Team]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/orgs/\(organization.login)/teams"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }
}
