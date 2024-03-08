import SwiftUI

struct NewFriendPage: View {
    @Environment(ModelData.self) var modelData
    @Binding var friendDetails: Friend
    
    func findCityDetails()
    {
        // TODO: implement automated timezone finding
    }
    
    var body: some View {
        List
        {
            Group
            {
                Section("Name"){
                    TextField("Name", text: $friendDetails.name)
                }
                .padding(.vertical, 30)
                .offset(y: 30)
                
                Section("Profile Picture"){
                    friendDetails.profilePicture
                        .resizable()
                        .scaledToFit()
                        .overlay(alignment: .bottomTrailing) {
                            /*PhotosPicker(selection: $friendDetails.profilePicture,
                             matching: .images,
                             photoLibrary: .shared()) {
                             Image(systemName: "pencil.circle.fill")
                             .symbolRenderingMode(.multicolor)
                             .font(.system(size: 30))
                             .foregroundColor(.accentColor)
                             }
                             .buttonStyle(.borderless)*/
                        }
                }
                
                Section("Occupation"){
                    TextField("Occupation", text: $friendDetails.occupation)
                }
                
                Section("Location"){
                    TextField("Location", text: $friendDetails.location)
                }
                
                Section(header: Text("City"), footer: Text("Enter the closest larger city your friend lives in, it will be used to find some of the information below")){
                    TextField("City", text: $friendDetails.city)
                        .onSubmit {
                            findCityDetails()
                        }
                }
                
                Section("Country"){
                    TextField("Country", text: $friendDetails.country)
                }
                
                Section("Continent"){
                    TextField("Continent", text: $friendDetails.continent)
                }
                
                Section(header: Text("Time Zone ID"), footer: Text("This should conform to the following format: Continent/City, e.g. 'America/New_York'")){
                    TextField("Time Zone ID", text: $friendDetails.timeZoneID)
                }
                
                Section("Favorite"){
                    Toggle("Favorite", isOn: $friendDetails.isFavorite)
                }
                
                Section("Notes"){
                    TextField("Notes", text: $friendDetails.notes)
                }
            }
        }
    }
}

#Preview {
    NewFriendPage(friendDetails: .constant(ModelData().friends[0]))
}
