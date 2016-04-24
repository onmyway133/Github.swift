//
//  GistEditSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class GistEditSpec: QuickSpec {
  override func spec() {

    describe("gist edit") {
      it("can be serialized and deserialized") {
        let edit = GistEdit()

        edit.gistDescription = "The Description"
        edit.isPublicGist = true

        let fileEditAdd = GistFileEdit()
        fileEditAdd.fileName = "Add"
        fileEditAdd.content = "Add Content"
        edit.filesToAdd = [fileEditAdd]
        
        edit.fileNamesToDelete = ["Delete"]

        let fileEditModify = GistFileEdit()
        fileEditModify.fileName = "Modify"
        fileEditModify.content = "Modify Content"
        edit.filesToModify = [
          fileEditModify.fileName: fileEditModify,
        ]

        let expectedDict = [
          "public": edit.isPublicGist,
          "description": edit.gistDescription,
          "files": [
            fileEditAdd.fileName: [
              "content": fileEditAdd.content,
              "fileName": fileEditAdd.fileName,
            ],
            edit.fileNamesToDelete[0]: "",
            fileEditModify.fileName: [
              "content": fileEditModify.content,
              "fileName": fileEditModify.fileName,
            ]
          ]
        ]

        let editDict = edit.toJSON()
        expect(editDict).to(equal(expectedDict))
      }
    }
  }
}
