//
//  ProfileView.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 19/05/23.
//

import SwiftUI
import FirebaseAuth
import CoreData

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showLoader : Bool = false
    @State private var showSettingsView : Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser?.uid ?? ""), animation: .default) private var savedAccounts : FetchedResults<Account>
    
    @State private var currentAccount : Account?
    
    //To update the view
    @State var updater = true
    
    
    var body: some View {
        ZStack {
            
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        if currentAccount?.profileImage != nil {
                            GradientProfilePictureView(profilePicture: UIImage(data: currentAccount!.profileImage!)!)
                                .frame(width: 66, height: 66)
                        } else {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("pink-gradient-1"))
                                    .frame(width: 66, height: 66, alignment: .center)
                                
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .medium, design: .rounded))
                                
                            }
                            .frame(width: 66, height: 66, alignment: .center)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(currentAccount?.name ?? "No Name")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                                
                            Text("View Profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showSettingsView.toggle()
                            }
                        } label: {
                            TextFieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true), passesImage: .constant(nil))
                        }
                        

                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text(currentAccount?.bio ?? "No Bio")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    if currentAccount?.numberOfCertificates != 0 {
                        Label("Awarded with \(currentAccount?.numberOfCertificates ?? 0) certificates since \(dateFormatter(date: currentAccount?.userSince ?? Date()))", systemImage: "calendar")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                        
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    
                    HStack(spacing: 16) {
                        if(currentAccount?.twitterHandle != nil){
                            Image("Twitter")
                                .resizable()
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                        
                        if(currentAccount?.website != nil){
                            Image(systemName: "link")
                                .resizable()
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24, height: 24, alignment: .center)
                        }

                        Text("desingcode.io")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                }
                .padding()
                
                if currentAccount?.proMember == false {
                    GradientButton(buttonTitle: "Purchase Lifetime Pro Plan") {
                        print("IAP")
                    }
                    .padding(.horizontal)
                }
                
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
                    print("Signing out")
                    signOut()
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
        .preferredColorScheme(updater ? .dark : .dark) //MARK: Trick to force the refresh of view with the new infos
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
                .environment(\.managedObjectContext, viewContext)
                .onDisappear {
                    currentAccount = savedAccounts.first!
                    updater.toggle() //MARK: Trick to force the refresh of view with the new infos
                }
        }
        .onAppear {
            self.currentAccount = savedAccounts.first
            if currentAccount == nil {
                readFromCoreData(user: Auth.auth().currentUser)
            }
        }
    }
    
    func readFromCoreData(user : User?) {
        if let currentUser = user {
            if savedAccounts.isEmpty {
                //Add data to Core Data
                let userDataToSave = Account(context: viewContext)
                userDataToSave.name = currentUser.displayName
                userDataToSave.bio = nil
                userDataToSave.userID = currentUser.uid
                userDataToSave.numberOfCertificates = 0
                userDataToSave.proMember = false
                userDataToSave.twitterHandle = nil
                userDataToSave.website = nil
                userDataToSave.profileImage = nil
                userDataToSave.userSince = Date()
                do {
                    try viewContext.save()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            presentationMode.wrappedValue.dismiss()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func dateFormatter(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
