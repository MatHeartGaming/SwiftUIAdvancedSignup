//
//  SignInWithAppleButton.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 22/05/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton : UIViewRepresentable {
    
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
    
}

