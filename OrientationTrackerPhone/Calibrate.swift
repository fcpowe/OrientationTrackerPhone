//
//  Calibrate.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 1/14/22.
//

import Foundation
import SwiftUI
import CloudKit
import UserNotifications

struct Marker3: Hashable {
    let degrees: Double
    let label: String

    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }

    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }

    static func markers3() -> [Marker3] {
        return [
            Marker3(degrees: 0, label: ""),
            Marker3(degrees: 30),
            Marker3(degrees: 60),
            Marker3(degrees: 90, label: ""),
            Marker3(degrees: 120),
            Marker3(degrees: 150),
            Marker3(degrees: 180, label: ""),
            Marker3(degrees: 210),
            Marker3(degrees: 240),
            Marker3(degrees: 270, label: ""),
            Marker3(degrees: 300),
            Marker3(degrees: 330)
        ]
    }
}

struct CompassMarkerView3: View {
    let marker3: Marker3
    let compassDegress: Double

    var body: some View {
    
        VStack {
            
            Capsule()
                .frame(width: self.capsuleWidth(),
                       height: self.capsuleHeight())
                .foregroundColor(self.capsuleColor())
            
            Text(marker3.label)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 180)
        }.rotationEffect(Angle(degrees: marker3.degrees))
            
          
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker3.degrees == 0 ? 15 : 3
    }

    private func capsuleHeight() -> CGFloat {
        return self.marker3.degrees == 0 ? 60 : 30
    }

    private func capsuleColor() -> Color {
        return self.marker3.degrees == 0 ? .blue : .gray
    }

    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegress - self.marker3.degrees)
    }
}


struct Calibrate : View {
    @ObservedObject var compassHeading = CompassHeading()
    @StateObject var viewRouter: ViewRouter
    var body: some View {
        
        VStack{
            Text("Please rotate yourself until the green line overlaps the blue line.").padding().font(.system(size: 30))
            ZStack{
        Capsule()
            .frame(width: 30,
                   height: 60 )
            .foregroundColor(.green).padding(EdgeInsets(top: 175, leading: 20, bottom: 0, trailing: 20)).rotationEffect(.degrees(MyVariables.calibrateAngle))
            ZStack {
                
                ForEach(Marker3.markers3(), id: \.self) { marker3 in
                    CompassMarkerView3(marker3: marker3,
                                      compassDegress: self.compassHeading.degrees)
                }
            }
            .frame(width: 300,
                   height: 300)
            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                .statusBar(hidden: true)}
            Button(action: { viewRouter.currentPage = .page3
                MyVariables.calibrateTime = Date().distance(to: MyVariables.startTime)
                print("LOGIN")
                print(MyVariables.calibrateTime)
                MyVariables.startTime = Date()
                MyVariables.dirDegreesStart = self.compassHeading.degrees
                MyVariables.calibrateEnd = MyVariables.dirDegreesStart
                MyVariables.angleForCalibrate = MyVariables.calibrateAngle
                var subtract = MyVariables.calibrateStart - MyVariables.calibrateEnd
                
                
            }) {
                Text("Submit").font(.system(size: 30))
            }.buttonStyle(GradientBackgroundStyle()).padding(.top, 90)

        }
    }
    }



struct Calibrate_Previews: PreviewProvider {
    static var previews: some View {
        Calibrate(viewRouter: ViewRouter())
    }
}
