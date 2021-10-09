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
    @State var rotation = Double.random(in: 0...360)
    @State private var willMoveToNextScreen = false
    @ObservedObject var compassHeadLog = CompassHeading()
    var body: some View {
        VStack {
            Text("The compass is facing in a random direction, use the slider to point the compass in the direction you are facing now.")
            Slider(value: $rotation, in: 0...360)
            Image("arrowBlack").resizable()
                .aspectRatio(contentMode: .fit).frame(height: 100 )
            ZStack {
                    ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker,
                                          compassDegress: rotation)
                    }
            }
                .frame(width: 300,
                       height: 300)
                .rotationEffect(.degrees(rotation))
                .statusBar(hidden: true)
            Button(action:{
                MyVariables.directionVar = computeDirection(val: rotation)
                let direction = MyVariables.directionVar
                let dirDegrees = self.compassHeadLog.degrees
                let currentDir = computeDirection(val: dirDegrees)
                print(dirDegrees)
                print(currentDir)
                //could maybe move this to logOrientation screen, just in case user moves right after making guess
                pushToDatabase(directionGuess: MyVariables.directionVar, actualDirection: currentDir, username: MyVariables.username)
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

