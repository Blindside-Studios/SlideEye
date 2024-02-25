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
                    .background(colorScheme == .dark ? .thinMaterial: .regularMaterial)
                    .cornerRadius(25)
                    .brightness(colorScheme == .dark ? -0.3: 0.45)
                    .saturation(colorScheme == .dark ?  0.6: 0.0)
                
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
    }
}

#Preview {
    NotesWidget(notes: .constant("This is a note!"))
}
