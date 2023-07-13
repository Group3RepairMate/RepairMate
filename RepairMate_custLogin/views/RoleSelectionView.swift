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
            VStack {
                Spacer()
                VStack{
                    Text("Select Your Role")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color("darkgray"))
                    
                    Spacer()
                    
                    NavigationLink(destination: ContentView()) {
                        VStack{
                            Image("profile")
                                .resizable()
                                .frame(width: 220.0, height: 220.0)
                            Text("Customer")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth:230)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color("darkgray"))
                                )
                        }
                        
                    }
                    .padding(.bottom)
                    NavigationLink(destination: ContentViewForMech()){
                        VStack{
                            Image("mechanics")
                                .resizable()
                                .frame(width: 220.0, height: 220.0)
                            Text("Mechanic")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth:230)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.green)
                                )
                            
                        }
                    }
                    
                    Spacer()
                }
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
