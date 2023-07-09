//
//  AuthView.swift
//  RepairMate_custLogin
//
//  Created by Arjun Roperia on 2023-05-23.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "login"
    var body: some View {
        if(currentViewShowing == "login"){
            LoginView(currentShowingView: $currentViewShowing)
        }
        else {
            SignUpView(currentShowingView: $currentViewShowing)
                .transition(.move(edge: .bottom))
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
