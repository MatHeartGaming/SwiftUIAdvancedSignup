//
//  SettingsView.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 23/05/23.
//

import SwiftUI
import FirebaseAuth
import CoreData

struct SettingsView: View {
    
    @State private var editingNameTextField = false
    @State private var editingTwitterTextField = false
    @State private var editingSiteTextField = false
    @State private var editingBioTextField = false
    
    @State private var nameIconBounce = false
    @State private var twitterIconBounce = false
    @State private var siteIconBounce = false
    @State private var bioIconBounce = false
    
    @State private var name = ""
    @State private var twitter = ""
    @State private var site = ""
    @State private var bio = ""
    
    @State private var showImagePicker = false
    @State private var inputImage : UIImage?
    
    //Alert
    @State private var showAlertView : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertMessage : String = ""
    
    //MARK: Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser?.uid ?? ""), animation: .default) private var savedAccounts : FetchedResults<Account>
    
    @State private var currentAccount : Account?
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Manage your Desing+Code profile and account")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.callout)
                
                //Choose Photo
                Button {
                    self.showImagePicker = true
                } label: {
                    HStack {
                        TextFieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false), passesImage: $inputImage)
                        GradientText(text: "Choose Photo")
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                    .background(Color(red: 26/255, green: 20/255, blue: 51/255).cornerRadius(16))
                }
                
                //Name TextField
                GradientTextField(editingtextField: $editingNameTextField, textfieldString: $name, iconBounce: $nameIconBounce, textfieldPlaceholder: "Name", textfieldIconString: "textformat.alt")
                    .textInputAutocapitalization(.words)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                
                //Twitter TextField
                GradientTextField(editingtextField: $editingTwitterTextField, textfieldString: $twitter, iconBounce: $twitterIconBounce, textfieldPlaceholder: "Twitter", textfieldIconString: "at")
                    .textInputAutocapitalization(.none)
                    .keyboardType(.twitter)
                    .autocorrectionDisabled()
                
                //Site TextField
                GradientTextField(editingtextField: $editingSiteTextField, textfieldString: $site, iconBounce: $siteIconBounce, textfieldPlaceholder: "Site", textfieldIconString: "link")
                    .textInputAutocapitalization(.none)
                    .keyboardType(.webSearch)
                    .autocorrectionDisabled()
                
                //Bio TextField
                GradientTextField(editingtextField: $editingBioTextField, textfieldString: $bio, iconBounce: $bioIconBounce, textfieldPlaceholder: "Bio", textfieldIconString: "text.justifyleft")
                    .textInputAutocapitalization(.sentences)
                    .keyboardType(.default)
                
                GradientButton(buttonTitle: "Save") {
                    //Enable Haptics
                    generator.selectionChanged()
                    
                    //Save to CoreData
                    saveData()
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(Color("settingsBackground"))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onAppear {
            currentAccount = savedAccounts.first!
            name = currentAccount?.name ?? ""
            bio = currentAccount?.bio ?? ""
            twitter = currentAccount?.twitterHandle ?? ""
            site = currentAccount?.website ?? ""
            inputImage = UIImage(data: currentAccount?.profileImage ?? Data())
        }
        .alert(alertTitle, isPresented: $showAlertView) {
            Button {
                showAlertView = false
            } label: {
                Text("OK")
            }
        } message: {
            Text(alertMessage)
        }

    }
    
    func saveData() {
        currentAccount?.name = name
        currentAccount?.twitterHandle = twitter
        currentAccount?.bio = bio
        currentAccount?.website = site
        currentAccount?.profileImage = inputImage?.pngData()
        do {
            try viewContext.save()
            alertTitle = "Success"
            alertMessage = "Changes have been saved correctly!"
            showAlertView = true
        } catch let error {
            print(error.localizedDescription)
            alertTitle = "Uh-Oh!"
            alertMessage = error.localizedDescription
            showAlertView = true
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
