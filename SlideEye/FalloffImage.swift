//
//  FalloffImage.swift
//  SlideEye
//
//  Created by Nicolas Helbig on 09.02.24.
//

import SwiftUI

struct FalloffImage: View {
    var body: some View {
        Image("LaraCroft")
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
    FalloffImage()
}
