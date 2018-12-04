//
//  NetworkManagerTest.swift
//  SearchDemoTests
//
//  Created by Peigen.Liu on 12/4/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import XCTest
@testable import SearchDemo

class NetworkManagerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGood() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        NetworkManager.shared.get(api: "search", params: ["query":"cat" , "per_page":40 ], resultType: SearchPhotoResult.self) { (returnCode, result) in
            if returnCode >= 0 {
                XCTAssertTrue(result is SearchPhotoResult, "It should")
                let searchResult = result
                self.testSearchModel(result: searchResult!)
                XCTAssertTrue((searchResult?.totalResult)! > 0)

            }
        }
        
        
        NetworkManager.shared.get(api: "search", params: ["query":"NO_RESULT_KEYWORD" , "per_page":40 ], resultType: SearchPhotoResult.self) { (returnCode, result) in
            if returnCode >= 0 {
                let searchResult = result
                XCTAssertTrue((searchResult?.totalResult)! == 0)
                
            }
        }
        
        self.wait(for: [XCTestExpectation()], timeout: 10)
        
    }
    
    func testSearchModel(result : SearchPhotoResult) {
        
        XCTAssertGreaterThan(result.totalResult, 0)
        XCTAssertGreaterThan(result.page,0)
        XCTAssertNotNil(result.photos)
        XCTAssertNotNil(result.photos?.first?.photographer)
        XCTAssertNotNil(result.photos?.first?.photographerURL)
        XCTAssertNotNil(result.photos?.first?.url)


    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
