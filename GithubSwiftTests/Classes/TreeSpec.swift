//
//  TreeSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class TreeSpec: QuickSpec {
  override func spec() {

    describe("tree") {
      it("should initialize") {
        let tree = Tree(Helper.readJSON("tree") as JSONDictionary)

        expect(tree.SHA).to(equal("HEAD"))
        expect(tree.URL).to(equal(NSURL(string: "https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/git/trees/HEAD")))
        expect((tree.entries.count)).to(equal(4))

        let entry1 = tree.entries[0] as! BlobTreeEntry
        expect(entry1.path).to(equal("CHANGELOG.md"))
        expect(entry1.SHA).to(equal("bfcbe8a9b4efeee4ead492e9567f2d4c57acaeb7"))
        expect(entry1.URL!.absoluteString).to(equal("https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/git/blobs/bfcbe8a9b4efeee4ead492e9567f2d4c57acaeb7"))
        expect((entry1.type)).to(equal(TreeEntryKind.Blob))
        expect((entry1.mode)).to(equal(TreeEntryMode.File))
        expect((entry1.size)).to(equal(17609))

        let entry2 = tree.entries[1] as! ContentTreeEntry
        expect(entry2.path).to(equal("Documentation"))
        expect(entry2.SHA).to(equal("5e40845071aa4b59612ef57d2602662de008725d"))
        expect(entry2.URL!.absoluteString).to(equal("https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/git/trees/5e40845071aa4b59612ef57d2602662de008725d"))
        expect((entry2.type)).to(equal(TreeEntryKind.Tree))
        expect((entry2.mode)).to(equal(TreeEntryMode.Subdirectory))

        let entry3 = tree.entries[2] as! CommitTreeEntry
        expect(entry3.path).to(equal("TransformerKit"))
        expect(entry3.SHA).to(equal("1617ae09f662dc252805d818ae8a82626700523a"))
        expect((entry3.type)).to(equal(TreeEntryKind.Commit))
        expect((entry3.mode)).to(equal(TreeEntryMode.Submodule))

        let entry4 = tree.entries[3] as! BlobTreeEntry
        expect(entry4.path).to(equal("ReactiveCocoaFramework/ReactiveCocoa/RACBehaviorSubject.m"))
        expect(entry4.SHA).to(equal("dfda2ac07356f34e422df17673fc8148fae7d3b9"))
        expect((entry4.type)).to(equal(TreeEntryKind.Blob))
        expect((entry4.mode)).to(equal(TreeEntryMode.File))
        expect(entry4.URL!.absoluteString).to(equal("https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/git/blobs/dfda2ac07356f34e422df17673fc8148fae7d3b9"))
        expect((entry4.size)).to(equal(1209))
      }
    }
  }
}
