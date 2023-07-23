//
//  MechanicHistory.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-07-09.
//

import SwiftUI

struct MechanicHistory: View {
    @EnvironmentObject var garagehelper: Garagehelper
    @AppStorage("mechanicId") var mechanicId: String = ""
    
    var body: some View {
        VStack{
            Text("mechanic history")
        }
        .onAppear(){
            for i in garagehelper.garagelist{
                if(i.email == mechanicId){
                    print("history \(i.phone_no)")
                }
            }
        }
    }
}

struct MechanicHistory_Previews: PreviewProvider {
    static var previews: some View {
        MechanicHistory()
    }
}
