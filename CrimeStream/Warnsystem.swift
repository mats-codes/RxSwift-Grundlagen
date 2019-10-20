//
//  CrimeObserver.swift
//  CrimeStream
//
//  Created by Mattes Wieben on 12.10.19.
//  Copyright © 2019 matscodes. All rights reserved.
//

import Foundation
import RxSwift

struct Warnsystem {
    let eventStream: Observable<Event>
    
    init(polizeiFunk: Observable<Funkspruch>, twitterFeed: Observable<Tweet>) {
        eventStream = Observable.of(
            polizeiFunk
                .filter {$0.requiresHero && $0.severity > 7}
                .map {funkspruch in return Event(desc: funkspruch.desc)},
            twitterFeed
                .filter {$0.location == "Coding Valley" && $0.text.contains("Bug")}
                .map {tweet in return Event(desc: tweet.text)}
            ).merge()
            // merge führt zwei Streams zusammen, in dem jedes Event der beiden Streams
            // als eigenes Event in einem neuen Observable ausgegeben werden.
    }
}
