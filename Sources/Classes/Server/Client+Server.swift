//
//  Client+Server.swift
//  GithubSwift
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Construction

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
    let request: RequestDescriptor = construct {
      $0.path = "meta"
    }
    
    return client.enqueue(request)
      .map {
        return Parser.one($0.jsonArray)
      }.catchError { error in
        let error = error as NSError
        if error.code == ErrorCode.UnsupportedServerScheme.rawValue {
          let secureServer = Server.HTTPSEnterpriseServer(server)
          return Client.fetchMetadata(secureServer)
        } else if let statusCode = error.userInfo[ErrorKey.HTTPStatusCodeKey.rawValue] as? Int
          where statusCode == ErrorCode.NotFound.rawValue {
          return Observable<ServerMetadata>.error(Error.unsupportedVersionError())
        } else {
          return Observable<ServerMetadata>.error(error)
        }
      }.debug("+fetchMetadataForServer: \(server)")
  }
}
