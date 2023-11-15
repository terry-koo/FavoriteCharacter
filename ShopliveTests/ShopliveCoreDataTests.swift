//
//  ShopliveCoreDataTests.swift
//  ShopliveCoreDataTests
//
//  Created by Terry Koo on 11/15/23.
//

import XCTest
import CoreData

@testable import Shoplive

final class ShopliveCoreDataTests: XCTestCase {

    var coreDataManager: FavoriteCardCoreDataManager!
       
       override func setUp() {
           super.setUp()
           coreDataManager = FavoriteCardCoreDataManager()
           CoreDataStack.shared.reset()
       }
       
       override func tearDown() {
           coreDataManager = nil
           super.tearDown()
           CoreDataStack.shared.reset()
       }
       
       func testSaveFavoriteCard() {
           let expectation = XCTestExpectation(description: "Save favorite card")
           
           coreDataManager.saveFavoriteCard(id: "1",
                                            characterName: "TestName",
                                            characterDescription: "TestDescription",
                                            characterImage: "TestImage",
                                            saveDate: Date()) {
                                               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 5.0)
           
           let fetchExpectation = XCTestExpectation(description: "Fetch favorite cards")
           coreDataManager.fetchFavoriteCards { cards in
               XCTAssertEqual(cards.count, 1)
               
               let savedCard = cards.first
               XCTAssertEqual(savedCard?.id, "1")
               XCTAssertEqual(savedCard?.characterName, "TestName")
               XCTAssertEqual(savedCard?.characterDescription, "TestDescription")
               XCTAssertEqual(savedCard?.characterImage, "TestImage")
               
               fetchExpectation.fulfill()
           }
           
           wait(for: [fetchExpectation], timeout: 5.0)
       }
       
    func testRemoveFavoriteCard() {
        // 미리 데이터를 저장
        let saveExpectation = XCTestExpectation(description: "Save favorite card")
        coreDataManager.saveFavoriteCard(id: "1",
                                         characterName: "TestName",
                                         characterDescription: "TestDescription",
                                         characterImage: "TestImage",
                                         saveDate: Date()) {
                                            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 5.0)
        
        let saveExpectation1 = XCTestExpectation(description: "Save favorite card")
        coreDataManager.saveFavoriteCard(id: "2",
                                         characterName: "TestName",
                                         characterDescription: "TestDescription",
                                         characterImage: "TestImage",
                                         saveDate: Date()) {
                                            saveExpectation1.fulfill()
        }
        wait(for: [saveExpectation1], timeout: 5.0)
        
        // 저장된 데이터를 삭제
        let removeExpectation = XCTestExpectation(description: "Remove favorite card")
        coreDataManager.removeFavoriteCard(id: "1") {
            removeExpectation.fulfill()
        }
        wait(for: [removeExpectation], timeout: 5.0)
        
        // 저장된 데이터를 삭제
        let removeExpectation1 = XCTestExpectation(description: "Remove favorite card")
        coreDataManager.removeFavoriteCard(id: "2") {
            removeExpectation1.fulfill()
        }
        wait(for: [removeExpectation1], timeout: 5.0)
        
        

        // 삭제 후 데이터가 없는지 확인
        let fetchExpectation = XCTestExpectation(description: "Fetch favorite cards")
        coreDataManager.fetchFavoriteCards { cards in
            XCTAssertEqual(cards.count, 0)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 5.0)
    }
    
    func testRemoveOldestFavoriteCard() {
        // 미리 데이터를 저장
        let saveExpectation = XCTestExpectation(description: "Save favorite card")
        coreDataManager.saveFavoriteCard(id: "1",
                                         characterName: "TestName",
                                         characterDescription: "TestDescription",
                                         characterImage: "TestImage",
                                         saveDate: Date()) {
                                            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 5.0)

        // 저장된 데이터를 삭제
        let removeExpectation = XCTestExpectation(description: "Remove oldest favorite card")
        coreDataManager.removeOldestFavoriteCard {
            removeExpectation.fulfill()
        }
        wait(for: [removeExpectation], timeout: 5.0)

        // 삭제 후 데이터가 없는지 확인
        let fetchExpectation = XCTestExpectation(description: "Fetch favorite cards")
        coreDataManager.fetchFavoriteCards { cards in
            XCTAssertEqual(cards.count, 0)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 5.0)
    }
       
       func testFetchFavoriteCards() {
           // 미리 데이터를 저장
           let saveExpectation = XCTestExpectation(description: "Save favorite card")
           coreDataManager.saveFavoriteCard(id: "1",
                                            characterName: "TestName",
                                            characterDescription: "TestDescription",
                                            characterImage: "TestImage",
                                            saveDate: Date()) {
                                               saveExpectation.fulfill()
           }
           wait(for: [saveExpectation], timeout: 5.0)
           
           // 데이터를 가져와서 확인
           let fetchExpectation = XCTestExpectation(description: "Fetch favorite cards")
           coreDataManager.fetchFavoriteCards { cards in
               XCTAssertEqual(cards.count, 1)
               
               let fetchedCard = cards.first
               XCTAssertEqual(fetchedCard?.id, "1")
               XCTAssertEqual(fetchedCard?.characterName, "TestName")
               XCTAssertEqual(fetchedCard?.characterDescription, "TestDescription")
               XCTAssertEqual(fetchedCard?.characterImage, "TestImage")
               
               fetchExpectation.fulfill()
           }
           wait(for: [fetchExpectation], timeout: 5.0)
       }

}
