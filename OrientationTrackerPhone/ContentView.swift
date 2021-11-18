//
//  ContentView.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 7/13/21.
//
//Compass part Created by ProgrammingWithSwift on 2019/10/06.
//  Copyright © 2019 ProgrammingWithSwift. All rights reserved.

import Foundation
import SwiftUI
import CloudKit

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
    }
}
struct Marker: Hashable {
    let degrees: Double
    let label: String

    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }

    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }

    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, label: "N"),
            Marker(degrees: 45, label: "NE"),
            Marker(degrees: 90, label: "E"),
            Marker(degrees: 135, label: "SE"),
            Marker(degrees: 180, label: "S"),
            Marker(degrees: 225, label: "SW"),
            Marker(degrees: 270, label: "W"),
            Marker(degrees: 315, label: "NW"),
        ]
    }
}

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegrees: Double

    var body: some View {
        VStack {
            Text(marker.label)
                .fontWeight(.light)
                .rotationEffect(self.textAngle())
            
            Capsule()
                .frame(width: self.capsuleWidth(),
                       height: self.capsuleHeight())
                .foregroundColor(self.capsuleColor(dir: marker.label, feedbackScreen: MyVariables.feedbackScreenVal))
                .padding(.bottom, 180)
        }.rotationEffect(.degrees(marker.degrees))
    }
    
        private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 5 : 5
    }

    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 50 : 50
    }

    private func capsuleColor(dir: String, feedbackScreen: Bool) -> Color {
        if (MyVariables.feedbackScreenVal) {
            if (dir == MyVariables.actualDegString) {
                return self.marker.degrees == 0 ? .green : .green
            }
            
            if (dir == MyVariables.directionVar) {
            return self.marker.degrees == 0 ? .blue : .blue
            }
        }
        return self.marker.degrees == 0 ? .gray : .gray
    }

    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegrees - self.marker.degrees)
    }
}

struct ContentView : View {
    @State private var willMoveToNextScreen = false
    var body: some View {
        VStack {
            Text("You chose: " +  MyVariables.directionVar)
            Text("Actual direction facing: " +  MyVariables.actualDegString)
            
            Image("arrowBlack").resizable()
                .aspectRatio(contentMode: .fit).frame(height: 75 )

            ZStack {
                ForEach(Marker.markers(), id: \.self) { marker in
                    CompassMarkerView(marker: marker,
                                      compassDegrees: MyVariables.dirDegrees)
                }
            }
            .frame(width: 300,
                   height: 300)
            .rotationEffect(.degrees(MyVariables.dirDegrees))
            .statusBar(hidden: true)
            Button(action:{
                MyVariables.feedbackScreenVal = false
                    willMoveToNextScreen = true
            } ) {
                Text("Home")
            }.buttonStyle(GradientBackgroundStyle())        }.navigate(to: Home(), when: $willMoveToNextScreen)
        
    }
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

//function to add record of user's direction guess vs their actual direction along with their id
func pushToDatabase(directionGuess : String, actualDirection : String, username : String, degreesGuess: Double, degreesActualStart: Double, degreesActualEnd: Double) {
    //uses public database so all user info is in same place and can be viewed by developer
    // var localStorage = []
    let container = CKContainer(identifier: "iCloud.com.Fiona.OrientationTrackerPhone")
    let publicDatabase = container.publicCloudDatabase
    let record = CKRecord(recordType: "DirectionGuess")
    record.setValuesForKeys(["DirectionG": directionGuess, "ActualGuess": actualDirection, "userKey": username, "DegreesGuess": degreesGuess, "DegreesActualStart": degreesActualStart, "DegreesActual": degreesActualEnd])
    publicDatabase.save(record) { record, error in
        if let error = error {
          //  localStorage.append([directionGuess, actualDirection, username, degreesGuess, degreesActualStart, degreesActualEnd])
            // could add error message to user, ie guess not saved, please try again later
            print("record not saved: ", error)
            return
        }
    print("Record saved successfully")
        // Record saved successfully.
    }
}

//https://stackoverflow.com/questions/56437335/go-to-a-new-view-using-swiftui
//code taken from above allows navigation between screens of app without navigation bar popping up
extension View {

    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
