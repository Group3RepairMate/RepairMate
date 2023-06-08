
import SwiftUI

struct Profile: View {
    @State private var selectedImage: Image?
    @State private var isShowingImagePicker = false
    @State private var linkselection:Int? = nil
    var body: some View {
        
        VStack {
            if let image = selectedImage {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 190)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 190)
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("Edit")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            .sheet(isPresented: $isShowingImagePicker, onDismiss: loadimage) {
                ImagePicker(selectedImage: $selectedImage)
            }
            NavigationLink(destination: Updateprofile(), tag: 1, selection: self.$linkselection){}
            List {
               
                Button(action: {
                linkselection = 1
                }) {
                    Text("Update Profile")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                        .cornerRadius(20)
                }
                
                Button(action: {
                   
                }) {
                    Text("View History")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                        .cornerRadius(20)
                }
                
                .listStyle(GroupedListStyle())
            }
            
            Button(action:{
                // self.createaccount = 1
            })
            {
                Text("Logout")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(maxWidth: 120)
            }
            .background(Color.blue)
            .cornerRadius(70)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.blue,lineWidth: 0)
                    .foregroundColor(.black)
            )
            
        }
    }
    func loadimage(){
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
