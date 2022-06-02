//
// TestCircle.swift
//  TemperatureControl
//
//  Created by Anik on 10/9/20.
//
import SwiftUI

struct ContentView3: View {
    @StateObject var viewRouter: ViewRouter
    var body: some View {
        ZStack {
            TemperatureControlView()
        }
    }
}

struct TemperatureControlView: View {
    @State var temperatureValue: CGFloat = 0.0
    @State private var angle: CGFloat = MyVariables.changeAngle
    @State private var length : CGFloat = 250
    @State private var lastAngle: CGFloat = MyVariables.changeAngle
    @State private var isDragging = false
    let config = Config(minimumValue: 0.0,
                        maximumValue: 360.0,
                        totalValue: 360.0,
                        knobRadius: 15.0,
                        radius: 125.0)
    var body: some View {
            ZStack {
                Circle()
                     .fill(.white)
                     .frame(width: length, height: length)
                     //.offset(x: 20)
                     .rotationEffect(.degrees(Double(self.angle)))
                                .gesture(DragGesture()
                                    .onChanged{ v in
                                        var theta = (atan2(v.location.x - self.length / 2, self.length / 2 - v.location.y) - atan2(v.startLocation.x - self.length / 2, self.length / 2 - v.startLocation.y)) * 180 / .pi
                                        if (theta < 0) { theta += 360 }
                                    self.angle = (theta + self.lastAngle) .truncatingRemainder(dividingBy: 360)
                                    MyVariables.changeAngle = self.angle
                                    }
                                    .onEnded { v in
                                        self.lastAngle = self.angle
                                    }
                                )
                Circle().fill(.white).frame(width: 150, height: 150)
                ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker,
                                          compassDegrees: self.angle)
                    }.frame(width: 300,
                            height: 300).rotationEffect(.degrees(Double(self.angle)))
                    .statusBar(hidden: true)
            }
        
      
            
    }
    
}

struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3(viewRouter: ViewRouter())
    }
}
