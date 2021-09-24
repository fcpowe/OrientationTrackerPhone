//
//  logOrientation.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 7/14/21.
//

import Foundation
import SwiftUI
import CloudKit



struct logOrientation: View {
    
    @State var rotation = 0.0
    @State private var willMoveToNextScreen = false
    var body: some View {
        VStack {
            Slider(value: $rotation, in: 0...360)
            GeometryReader { geo in
                Image("nounArrow").resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top)
                    .frame(width: geo.size.width, height: 100 )
                    Image("compassCircular")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top)
                        .frame(width: geo.size.width, height: 650).rotationEffect(.degrees(rotation))                }
            Text("\(rotation)")
            Button(action:{
                MyVariables.directionVar = computeDirection(val: rotation)
                let direction = MyVariables.directionVar
                willMoveToNextScreen = true
                print(direction)
                
            }) {
              Text("Submit")    }.buttonStyle(GradientBackgroundStyle())         }.navigate(to: ContentView(), when: $willMoveToNextScreen)         }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        logOrientation()
    }
}

