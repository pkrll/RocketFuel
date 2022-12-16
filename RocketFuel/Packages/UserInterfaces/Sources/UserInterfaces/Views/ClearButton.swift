//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import SwiftUI

struct ClearButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {}
            .buttonStyle(ClearButtonStyle())
    }
}

private struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: "xmark.circle.fill")
            .font(.system(size: 12))
            .foregroundColor(configuration.isPressed ? Color.gray : Color.white)
    }
}
