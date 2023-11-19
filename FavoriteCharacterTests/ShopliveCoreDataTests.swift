//
//  FavoriteCharacterCoreDataTests.swift
//  FavoriteCharacterCoreDataTests
//
//  Created by Terry Koo on 11/15/23.
//

import XCTest
import CoreData

@testable import FavoriteCharacter

final class FavoriteCharacterCoreDataTests: XCTestCase {

    var coreDataManager: FavoriteCharacterCoreDataManager!
       
       override func setUp() {
           super.setUp()
           coreDataManager = FavoriteCharacterCoreDataManager()
           CoreDataStack.shared.reset()
       }
       
       override func tearDown() {
           coreDataManager = nil
           super.tearDown()
           CoreDataStack.shared.reset()
       }
       
       func testSaveFavoriteCharacter() {
           let expectation = XCTestExpectation(description: "Save favorite character")
           
           coreDataManager.saveFavoriteCharacter(id: "1",
                                            characterName: "TestName",
                                            characterDescription: "TestDescription",
                                            characterImage: "TestImage",
                                            saveDate: Date()) {
                                               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 5.0)
           
           let fetchExpectation = XCTestExpectation(description: "Fetch favorite characters")
           coreDataManager.fetchFavoriteCharacters { characters in
               XCTAssertEqual(characters.count, 1)
               
               let savedCharacter = characters.first
               XCTAssertEqual(savedCharacter?.id, "1")
               XCTAssertEqual(savedCharacter?.characterName, "TestName")
               XCTAssertEqual(savedCharacter?.characterDescription, "TestDescription")
               XCTAssertEqual(savedCharacter?.characterImage, "TestImage")
               
               fetchExpectation.fulfill()
           }
           
           wait(for: [fetchExpectation], timeout: 5.0)
       }
       
    func testRemoveFavoriteCharacter() {
        // 미리 데이터를 저장
        let saveExpectation = XCTestExpectation(description: "Save favorite character")
        coreDataManager.saveFavoriteCharacter(id: "1",
                                         characterName: "TestName",
                                         characterDescription: "TestDescription",
                                         characterImage: "TestImage",
                                         saveDate: Date()) {
                                            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 5.0)
        
        let saveExpectation1 = XCTestExpectation(description: "Save favorite character")
        coreDataManager.saveFavoriteCharacter(id: "2",
                                         characterName: "TestName",
                                         characterDescription: "TestDescription",
                                         characterImage: "TestImage",
                                         saveDate: Date()) {
                                            saveExpectation1.fulfill()
        }
        wait(for: [saveExpectation1], timeout: 5.0)
        
        // 저장된 데이터를 삭제
        let removeExpectation = XCTestExpectation(description: "Remove favorite character")
        coreDataManager.removeFavoriteCharacter(id: "1") {
            removeExpectation.fulfill()
        }
        wait(for: [removeExpectation], timeout: 5.0)
        
        // 저장된 데이터를 삭제
        let removeExpectation1 = XCTestExpectation(description: "Remove favorite character")
        coreDataManager.removeFavoriteCharacter(id: "2") {
            removeExpectation1.fulfill()
        }
        wait(for: [removeExpectation1], timeout: 5.0)
        
        

        // 삭제 후 데이터가 없는지 확인
        let fetchExpectation = XCTestExpectation(description: "Fetch favorite characters")
        coreDataManager.fetchFavoriteCharacters { characters in
            XCTAssertEqual(characters.count, 0)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 5.0)
    }
    
    func testRemoveOldestFavoriteCharacter() {
        // 미리 데이터를 저장
        let saveExpectation = XCTestExpectation(description: "Save favorite character")
        coreDataManager.saveFavoriteCharacter(id: "1",
                                         characterName: "TestName",
                                         characterDescription: "TestDescription",
                                         characterImage: "TestImage",
                                         saveDate: Date()) {
                                            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 5.0)

        // 저장된 데이터를 삭제
        let removeExpectation = XCTestExpectation(description: "Remove oldest favorite character")
        coreDataManager.removeOldestFavoriteCharacter {
            removeExpectation.fulfill()
        }
        wait(for: [removeExpectation], timeout: 5.0)

        // 삭제 후 데이터가 없는지 확인
        let fetchExpectation = XCTestExpectation(description: "Fetch favorite characters")
        coreDataManager.fetchFavoriteCharacters { characters in
            XCTAssertEqual(characters.count, 0)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 5.0)
    }
       
       func testFetchFavoriteCharacters() {
           // 미리 데이터를 저장
           let saveExpectation = XCTestExpectation(description: "Save favorite character")
           coreDataManager.saveFavoriteCharacter(id: "1",
                                            characterName: "TestName",
                                            characterDescription: "TestDescription",
                                            characterImage: "TestImage",
                                            saveDate: Date()) {
                                               saveExpectation.fulfill()
           }
           wait(for: [saveExpectation], timeout: 5.0)
           
           // 데이터를 가져와서 확인
           let fetchExpectation = XCTestExpectation(description: "Fetch favorite characters")
           coreDataManager.fetchFavoriteCharacters { characters in
               XCTAssertEqual(characters.count, 1)
               
               let fetchedCharacter = characters.first
               XCTAssertEqual(fetchedCharacter?.id, "1")
               XCTAssertEqual(fetchedCharacter?.characterName, "TestName")
               XCTAssertEqual(fetchedCharacter?.characterDescription, "TestDescription")
               XCTAssertEqual(fetchedCharacter?.characterImage, "TestImage")
               
               fetchExpectation.fulfill()
           }
           wait(for: [fetchExpectation], timeout: 5.0)
       }

}
