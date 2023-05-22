//
//  ProfileView.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 19/05/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showLoader : Bool = false
    
    var body: some View {
        ZStack {
            
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("pink-gradient-1"))
                                .frame(width: 66, height: 66, alignment: .center)
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                            
                        }
                        .frame(width: 66, height: 66, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text("Matteo Buompastore")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                                
                            Text("View Profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button {
                            print("Segue to settings")
                        } label: {
                            TextFieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true))
                        }
                        

                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text("Instructor at Design+Code")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    Label("Awarded with 10 certificates since January 2020", systemImage: "calendar")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.footnote)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        Image("Twitter")
                            .resizable()
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 24, height: 24, alignment: .center)

                        
                        Image(systemName: "link")
                            .resizable()
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 24, height: 24, alignment: .center)

                        
                        Text("desingcode.io")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                }
                .padding()
                
                GradientButton(buttonTitle: "Purchase Lifetime Pro Plan") {
                    print("IAP")
                }
                .padding(.horizontal)
                
                Button {
                    print("Restore")
                } label: {
                    GradientText(text: "Restore Purchases")
                        .font(.footnote.bold())
                }
                .padding(.bottom)
            }
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5)
                        .background(VisualEffectBlur(blurStyle: .dark)))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            }
            .cornerRadius(30)
            .padding(.horizontal)
            
            VStack {
                Spacer()
                
                Button {
                    print("Sign out")
                } label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                }
                .background(Circle().stroke(.white.opacity(0.7), lineWidth: 1)
                    .frame(width: 42, height: 42, alignment: .center)
                )
                .overlay {
                    VisualEffectBlur(blurStyle: .dark)
                        .cornerRadius(21)
                        .frame(width: 42, height: 42, alignment: .center)
                }

            }
            .padding(.bottom, 72)
            
            if showLoader {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
        }
        .preferredColorScheme(.dark)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
