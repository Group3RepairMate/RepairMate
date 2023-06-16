//
//  RoleSelectionView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI

struct RoleSelectionView: View {
    @State private var currentShowingView: String = "login"

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Select Your Role")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color("darkgray"))

                Spacer()

                NavigationLink(destination: ContentView()) {
                    Text("Customer")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("darkgray"))
                        )
                        .padding(.horizontal)
                }
                .padding(.bottom)
                // Passed currentShowingView state to MechanicLoginView
                NavigationLink(destination: MechanicLoginView(currentShowingView: $currentShowingView)) {
                    Text("Mechanic")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.green)
                        )
                        .padding(.horizontal)
                }
                Spacer()
            }
        }
        // Added view based on the state of currentShowingView
        .overlay(
            Group {
                switch currentShowingView {
                case "mechanic_login":
                    MechanicLoginView(currentShowingView: $currentShowingView)
                case "mechanic_signup":
                    MechanicSignUpView(currentShowingView: $currentShowingView)
                default:
                    EmptyView()
                }
            }
        )
    }
}


struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView()
    }
}
