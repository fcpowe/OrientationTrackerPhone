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
    var body: some View {
        VStack{
            //need to query from database
            //possibly tell user when to log next instead
            Text(LocalizedStringKey(MyVariables.nextLog))
                .padding()
            Button(action: {
                willMoveToNextScreen = true
                MyVariables.dirDegreesStart = self.compassHeadLog.degrees
                if (MyVariables.userType == 1) {
                    let center = UNUserNotificationCenter.current()
                    center.removeAllPendingNotificationRequests()
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minute = calendar.component(.minute, from: date)
                    //is this in the right place???
                    if (hour > MyVariables.startHour && hour < MyVariables.endHour) {
                        MyVariables.hourReminder = hour + 1
                        if (minute > 30) {
                            MyVariables.minuteReminder = Int.random(in: 0..<30)
                        }
                        else {
                            MyVariables.minuteReminder = Int.random(in: 30..<60)
                        }
                        sendNotifications(hourNotif: (MyVariables.hourReminder), minuteNotif: MyVariables.minuteReminder, repeatVal: false)
                        MyVariables.nextLog = "Next Entry at " + String(MyVariables.hourReminder) + ":" + String(MyVariables.minuteReminder)
                    }
                    for i in MyVariables.hourReminder+1 ... MyVariables.endHour {
                        sendNotifications(hourNotif: i, minuteNotif: MyVariables.minuteReminder, repeatVal: false)
                    }
                    sendNotifications(hourNotif: MyVariables.startHour, minuteNotif: Int.random(in: 0..<59), repeatVal: false)
                }
            })
            {
                //links to logOrientation.swift
                Text("Log Entry")            }.buttonStyle(GradientBackgroundStyle())        }.navigate(to: logOrientation(), when: $willMoveToNextScreen)       // Spacer()
        }
        
}

func sendNotifications(hourNotif: Int, minuteNotif: Int, repeatVal: Bool) {
    let content = UNMutableNotificationContent()
    content.title = "Log your orientation"
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
    print("Completed")
}

func getUserInfo(inRecordType: String, withField: String, equalTo: String)  {
    let container = CKContainer(identifier: "iCloud.com.Fiona.OrientationTrackerPhone")
    let publicDatabase = container.publicCloudDatabase
    let pred = NSPredicate(format: "\(withField) == %@", equalTo)
    let query = CKQuery(recordType: inRecordType, predicate: pred)
    print(query)
    publicDatabase.perform(query, inZoneWith: nil, completionHandler: {results, er in
            if results != nil {
                print(results!)
                        if results?.count == 1 {
                            MyVariables.userType = results![0].value(forKey: "OneDayGroup") as! Int
                            MyVariables.startHour = results![0].value(forKey: "startHour") as! Int
                            MyVariables.endHour = results![0].value(forKey: "endHour") as! Int
                    }
                else {
                    print("Issue in accessing correct record")
                    }
            }
                })
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            
    }
}
