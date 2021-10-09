//
//  Home.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 7/13/21.
//

import Foundation
import SwiftUI
struct Home: View {
    @State private var willMoveToNextScreen = false
    var body: some View {
        VStack{
            //need to query from database
            //possibly tell user when to log next instead
            Text("Last Entry: 5:15pm 6/23/21")
                .padding()
            Button(action: {willMoveToNextScreen = true}) {
                //links to logOrientation.swift
                Text("Log Entry")            }.buttonStyle(GradientBackgroundStyle())        }.navigate(to: logOrientation(), when: $willMoveToNextScreen)       // Spacer()
        }
        
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            
    }
}
