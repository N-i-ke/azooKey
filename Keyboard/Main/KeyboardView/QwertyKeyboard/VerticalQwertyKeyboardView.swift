//
//  VerticalQwertyKeyboardView.swift
//  Keyboard
//
//  Created by β α on 2020/09/18.
//  Copyright © 2020 DevEn3. All rights reserved.
//

import Foundation
import SwiftUI

struct VerticalQwertyKeyboardView: View{
    private let model = VerticalQwertyDataProvider()
    @ObservedObject private var variableStates = VariableStates.shared
    
    private var verticalIndices: Range<Int> {
        switch variableStates.tabState{
        case .hira:
            return self.model.hiraKeyboard.indices
        case .abc:
            return self.model.abcKeyboard.indices
        case .number:
            return self.model.numberKeyboard.indices
        case let .other(string):
            switch string{
            case QwertyAdditionalTabs.symbols.identifier:
                return self.model.symbolsKeyboard.indices
            default: return 0..<0
            }
        }
    }
    
    private func horizontalIndices(v: Int) -> Range<Int> {
        switch variableStates.tabState{
        case .hira:
            return self.model.hiraKeyboard[v].indices
        case .abc:
            return self.model.abcKeyboard[v].indices
        case .number:
            return self.model.numberKeyboard[v].indices
        case let .other(string):
            switch string{
            case QwertyAdditionalTabs.symbols.identifier:
                return self.model.symbolsKeyboard[v].indices
            default: return 0..<0
            }
        }
    }
    
    private var keyModels: [[QwertyKeyModelProtocol]] {
        switch variableStates.tabState{
        case .hira:
            return self.model.hiraKeyboard
        case .abc:
            return self.model.abcKeyboard
        case .number:
            return self.model.numberKeyboard
        case let .other(string):
            switch string{
            case QwertyAdditionalTabs.symbols.identifier:
                return self.model.symbolsKeyboard
            default: return []
            }
        }
    }
    
    
    var body: some View {
        VStack(spacing: Design.shared.verticalSpacing){
            ForEach(self.verticalIndices, id: \.self){(v: Int) in
                HStack(spacing: Design.shared.horizontalSpacing){
                    ForEach(self.horizontalIndices(v: v), id: \.self){(h: Int) in
                        QwertyKeyView(self.keyModels[v][h])
                    }
                }
            }
        }
    }
}
