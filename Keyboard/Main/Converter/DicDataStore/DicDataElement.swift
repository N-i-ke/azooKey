//
//  DicDataElementProtocol.swift
//  Keyboard
//
//  Created by β α on 2020/09/10.
//  Copyright © 2020 DevEn3. All rights reserved.
//

import Foundation

struct DicdataElement: Equatable {
    static let BOSData = Self.init(word: "", ruby: "", cid: 0, mid: 500, value: 0, adjust: 0)
    static let EOSData = Self.init(word: "", ruby: "", cid: 1316, mid: 500, value: 0, adjust: 0)

    func adjustZero() -> Self {
        return .init(word: word, ruby: ruby, lcid: lcid, rcid: rcid, mid: mid, value: baseValue, adjust: .zero)
    }

    init(word: String, ruby: String, lcid: Int, rcid: Int, mid: Int, value: PValue, adjust: PValue = .zero) {
        self.word = word
        self.ruby = ruby
        self.lcid = lcid
        self.rcid = rcid
        self.mid = mid
        self.baseValue = value
        self.adjust = adjust
    }

    init(word: String, ruby: String, cid: Int, mid: Int, value: PValue, adjust: PValue = .zero) {
        self.word = word
        self.ruby = ruby
        self.lcid = cid
        self.rcid = cid
        self.mid = mid
        self.baseValue = value
        self.adjust = adjust
    }

    init(ruby: String, cid: Int, mid: Int, value: PValue, adjust: PValue = .zero) {
        self.word = ruby
        self.ruby = ruby
        self.lcid = cid
        self.rcid = cid
        self.mid = mid
        self.baseValue = value
        self.adjust = adjust
    }

    func adjustedData(_ adjustValue: PValue) -> Self {
        return .init(word: word, ruby: ruby, lcid: lcid, rcid: rcid, mid: mid, value: baseValue, adjust: adjustValue + self.adjust)
    }

    let word: String
    let ruby: String
    let lcid: Int
    let rcid: Int
    let mid: Int
    let baseValue: PValue
    let adjust: PValue

    func value() -> PValue {
        return min(.zero, self.baseValue + self.adjust)
    }

    var isLRE: Bool {
        return self.lcid == self.rcid
    }
}

extension DicdataElement: CustomDebugStringConvertible {
    var debugDescription: String {
        return "(ruby: \(self.ruby), word: \(self.word), adjust: \(self.adjust), value: \(self.value()))"
    }
}
