//
//  GradientTextField.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 23/05/23.
//

import SwiftUI

struct GradientTextField: View {
    
    @Binding var editingtextField : Bool
    @Binding var textfieldString : String
    @Binding var iconBounce : Bool
    
    var textfieldPlaceholder : String
    var textfieldIconString : String
    var generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack(spacing: 12) {
            TextFieldIcon(iconName: textfieldIconString,
                          currentlyEditing: $editingtextField, passesImage: .constant(nil))
            .scaleEffect(iconBounce ? 1.2 : 1)
            
            TextField(textfieldPlaceholder, text: $textfieldString) { isEditing in
                editingtextField = isEditing
                //MARK: To Activate the aptic feedback
                generator.selectionChanged()
                
                if(isEditing) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        iconBounce.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            iconBounce.toggle()
                        }
                    }
                }
                
                
            }
            .preferredColorScheme(.dark)
            .foregroundColor(.white.opacity(0.7))
            .textInputAutocapitalization(.none)
            .textContentType(.emailAddress)
        }
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(.white, lineWidth: 1).blendMode(.overlay)
        )
        .background(Color(red: 26/255, green: 20/255, blue: 51/255).cornerRadius(16).opacity(0.8))
    }
}

struct GradientTextField_Previews: PreviewProvider {
    static var previews: some View {
        GradientTextField(editingtextField: .constant(true), textfieldString: .constant("Text"), iconBounce: .constant(true), textfieldPlaceholder: "Placeholder", textfieldIconString: "textformat.alt")
    }
}
