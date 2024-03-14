import SwiftUI

struct NotesWidget: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.colorScheme) var colorScheme
    
    var friendName: String
    var profilePicture: Image
    @Binding var notes: String
    @Binding var shouldPresentNotesSheet: Bool
    
    var body: some View {
        Group
        {
            ZStack
            {
                Rectangle()
                    .frame(height: 200)
                    .background(.regularMaterial)
                    .brightness(colorScheme == .dark ? -0.3: 0.4)
                
                VStack
                {
                    HStack
                    {
                        Text("Notes")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(alignment: .leading)
                            .padding(.vertical, 10)
                            .offset(y: 5)
                            .shadow(radius: 1)
                        Spacer()
                    }
                    .padding(.horizontal)
                    Divider()
                        .shadow(radius: 5)
                    HStack
                    {
                        Text(notes)
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(alignment: .leading)
                            .shadow(radius: 1)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    Spacer()
                }
                .cornerRadius(25)
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .shadow(radius: 10)
        .gesture(TapGesture().onEnded{
            shouldPresentNotesSheet.toggle()
        })
        .sheet(isPresented: $shouldPresentNotesSheet){
        } content: {
            ZStack{
                NotesPage(friendName: friendName, backgroundImage: profilePicture, notes: $notes)
                    .padding(-1)
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.bar)
                            .frame(height: 50)
                        HStack{
                            Text(friendName+"'s notes")
                            Spacer()
                            Button("Done") { shouldPresentNotesSheet.toggle(); }
                        }
                        .padding(15)
                    }
                    Spacer()
                }
                .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    NotesWidget(friendName: "Example Friend", profilePicture: Image("1001_00"), notes: .constant("This is a note!"), shouldPresentNotesSheet: .constant(false))
}
