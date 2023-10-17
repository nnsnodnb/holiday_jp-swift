//
//  HolidayJpTests.swift
//  holiday_jp-swift
//
//  Created by Pine Mizune on 2018/01/30.
//

import Foundation
import XCTest

@testable import HolidayJp

class HolidayJpTests: XCTestCase {
    func test_between() {
        let calendar = Calendar(identifier: .iso8601)
        
        // should have New Year's Day(2009-01-01) between 2009-01-01 and 2009-01-31
        let date1 = calendar.date(from: DateComponents(year: 2009, month: 1, day: 1))!
        let date2 = calendar.date(from: DateComponents(year: 2009, month: 1, day: 31))!
        let holidays1 = HolidayJp.between(date1, and: date2)
        let holidays2 = HolidayJp.between(date1, and: date2, calendar: calendar)
        XCTAssertEqual(holidays1[0].ymd, "2009-01-01")
        XCTAssertEqual(holidays2[0].ymd, "2009-01-01")

        // should have holiday between 2014-09-23 00:00:01 and 2014-09-23 00:00:01
        let date3 = calendar.date(from: DateComponents(year: 2014, month: 9, day: 23, hour: 0, minute: 0, second: 1))!
        let date4 = calendar.date(from: DateComponents(year: 2014, month: 9, day: 23, hour: 0, minute: 0, second: 1))!
        let holidays3 = HolidayJp.between(date3, and: date4)
        let holidays4 = HolidayJp.between(date3, and: date4, calendar: calendar)
        XCTAssertEqual(holidays3.count, 1)
        XCTAssertEqual(holidays4.count, 1)
    }
    
    func test_isHoliday_year_month_day() {
        // should be holiday returns date is holiday or not
        XCTAssertTrue(HolidayJp.isHoliday(year: 2011, month: 9, day: 19), "2011-09-19 is holiday")
        XCTAssertFalse(HolidayJp.isHoliday(year: 2011, month: 9, day: 18), "2011-09-18 is not holiday")

        // should be Mountain Day from 2016
        XCTAssertFalse(HolidayJp.isHoliday(year: 2015, month: 8, day: 11), "2015-08-11 is not holiday")
        for i in 2016..<2051 {
            if i == 2020 { // Tokyo Olympic
                XCTAssertTrue(HolidayJp.isHoliday(year: i, month: 8, day: 10), "\(i)-08-10 is holiday")
            } else if i == 2021 { // Tokyo Olympic
                XCTAssertTrue(HolidayJp.isHoliday(year: i, month: 7, day: 23), "\(i)-07-23 is holiday")
            } else {
                XCTAssertTrue(HolidayJp.isHoliday(year: i, month: 8, day: 11), "\(i)-08-11 is holiday")
            }
        }
    }

    func test_isHoliday_date() {
        let calendar = Calendar(identifier: .iso8601)
        
        // should be holiday returns date is holiday or not
        let date1 = calendar.date(from: DateComponents(year: 2011, month: 9, day: 19))!
        let date2 = calendar.date(from: DateComponents(year: 2011, month: 9, day: 18))!
        XCTAssertTrue(HolidayJp.isHoliday(date1), "2011-09-19 is holiday")
        XCTAssertTrue(HolidayJp.isHoliday(date1, calendar: calendar), "2011-09-19 is holiday")
        XCTAssertFalse(HolidayJp.isHoliday(date2), "2011-09-18 is not holiday")
        XCTAssertFalse(HolidayJp.isHoliday(date2, calendar: calendar), "2011-09-18 is not holiday")

        // should be Mountain Day from 2016
        let date3 = calendar.date(from: DateComponents(year: 2015, month: 8, day: 11))!
        XCTAssertFalse(HolidayJp.isHoliday(date3))
        XCTAssertFalse(HolidayJp.isHoliday(date3, calendar: calendar))
        for i in 2016..<2051 {
            let month: Int
            let day: Int
            if i == 2020 { // Tokyo Olympic
                month = 8
                day = 10
            } else if i == 2021 { // Tokyo Olympic
                month = 7
                day = 23
            } else {
                month = 8
                day = 11
            }
            let date4 = calendar.date(from: DateComponents(year: i, month: month, day: day))!
            XCTAssertTrue(HolidayJp.isHoliday(date4), String(format: "%4d-%0.2d-%0.2d is holiday", i, month, day))
            XCTAssertTrue(HolidayJp.isHoliday(date4, calendar: calendar), String(format: "%4d-%0.2d-%0.2d is holiday", i, month, day))
        }
    }
 
    static var allTests = [
        ("test_between", test_between),
        ("test_isHoliday_year_month_day", test_isHoliday_year_month_day),
        ("test_isHoliday_date", test_isHoliday_date),
    ]
}
