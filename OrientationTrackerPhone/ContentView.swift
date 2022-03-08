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
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
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
                .fontWeight(.light).font(.system(size: 25))
                .rotationEffect(self.textAngle())
            //Text(marker.degreeText())
                          //  .fontWeight(.light)
                           // .rotationEffect(self.textAngle())
            
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
        return self.marker.degrees == 0 ? 40 : 40
    }

    private func capsuleColor(dir: String, feedbackScreen: Bool) -> Color {
        if (MyVariables.feedbackScreenVal) {
            /*if (dir == MyVariables.actualDegString) {
                return self.marker.degrees == 0 ? .green : .green
            }*/
            
            if (dir == MyVariables.directionVar) {
            return self.marker.degrees == 0 ? .gray : .gray
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
    @StateObject var viewRouter: ViewRouter
    var body: some View {
        VStack {
            Text("Blue line points to direction you chose. Your answer is counted as correct if it is within \(Int(MyVariables.accuracy)) degrees of the actual value, indicated by the green arc.").fixedSize(horizontal: false, vertical: true).font(.system(size: 20)).padding(.horizontal, 10)
            Text(computeAccuracy(val1: MyVariables.dirDegrees, val2:  360 - MyVariables.changeAngle)).font(.system(size: 20)).bold()
            Text("You chose: " +  MyVariables.directionVar).font(.system(size: 20))
            Text("Actual direction facing: " +  MyVariables.actualDegString).font(.system(size: 20))
            
            Image("arrowBlack").resizable()
                .aspectRatio(contentMode: .fit).frame(height: 75 )
           
                
            ZStack {
                let arcAngles = startEndAngle(angle: MyVariables.accuracy)
               
                Arc(startAngle: .degrees(arcAngles.1), endAngle: .degrees(arcAngles.0), clockwise: true)
                    .stroke(.green, lineWidth: 40)
                    .frame(width: 100, height: 100).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
               /* if (MyVariables.directionVar == MyVariables.actualDegString) {
                Capsule().frame(width: 5,
                                height: 60)
                        .foregroundColor(.blue).padding(.bottom, 125)
                }*/
                ForEach(Marker.markers(), id: \.self) { marker in
                    CompassMarkerView(marker: marker,
                                      compassDegrees: MyVariables.dirDegrees)
                }  .rotationEffect(.degrees(MyVariables.dirDegrees))

                Capsule()
                    .frame(width: 7,
                           height: 40 )
                    .foregroundColor(.blue).padding(EdgeInsets(top: 0, leading: 20, bottom: 135, trailing: 20)).rotationEffect(.degrees(360 - MyVariables.changeAngle + MyVariables.dirDegrees))
               
            }
            .frame(width: 300,
                   height: 300)
          
            .statusBar(hidden: true)
            Button(action:{
                print("BLUE CAPSULE)")
                print(360-MyVariables.changeAngle)
                MyVariables.nextLog = "Please play again later"
                var timeOnFeedback = Date().distance(to:MyVariables.startTime)
                print("FEEDBACK")
                print(timeOnFeedback)
                MyVariables.feedbackScreenVal = false
                   // willMoveToNextScreen = true
                viewRouter.currentPage = .page2
            } ) {
                Text("Home").font(.system(size: 30))
            }.buttonStyle(GradientBackgroundStyle())        }.padding(.bottom, 15)
        
    }
}

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        return path
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

func startEndAngle(angle: Double) -> (angle1: Double, angle2: Double) {
    
    if (angle == 15){
        return (255, 285)
    }
    else if (angle == 30){
        return (240, 300)

        //return (240, 300)
        //240 300
        //210 330
        //270 is halfway
    }
    else if (angle == 45){
        return (225, 315)
    }
    else if (angle == 60){
        return (210, 330)
    }
    else{
        return (240, 330)
    }

}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
