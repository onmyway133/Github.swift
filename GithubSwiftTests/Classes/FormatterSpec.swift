//
//  FormatterSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class FormatterSpec: QuickSpec {
  override func spec() {
    describe("formatter") {
      var calendar: NSCalendar!
      
      beforeEach {
        calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
      }
      
      it("should parse an ISO 8601 string into a date and back") {
        let string = "2011-01-26T19:06:43Z"
        
        let components = NSDateComponents().then {
          $0.day = 26;
          $0.month = 1;
          $0.year = 2011;
          $0.hour = 19;
          $0.minute = 6;
          $0.second = 43;
        }
        
        let date = Formatter.date(string: string)
        expect(date).toNot(beNil())
        expect(date).to(equal(calendar.dateFromComponents(components)))
        expect(Formatter.string(date: date!)).to(equal(string))
      }
      
      it("shouldn't use ISO week-numbering year") {
        let string = "2012-01-01T00:00:00Z"
        
        let components = NSDateComponents().then {
          $0.day = 1;
          $0.month = 1;
          $0.year = 2012;
          $0.hour = 0;
          $0.minute = 0;
          $0.second = 0;
        }
        
        let date = Formatter.date(string: string)
        expect(date).toNot(beNil())
        expect(date).to(equal(calendar.dateFromComponents(components)))
        expect(Formatter.string(date: date!)).to(equal(string))
      }
    }
  }
}
