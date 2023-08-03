//
//  RoleSelectionView.swift
//  RepairMate
//
//  Created by Bhuvesh Aggarwal on 2023-06-06.
//

import SwiftUI

struct RoleSelectionView: View {
    @State private var currentShowingView: String = "login"
    @State private var linkselection: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Text("Select Your Role")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("darkgray"))
                    Text("")
                    Text("")
                    Spacer()
                    
                    VStack {
                        NavigationLink(destination: ContentView()) {
                            VStack {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 220.0, height: 220.0)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.blue, lineWidth: 3)
                                    )
                                Text("Customer")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color("darkgray"))
                            )
                        }
                        
                        Spacer().frame(height: 20)
                        
                        Text("")
                        Text("")
                        
                        NavigationLink(destination: ContentViewForMech()){
                            VStack {
                                Image("mechanics")
                                    .resizable()
                                    .frame(width: 220.0, height: 220.0)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.gray, lineWidth: 3)
                                    )
                                Text("Mechanic")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.gray)
                            )
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
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
