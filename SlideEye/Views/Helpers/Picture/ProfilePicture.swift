import SwiftUI

struct ProfilePicture: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .frame(width: 50, height: 50)
            .scaledToFit()
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.gray, lineWidth: 1)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    ProfilePicture(image: Image("1001_00"))
}
