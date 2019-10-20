//
//  CrimeStreamTests.swift
//  CrimeStreamTests
//
//  Created by Mattes Wieben on 12.10.19.
//  Copyright © 2019 matscodes. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CrimeStream

class CrimeStreamTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHelloRxSwift() {
        let observable = Observable.from([1, 2, 3])
        observable.subscribe { event in print(event)}
    }
    
    let disposeBag = DisposeBag()
    func testHelloRxSwiftExtended() {
        let observable = Observable.from([1, 2, 3])
        observable.subscribe { event in
            switch event {
                case .next(let value):
                    print(value)
                case .error(let error):
                    print(error)
                case .completed:
                    print("Completed")
            }
        }.disposed(by: disposeBag)
    }
    
    func testMap() {
        let observable = Observable.from([1, 2, 3])
        observable
            .map{value in value * 10}
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
    }
    
    func testScan() {
        let observable = Observable.from([1, 2, 3, 4, 5])
        observable
            .scan(0) {seed, value in seed + value}
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
    }
    
    func testFilter() {
        let observable = Observable.from([2, 30, 22, 5, 60, 1])
        observable
            .filter {$0 > 10}
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
    }
    
    func testZip() {
        let numbers = Observable.from([1, 2, 3, 4, 5, 1])
        let letters = Observable.from(["A", "B", "C", "D"])
        
        Observable.zip(numbers, letters) { return ($0, $1) }
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
    }
    
    
    func testWarnsystem(){
        // Der scheduler wird die Test-Events zu definierten Zeitpunkten simulieren
        let scheduler = TestScheduler(initialClock: 0)
        
        // Definition der Funksprüche, die emittiert werden
        let funkspruch1 = Funkspruch(desc: "Writing a callback-pyramid",
                               severity: 10,
                               requiresHero: true)
        let funkspruch2 = Funkspruch(desc: "Not testing your Rx-Code",
                                severity: 6,
                                requiresHero: false)
        
        // Erstellen eines Observables mit den definieren Funksprüchen
        let funkObservable = scheduler.createHotObservable([
            Recorded.next(1, funkspruch1),
            Recorded.next(4, funkspruch2),
            Recorded.completed(6)
            ]).asObservable();
        
        // Definition der Tweets, die emittiert werden
        let tweet1 = Tweet(location: "Coding Valley",
                           text: "Let's go and deploy.")
        let tweet2 = Tweet(location: "Coding Valley",
                           text: "Bug in Production. Please send help!")
        let tweet3 = Tweet(location: "Somewhere else",
                           text: "Boring day.")
        
        // Erstellen eines Observables mit den definierten Tweets
        let tweetObservable = scheduler.createHotObservable([
            Recorded.next(2, tweet1),
            Recorded.next(3, tweet2),
            Recorded.next(5, tweet3),
            Recorded.completed(8)
            ]).asObservable();
        
        // Definition der Events, die als Ausgabe des Warnsystems erwartet werden.
        let expectedEvents = [
            Recorded.next(1, Event(desc: "Writing a callback-pyramid")),
            Recorded.next(3, Event(desc: "Bug in Production. Please send help!")),
            Recorded.completed(8)
        ]
        
        // Initialisierung des Warnsystems
        let warnsystem = Warnsystem(polizeiFunk: funkObservable, twitterFeed: tweetObservable)
        
        // Zuweisung des AusgabeStreams zu einem TestObserver, sodass die
        // Ergebnisse mit den erwarteten Ergebnissen verglichen werden können
        let testObserver = scheduler.createObserver(Event.self)
        warnsystem.eventStream
            .subscribe(testObserver)
            .disposed(by: disposeBag)
        
        // Start der Erzeugung der Events
        scheduler.start()
        
        // Vergleich der Ausgabe mit der erwarteten Ausgabe
        XCTAssertEqual(expectedEvents, testObserver.events)
    }
}
