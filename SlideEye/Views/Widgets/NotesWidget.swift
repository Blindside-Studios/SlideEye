import SwiftUI

struct NotesWidget: View {
    @Binding var notes: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group
        {
            ZStack
            {
                Rectangle()
                    .frame(height: 200)
                    .background(.regularMaterial)
                    .blur(radius: 3.0, opaque: true)
                    .opacity(colorScheme == .dark ? 0.7 : 0.5)
                    .cornerRadius(25)
                
                VStack
                {
                    HStack
                    {
                        Text("Notes")
                            .font(.title)
                            .frame(alignment: .leading)
                            .padding(.vertical, 10)
                            .offset(y: 5)
                        Spacer()
                    }
                    .padding(.horizontal)
                    Divider()
                    HStack
                    {
                        Text(notes)
                            .font(.body)
                            .frame(alignment: .leading)
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
    }
}

#Preview {
    NotesWidget(notes: .constant("This is a note!"))
}
