//
//  Event.swift
//  CrimeStream
//
//  Created by Mattes Wieben on 13.10.19.
//  Copyright © 2019 matscodes. All rights reserved.
//

import Foundation

struct Event : Equatable{
    var desc: String;
    
    // Hilfsmethode zur Evaluierung der Tests
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.desc == rhs.desc
    }
}
