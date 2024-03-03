import SwiftUI

struct NewFriendPage: View {
    @Environment(ModelData.self) var modelData
    @Binding var friendDetails: Friend
    
    var body: some View {
        List
        {
            Section("Name"){
                TextField("Name", text: $friendDetails.name)
            }
            
            Section("Profile Picture"){
                friendDetails.profilePicture
                    .resizable()
                    .scaledToFit()
            }
            
            Section("Occupation"){
                TextField("Occupation", text: $friendDetails.occupation)
            }
                
            Section("Location"){
                TextField("Location", text: $friendDetails.location)
            }
            
            Section("Country"){
                TextField("Country", text: $friendDetails.country)
            }
            
            Section("Continent"){
                TextField("Continent", text: $friendDetails.continent)
            }
            
            Section("Time Zone ID"){
                TextField("Time Zone ID", text: $friendDetails.timeZoneID)
            }
            
            Section("Favorite"){
                Toggle("Favorite", isOn: $friendDetails.isFavorite)
            }
            
            Section("Notes"){
                TextField("Notes", text: $friendDetails.notes)
            }
        }
        .padding(.vertical, 35)
        .offset(y: 35)
    }
}

/*#Preview {
    let modelData = ModelData()
    NewFriendPage(friendDetails: .constant(ModelData().friends[0]))
        .environment(modelData)
}*/
