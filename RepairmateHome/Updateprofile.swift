//
//  Updateprofile.swift
//  RepairmateHome
//
//  Created by Patel Chintan on 2023-06-07.
//

import SwiftUI

struct Updateprofile: View {
    @State private var name:String = ""
    @State private var contact:String = ""
    @State private var email:String = ""
    @State private var address:String = ""
    var body: some View {
        VStack{
            Text("Update Profile")
                .foregroundColor(.blue)
                .font(.title)
                .fontWeight(.bold)
                .padding(10)
            TextField("Enter Your Building Code",text: $name)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            TextField("Enter Your Building Code",text: $contact)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            TextField("Enter Your Building Code",text: $email)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            TextField("Enter Your Building Code",text: $address)
                .padding(15)
                .foregroundColor(Color.blue)
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .disableAutocorrection(true)
                .font(.headline)
                .cornerRadius(20)
            Spacer()
        }
        .padding(10)
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
