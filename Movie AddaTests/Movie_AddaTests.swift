//
//  Movie_AddaTests.swift
//  Movie AddaTests
//
//  Created by Pritesh Nandgaonkar on 30/04/16.
//  Copyright © 2016 Pritesh Nandgaonkar. All rights reserved.
//

import XCTest
import Foundation
@testable import Movie_Adda

class Movie_AddaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSearchAPI() {
        let str = Constants.OMDBBaseURL+"s=\("dil")"
        let url = NSURL.init(string: str)!
        
        let expectation = expectationWithDescription("GET \(str)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            
            guard let urlResponse = response as? NSHTTPURLResponse else {
                XCTFail("Response is not of type NSHTTPURLresponse")
                return
            }
            
            XCTAssertEqual(urlResponse.URL?.absoluteString, url.absoluteString!, "HTTP URL should be equal to \(url.absoluteString)")
            XCTAssertEqual(urlResponse.statusCode, 200, "Status code should be 200")

            guard let data = data, jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
                
                XCTFail("Either Data is nil or serialization failed")
                return
            }
            
            guard let movieArray = jsonDict["Search"] as AnyObject as? [[String:String]] else {
                XCTFail("Value in Search key is not of type [[String: String]]")
                return
            }
            for movie in movieArray {
                XCTAssertNotNil(movie["Title"])
                XCTAssertNotNil(movie["Year"])
                XCTAssertNotNil(movie["imdbID"])
                XCTAssertNotNil(movie["Type"])
                XCTAssertNotNil(movie["Poster"])
            }

            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
