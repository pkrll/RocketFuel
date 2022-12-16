//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

public struct AboutView: View {
    let image: Image
    let title: String
    let subtitle: String
    let copyright: String
    
    let width: CGFloat
    let height: CGFloat
    
    public var body: some View {
        VStack(spacing: 8) {
            image
                .resizable()
                .frame(width: 64, height: 64)
            VStack(spacing: 5) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 12))
            }
            
            Text(copyright)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
        .frame(width: width, height: height)
        .frame(minWidth: width, maxWidth: width,
               minHeight: height, maxHeight: height)
    }
    
    public init(
        image: Image,
        title: String,
        subtitle: String,
        copyright: String,
        width: CGFloat,
        height: CGFloat
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.copyright = copyright
        self.width = width
        self.height = height
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(
            image: Image(systemName: "globe"),
            title: "Rocket Fuel",
            subtitle: "Version 1.0.0",
            copyright: "Copyright © 1988 Ardalan Samimi. All rights reserved.",
            width: 240,
            height: 200
        )
    }
}
