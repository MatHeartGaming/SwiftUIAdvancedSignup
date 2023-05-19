//
//  ContentView.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 19/05/23.
//

import SwiftUI
import AudioToolbox
import FirebaseAuth

struct SignupView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var editingEmailTextfield: Bool = false
    @State private var editingPasswordTextfield: Bool = false
    @State private var showProfileView = false
    @State private var signupToggle = true
    @State private var rotationAngle = 0.0
    
    //Animations
    @State private var emailIconBounce = false
    @State private var passwordIconBounce = false
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Image(signupToggle ? "background-3" : "background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(signupToggle ? "Sign up" : "Sign in")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Access to 120+ hours of courses, tutorials, and livestreams")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 12) {
                        TextFieldIcon(iconName: "envelope.open.fill",
                                      currentlyEditing: $editingEmailTextfield)
                        .scaleEffect(emailIconBounce ? 1.2 : 1)
                        
                        TextField("Email", text: $email) { isEditing in
                            editingEmailTextfield = isEditing
                            editingPasswordTextfield = false
                            //MARK: To Activate the aptic feedback
                            generator.selectionChanged()
                            
                            if(isEditing) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    emailIconBounce.toggle()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                        emailIconBounce.toggle()
                                    }
                                }
                            }
                            
                            
                        }
                        .preferredColorScheme(.dark)
                        .foregroundColor(.white.opacity(0.7))
                        .textInputAutocapitalization(.none)
                        .textContentType(.emailAddress)
                    }
                    .frame(height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1).blendMode(.overlay)
                    )
                    .background(Color("secondaryBackground").cornerRadius(16).opacity(0.8))
                    
                    HStack(spacing: 12) {
                        
                        TextFieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextfield)
                            .scaleEffect(passwordIconBounce ? 1.2 : 1)
                        
                        SecureField("Password", text: $password)
                            .preferredColorScheme(.dark)
                            .foregroundColor(.white.opacity(0.7))
                            .textInputAutocapitalization(.none)
                            .textContentType(.password)
                    }
                    .frame(height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1).blendMode(.overlay)
                    )
                    .background(Color("secondaryBackground").cornerRadius(16).opacity(0.8))
                    .onTapGesture {
                        editingEmailTextfield = false
                        editingPasswordTextfield = true
                        
                        if(editingPasswordTextfield) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                passwordIconBounce.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    passwordIconBounce.toggle()
                                }
                                
                            }
                        }
                    }
                    
                    GradientButton(buttonTitle: signupToggle ? "Create account" : "Sign in") {
                        generator.selectionChanged()
                        signup()
                    }
                    .onAppear{
                        Auth.auth().addStateDidChangeListener { auth, user in
                            if user != nil {
                                showProfileView = true
                            }
                        }
                    }
                    
                    if signupToggle {
                        Text("By clicking on Sign Up, you agree to our Terms of Service and Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    //Divider
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                signupToggle.toggle()
                                self.rotationAngle += 180
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(signupToggle ? "Already have an account" : "Don't have an account?")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                GradientText(text: signupToggle ? "Sign in" : "Sign up")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        if !signupToggle {
                            Button {
                                print("Send reset password email")
                            } label: {
                                HStack(spacing: 4) {
                                    Text("Forgot password?")
                                        .font(.footnote)
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    GradientText(text: "Reset Password")
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                .padding(20)
            }
            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.2))
                    .background(
                        Color("secondaryBackground").opacity(0.5))
                    .background(
                        VisualEffectBlur(blurStyle: .systemMaterialDark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
        }
        /*.fullScreenCover(isPresented: $showProfileView) {
         ProfileView()
         }*/
    }
    
    func signup() {
        if signupToggle{
            Auth.auth().createUser(withEmail: email, password: password) {result, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                print("User signed up!")
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) {result, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("User signed in")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
