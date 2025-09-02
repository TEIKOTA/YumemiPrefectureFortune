//
//  Item.swift
//  YumemiPrefectureFortune
//
//  Created by 髙橋　広大 on 2025/09/02.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
