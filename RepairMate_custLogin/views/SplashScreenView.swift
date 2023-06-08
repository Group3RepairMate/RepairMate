//
//  SplashScreenView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI

struct SplashScreenView: View {
    // using State property wrapper to control Navigation
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                // Once the variable isActive becomes true,
                // we navigate to RoleSelectionView
                RoleSelectionView()
            } else {
                VStack {
                    Text("REPAIR MATE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.black)
                
                    Text("Welcome to our service!")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(.gray)

                    // You can replace this with your app's logo
                    Image(systemName: "wrench.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }
        }
        .onAppear {
            // delay the navigation by 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        // Transition animation
        .animation(.easeOut(duration: 2.5))
        .transition(.scale)
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
