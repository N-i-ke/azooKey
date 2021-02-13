//
//  QwertyVariationsView.swift
//  Keyboard
//
//  Created by β α on 2020/09/18.
//  Copyright © 2020 DevEn3. All rights reserved.
//

import Foundation
import SwiftUI

struct QwertyVariationsView: View {
    private let model: VariationsModel
    @ObservedObject private var modelVariableSection: VariationsModelVariableSection
    private let theme: ThemeData
    init(model: VariationsModel, theme: ThemeData){
        self.model = model
        self.modelVariableSection = model.variableSection
        self.theme = theme
    }

    private var suggestColor: Color {
        theme != .default ? .white : Design.colors.suggestKeyColor
    }

    var body: some View {
        HStack(spacing: Design.shared.horizontalSpacing){
            ForEach(model.variations.indices, id: \.self){(index: Int) in
                ZStack{
                    Rectangle()
                        .foregroundColor(index == self.modelVariableSection.selection ? Color.blue:suggestColor)
                        .frame(width: Design.shared.keyViewSize.width, height: Design.shared.keyViewSize.height*0.9, alignment: .center)
                        .cornerRadius(10.0)
                    getLabel(model.variations[index].label)
                }
            }

        }
    }
    
    private func getLabel(_ labelType: KeyLabelType) -> KeyLabel {
        let width = Design.shared.keyViewSize.width
        if theme != .default{
            return KeyLabel(labelType, width: width, theme: theme, textColor: .black)
        }
        return KeyLabel(labelType, width: width, theme: theme)
    }

}
