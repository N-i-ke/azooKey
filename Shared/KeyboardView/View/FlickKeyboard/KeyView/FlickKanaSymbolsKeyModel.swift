//
//  KanaSymbolsKeyModel.swift
//  Keyboard
//
//  Created by ensan on 2020/12/27.
//  Copyright © 2020 ensan. All rights reserved.
//

import CustardKit
import Foundation
import SwiftUI

struct FlickKanaSymbolsKeyModel: FlickKeyModelProtocol {
    let needSuggestView: Bool = true

    static let shared = FlickKanaSymbolsKeyModel()
    @KeyboardSetting(.kanaSymbolsFlickCustomKey) private var customKey

    func pressActions(variableStates: VariableStates) -> [ActionType] {
        customKey.compiled().actions
    }
    var longPressActions: LongpressActionType {
        customKey.compiled().longpressActions
    }
    var labelType: KeyLabelType {
        customKey.compiled().labelType
    }
    func flickKeys(variableStates: VariableStates) -> [CustardKit.FlickDirection: FlickedKeyModel] {
        customKey.compiled().flick
    }

    private init() {}

    func label(width: CGFloat, states: VariableStates) -> KeyLabel {
        KeyLabel(self.labelType, width: width)
    }

    func feedback(variableStates: VariableStates) {
        KeyboardFeedback.click()
    }
}
