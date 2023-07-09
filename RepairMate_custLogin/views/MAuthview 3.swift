//
//  Mauthview.swift
//  RepairMate
//
//  Created by Patel Chintan on 2023-06-24.
//

import SwiftUI

struct Mauthview: View {
    @State private var currentViewShowing: String = "login"
    var body: some View {
        
        if(currentViewShowing == "login"){
            MechanicLoginView(currentShowingView: $currentViewShowing)
        }
        else {
            MechanicSignUpView(currentShowingView: $currentViewShowing)
                .transition(.move(edge: .bottom))
        }
    }
}

struct Mauthview_Previews: PreviewProvider {
    static var previews: some View {
        Mauthview()
    }
}
