import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 1)) {
                isSet.toggle()
            }
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .blue: .gray)
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
