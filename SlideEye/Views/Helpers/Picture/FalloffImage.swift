import SwiftUI

struct FalloffImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Rectangle())
            .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .black, location: 0.75),
                    .init(color: .clear, location: 1)
                  ]), startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    FalloffImage(image: Image("1001"))
}
