//
//  SearchPhotosTests.swift
//  SearchPhotosTests
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import XCTest
@testable import SearchPhotos

class SearchPhotosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testJSONMapping() throws {
        
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockData", withExtension: "json") else {
            XCTFail("Missing json file")
            return
        }
        let data = try Data(contentsOf: url)
        
        if let parsedJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
            
            let responseObject = FetchPhotosResponse.init(dictionary: parsedJson)
            
            XCTAssertEqual(responseObject?.total, 281)
            XCTAssertEqual(responseObject?.totalPages, 10)
            XCTAssertEqual(responseObject?.results?.count, 30)
            XCTAssertEqual(responseObject?.results?.first?.id, "hBe-4XCUa3o")
            XCTAssertEqual(responseObject?.results?.first?.urls?.thumbnail, "https://images.unsplash.com/photo-1506726303195-92eb8c09e128?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjI3MTkxfQ&s=17d1acaf544b48ef0f798e8613a8f15a")
        }
        else {
            XCTFail("Parsing error")
        }
    }
    
    func testAPICall() {
        
        let expectation = self.expectation(description: "Completed")
        
        let fetchOperation = FetchImageListOperation(pageNumber: 0, searchQuery: "tiger") { (response, error) in
            
            XCTAssertNil(error, "Error should be nil")
            XCTAssertNotNil(response, "Response should not be nil")
            

            expectation.fulfill()
        }
        
        let operationQueue = OperationQueue()
        operationQueue.addOperation(fetchOperation)
        
        waitForExpectations(timeout: 6, handler: nil)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
