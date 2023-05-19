//
//  SwiftUIAdvancedCourseApp.swift
//  SwiftUIAdvancedCourse
//
//  Created by Matteo Buompastore on 19/05/23.
//

import SwiftUI
import Firebase

@main
struct SwiftUIAdvancedCourseApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SignupView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
