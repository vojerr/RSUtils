//
//  RSUtilsTests.swift
//  RSUtilsTests
//
//  Created by Ruslan Samsonov on 4/16/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

import XCTest
@testable import RSUtils

class RSUtilsTests: XCTestCase {
    private let taskPerformer = DataTaskPerformer()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.å
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class Test {
        var t: Int = 0
    }
    
    func testExample() {
        let weakArray = WeakObjectsArray<Test>()
        let count = 20;
        let t = Test()
        t.t = 666
        weakArray.add(t)
        for i in 0...count-1 {
            let t = Test()
            t.t = i
            weakArray.add(t)
        }
        weakArray.add(Test())
        
        assert(weakArray.rawCount() == count + 2)
        weakArray.forEach({
            print($0.t)
        })
        assert(weakArray.count() == 1)
    }
    
    func testTaskPerformer() {
        for i in 0...100 {
            do {
                try taskPerformer.performTask({
                    print("TASK \(i) processing")
                    }, completion: {
                        print("TASK \(i) finished")
                })
            } catch {
                
            }
        }
        print("ENDED")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
