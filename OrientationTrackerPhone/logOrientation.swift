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
    @ObservedObject var stopWatchManager = StopWatchManager()
    @StateObject var viewRouter: ViewRouter

    var body: some View {
       VStack {
           Text("The compass is facing in a random direction. Touch and drag the compass to rotate it towards the direction you are facing now.").font(.system(size: 20)).padding(.horizontal, 10)
            Image("arrowBlack").resizable()
                .aspectRatio(contentMode: .fit).frame(height: 75 )
           TemperatureControlView()
            Button(action:{
                MyVariables.timeToLog = Date().distance(to: MyVariables.startTime)
                print("logOrientation")
                print(MyVariables.timeToLog)
                MyVariables.startTime = Date()
                
                MyVariables.directionVar = computeDirection(val: 360 - MyVariables.changeAngle)
                MyVariables.dirDegrees = self.compassHeadLog.degrees //+15?
                MyVariables.actualDegString = computeDirection(val: MyVariables.dirDegrees)
                MyVariables.feedbackScreenVal = true
                print(MyVariables.dirDegrees)
                print(MyVariables.actualDegString)
                
                 
               // willMoveToNextScreen = true
                viewRouter.currentPage = .page4
                print("ANGLEEEE")
                print(360 - MyVariables.changeAngle)
                print(computeDirection(val: 360 - MyVariables.changeAngle))
                
            }) {
              Text("Submit").font(.system(size: 30))    }.buttonStyle(GradientBackgroundStyle())         }.padding(.top, 70)        }

    }


//converts degrees direction to easily readable guess
func computeDirection(val : Double) -> String {
    switch abs(val) {
    case 0...22.5:
        return "N"
    case 22.5...67.5:
        return "NE"
    case 67.5...112.5:
        return "E"
    case 112.5...157.5:
        return "SE"
    case 157.5...202.5:
        return "S"
    case 202.5...247.5:
        return "SW"
    case 247.5...292.5:
        return "W"
    case 292.5...337.5:
        return "NW"
    default:
        return "N"
    }
}
//val1 is actual direction degrees val2 is direction guess
func computeAccuracy(val1 : Double, val2: Double) -> String {
    //actual direction can be negative, so abs val of that
    //direction guess shouldn't be negative - but maybe that's a potential issue
    let compareVal = min(abs(abs(val1)-val2), (abs(360 - abs(val1) - val2)))
  
    if (compareVal <= MyVariables.accuracy) {
        return ("Within Range")
    }
    else {
        return ("Out of Range")
    }
    /* debugging
     print("CompareVal")
     print(compareVal)
     print("dir degrres")
     print(val1)
     print("guess")
     print(val2)
     print("accuracy")
     print(MyVariables.accuracy)

     */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        logOrientation(viewRouter: ViewRouter())
    }
}

