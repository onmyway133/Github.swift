//
//  Client+Server.swift
//  GithubSwift
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {
  
  // Makes a request to the given GitHub server to determine its metadata.
  //
  // server - The server to retrieve metadata for. This must not be nil.
  //
  // Returns a signal which will send an `OCTServerMetadata` object then complete on
  // success, or else error. If the server is too old to support this request,
  // an error will be sent with code `OCTClientErrorUnsupportedServer`.
  public static func fetchMetadata(server: Server) -> Observable<ServerMetadata> {
    let client = Client(server: server)
    let request = RequestDescriptor().then {
      $0.path = "meta"
    }
    
    return client.enqueue(request)
      .map {
        return Parser.one($0.jsonArray)
      }.catchError { _ in 
        let secureServer = Server.HTTPSEnterpriseServer(server)
        // if (error.code == OCTClientErrorUnsupportedServerScheme)
        return Client.fetchMetadata(secureServer)
      }.debug("+fetchMetadataForServer: \(server)")
  }
}
