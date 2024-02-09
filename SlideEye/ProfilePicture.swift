import SwiftUI

struct ProfilePicture: View {
    var body: some View {
        Image("LaraCroft")
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    ProfilePicture()
}
