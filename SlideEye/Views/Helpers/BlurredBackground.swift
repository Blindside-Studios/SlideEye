//
//  BlurredBackground.swift
//  SlideEye
//
//  Created by Nicolas Helbig on 18.02.24.
//

import SwiftUI

struct BlurredBackground: View {
    var image: Image
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        image
            .resizable()
            .padding(.vertical, -150)
            .padding(.horizontal, 0)
            .blur(radius: 50, opaque: true)
            .opacity(colorScheme == .dark ? 0.5 : 0.3) // change via mask when applied
            .brightness(0.01)
            .saturation(1.5)
    }
}

#Preview {
    BlurredBackground(image: Image("LaraCroft"))
}
