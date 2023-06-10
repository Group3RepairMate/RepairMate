//
//  RepairMate_custLoginApp.swift
//  RepairMate_custLogin
//
//  Created by Arjun Roperia on 2023-05-22.
//

import SwiftUI
import FirebaseCore
@main
struct RepairMate_custLoginApp: App {
    var garagehelper = Garagehelper()
    init(){
        FirebaseApp.configure() 
    }
    var body: some Scene {
        WindowGroup {
            SplashScreenView().environmentObject(garagehelper)
        }
    }
}
