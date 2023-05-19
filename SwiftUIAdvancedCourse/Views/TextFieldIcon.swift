//
//  TextFieldIcon.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 19/05/23.
//

import SwiftUI

struct TextFieldIcon: View {
    
    @State private var colorAngle = 0.0
    
    var iconName : String
    
    @Binding var currentlyEditing : Bool
    
    var gradient1: [Color] = [
        Color.init(red: 101/255, green: 134/255, blue: 1),
        Color.init(red: 1, green: 64/255, blue: 80/255),
        Color.init(red: 109/255, green: 1, blue: 185/255),
        Color.init(red: 39/255, green: 232/255, blue: 1)
    ]
    
    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .dark) {
                ZStack {
                    if currentlyEditing {
                        AngularGradient(gradient: Gradient(colors: gradient1),
                                        center: .center,
                                        angle: .degrees(colorAngle))
                            .blur(radius: 10)
                            .onAppear{
                                withAnimation(.linear(duration: 7)) {
                                    self.colorAngle += 350
                                }
                            }
                    }
                    Color("tertiaryBackgrond")
                        .cornerRadius(12)
                        .opacity(0.8)
                        .blur(radius: 3)
                }
            }
        }
        .cornerRadius(12)
        .overlay {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .blendMode(.overlay)
                
                Image(systemName: iconName)
                    .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
                    .font(.system(size: 17, weight: .medium))
            }
        }
        .frame(width: 36, height: 36, alignment: .center)
        .padding([.vertical, .leading], 8)
    }
}

struct TextFieldIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldIcon(iconName: "key.fill", currentlyEditing: .constant(true))
    }
}
