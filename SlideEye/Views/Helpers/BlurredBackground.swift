//
//  BlurredBackground.swift
//  SlideEye
//
//  Created by Nicolas Helbig on 18.02.24.
//

import SwiftUI

struct BlurredBackground: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .padding(.vertical, -75)
            .padding(.horizontal, 0)
            .blur(radius: 200)
            .opacity(0.25)
            .saturation(5)
    }
}

#Preview {
    BlurredBackground(image: Image("DaniRojas"))
}
