//
//  Home.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 7/13/21.
//

import Foundation
import SwiftUI
import CloudKit
import UserNotifications

struct Home: View {
    @State private var willMoveToNextScreen = false
    @ObservedObject var compassHeadLog = CompassHeading()
    @ObservedObject var stopWatchManager = StopWatchManager()
    @StateObject var viewRouter: ViewRouter
    var body: some View {
        VStack{
            //need to query from database
            //possibly tell user when to log next instead
            
           
              //  .padding()
            if (MyVariables.userType == 2){
                Button(action: {
                    MyVariables.loginButton = true
                    
                    if let url = URL(string: MyLinks.controlTest) {
                               UIApplication.shared.open(url)
                            }
                    
                    
                })
                    {
                        //links to logOrientation.swift
                        Text("Play Worldle").font(.system(size: 30))           }.buttonStyle(GradientBackgroundStyle()).padding()
                Button(action: {
                    MyVariables.loginButton = true
                   
                    if let url = URL(string: MyLinks.resultForm) {
                               UIApplication.shared.open(url)
                            }
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    sendNotifications(hourNotif: MyVariables.startHour, minuteNotif: 0 , repeatVal: false)
                    viewRouter.currentPage = .page2
                    
                })
                    {
                        //links to logOrientation.swift
                        Text("Upload Results").font(.system(size: 30))           }.buttonStyle(GradientBackgroundStyle())
            }
            else {
            Button(action: {
                MyVariables.loginButton = true
                if (MyVariables.userType == 1) {
                viewRouter.currentPage = .page5
                }
               
                else {
                    if (MyVariables.moreLogsBool == true) {
                        MyVariables.logsLeft = MyVariables.logsLeft - 1
                        if (MyVariables.logsLeft == 1) {
                            MyVariables.homeDisplay = "1 Round Left Today"
                           
                        }
                        else if (MyVariables.logsLeft == 0) {
                            MyVariables.moreLogsBool = false
                            MyVariables.homeDisplay = "No Rounds Left Today. Click to Sign Out"
                        }
                        else{
                            MyVariables.homeDisplay = String(MyVariables.logsLeft) + " Round Left Today"
                        }
                            
                        
                       
                    viewRouter.currentPage = .page5
                    }
                    else
                    {viewRouter.currentPage = .page1}
                }
                MyVariables.calibrateAngle = Double.random(in: 0...360)
                MyVariables.changeAngle = Double.random(in: 0...360)
                MyVariables.dirDegreesStart = self.compassHeadLog.degrees
                MyVariables.homeTime = Date().distance(to: MyVariables.startTime)
                print("HOME")
                print(MyVariables.homeTime)
                MyVariables.startTime = Date()
                if (MyVariables.userType == 1) {
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minute = calendar.component(.minute, from: date)
                    if (hour > MyVariables.startHour && hour < MyVariables.endHour) {
                        MyVariables.hourReminder = hour + 1
                        if (minute > 30) {
                            MyVariables.minuteReminder = Int.random(in: 0..<30)
                        }
                        else {
                            MyVariables.minuteReminder = Int.random(in: 30..<60)
                        }
                        sendNotifications(hourNotif: (MyVariables.hourReminder), minuteNotif: MyVariables.minuteReminder, repeatVal: false)
                        //MyVariables.nextLog = "Last Entry was at " + String(MyVariables.hourReminder) + ":" + String(MyVariables.minuteReminder)
                        for i in MyVariables.hourReminder+1 ... MyVariables.endHour {
                            sendNotifications(hourNotif: i, minuteNotif: MyVariables.minuteReminder, repeatVal: false)
                        }
                    }
                    else {
                    sendNotifications(hourNotif: MyVariables.startHour, minuteNotif: Int.random(in: 0..<59), repeatVal: false)
                    }
                }
                else {
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    sendNotifications(hourNotif: MyVariables.startHour, minuteNotif: 0 , repeatVal: false)
                }
               
              
            })
            {
                //links to logOrientation.swift
                Text(MyVariables.homeDisplay).font(.system(size: 30))           }.buttonStyle(GradientBackgroundStyle())        }       // Spacer()
        }
    }
}

func sendNotifications(hourNotif: Int, minuteNotif: Int, repeatVal: Bool) {
    let content = UNMutableNotificationContent()
    content.title = "Play Round"
    content.sound = UNNotificationSound.default

    // Configure the recurring date.
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    
    dateComponents.hour = hourNotif
    dateComponents.minute = minuteNotif
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(
             dateMatching: dateComponents, repeats: repeatVal)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewRouter: ViewRouter())
            
    }
}
