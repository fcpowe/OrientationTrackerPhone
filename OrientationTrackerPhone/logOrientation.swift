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
            Text("The compass is facing in a random direction, use the slider to point the compass in the direction you are facing now.").padding()
            Image("arrowBlack").resizable()
                .aspectRatio(contentMode: .fit).frame(height: 75 )
            ZStack {
                    ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker,
                                          compassDegrees: rotation)
                    }
            }
                .frame(width: 300,
                       height: 300)
                .rotationEffect(.degrees(rotation))
                .statusBar(hidden: true)
            Slider(value: $rotation, in: 0...360).padding(.bottom, 25)
            Button(action:{
                MyVariables.directionVar = computeDirection(val: 360 - rotation)
                print(MyVariables.directionVar)
                let direction = MyVariables.directionVar
                MyVariables.dirDegrees = self.compassHeadLog.degrees + 15
                print(360-rotation)
                MyVariables.actualDegString = computeDirection(val: MyVariables.dirDegrees)
                MyVariables.feedbackScreenVal = true
                print(MyVariables.dirDegrees)
                print(MyVariables.actualDegString)
                //could maybe move this to logOrientation screen, just in case user moves right after making guess
                pushToDatabase(directionGuess: MyVariables.directionVar, actualDirection: MyVariables.actualDegString, username: MyVariables.username, degreesGuess: 360 - rotation, degreesActualStart: MyVariables.dirDegreesStart, degreesActualEnd: MyVariables.dirDegrees)
                        
                 
                willMoveToNextScreen = true
                print(direction)
                
            }) {
              Text("Submit")    }.buttonStyle(GradientBackgroundStyle())         }.navigate(to: ContentView(), when: $willMoveToNextScreen)         }

    }

func askPermission(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        logOrientation()
    }
}

