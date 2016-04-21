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

        fileEditAdd.filename = "Add"
        fileEditAdd.content = "Add Content"
        edit.filesToAdd = [fileEditAdd]
        edit.filenamesToDelete = ["Delete"]

        let fileEditModify = GistFileEdit()
        fileEditModify.filename = "Modify"
        fileEditModify.content = "Modify Content"
        edit.filesToModify = [
          fileEditModify.filename: fileEditModify,
        ]

        let expectedDict = [
          "public": edit.isPublicGist,
          "description": edit.gistDescription,
          "files": [
            fileEditAdd.filename: [
              "content": fileEditAdd.content,
              "filename": fileEditAdd.filename,
            ],
            edit.filenamesToDelete[0]: "",
            fileEditModify.filename: [
              "content": fileEditModify.content,
              "filename": fileEditModify.filename,
            ]
          ]
        ]

        let editDict = edit.toJSON()
        expect(editDict).to(equal(expectedDict))
      }
    }
  }
}
