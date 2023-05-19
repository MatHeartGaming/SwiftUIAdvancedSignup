//
//  GradientText.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 19/05/23.
//

import Foundation
import SwiftUI

struct GradientText: View {
    
    var text : String = "Text Here"
    
    var body: some View {
        Text(text)
            .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
    }
}

extension View {
    
    public func gradientForeground(colors : [Color]) -> some View {
        self.overlay(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
    
}
