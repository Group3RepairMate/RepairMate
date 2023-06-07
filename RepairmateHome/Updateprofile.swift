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
            TextField("Enter Your Name", text:$name)
            TextField("Enter Your Contact Number", text: $contact)
//            TextField("Enter Your Email Address")
//            TextField("Enter Your Home Address")
            
        }
    }
}

struct Updateprofile_Previews: PreviewProvider {
    static var previews: some View {
        Updateprofile()
    }
}
