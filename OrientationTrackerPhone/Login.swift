//
//  Login.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 7/13/21.
//

import Foundation
import SwiftUI
import CloudKit

//variable to be used throughout the app that need to be passed through screens or messages
struct MyVariables {
    static var directionVar = "Empty"
    static var textKey = "Blank"
    static var username = "NA"
    static var passMessage = ""
    static var hourReminder = 0
    static var minuteReminder = 0
    static var nextLog = ""
    static var userType = 1
    static var userKey = ""
    static var startHour = 8
    static var endHour = 20
    static var dirDegreesStart = 0.0
    static var dirDegrees = 0.0
    static var actualDegString = ""
    static var feedbackScreenVal = false
    static var boolVal = false
    static var changeAngle = CGFloat.random(in: 0...360)
    static var startTime = Date()
    static var loginTime = 0.0
    static var homeTime = 0.0
    static var timeToLog = 0.0
    static var timeOnFeedback = 0.0
    static var calibrateTime = 0.0
    static var startVal = 1
    static var calibrateAngle = 45.0
    static var lastCalibrateAngle = 0.0
    static var accuracy = 30.0
    static var homeDisplay = "5 Rounds Left"
    static var logsLeft = 5
    static var blocksLeft = 5
    static var moreLogsBool = true
    static var loginButton = true
    static var calibrateStart = 0.0
    static var calibrateEnd = 0.0
    static var angleForCalibrate = 0.0
    static var userGroupNumLogs = 15
    static var location = ""

    
   
}



struct Login: View {
    @State private var test: () = getLink(inRecordType: "Links", withField: "LookupVal", equalTo: "links")
    @State private var willMoveToNextScreen = false
    @State private var username = ""
    @State private var password: String = ""
    //error message string
    @State var toChange: String = ""
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack{
            //variable to decide if error message should be displayed
            var logError = true
            Text("Welcome")
                .padding().font(.system(size: 30))
            TextField("ID", text: $username).textFieldStyle(.roundedBorder).font(.system(size: 30))
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
           // TextField("Code", text: $password)
             //  .textFieldStyle(.roundedBorder) .font(.system(size: 30))
             //  .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            Text(self.toChange).padding().disabled(true)
            Button(action: {
                self.toChange = "Attempting Login"
                MyVariables.loginButton = false
                MyVariables.loginTime = Date().distance(to: MyVariables.startTime)
                print("LOGIN")
                print(MyVariables.loginTime)
                MyVariables.startTime = Date()
                MyVariables.username = username
                //check if user input for ID and Code match an existing user
                MyVariables.boolVal = login(inRecordType: "UserInfo", withField : "userKey", pswd: username, equalTo : username  )
                logError = MyVariables.boolVal
                    if !logError {
                self.toChange = "Check ID or Internet Connection"
                        MyVariables.loginButton = true
                    }
                    else {
                        MyVariables.userKey = username
                        //will only display briefly if at all
                        self.toChange = "Correct ID or Code"
                    }
                getUserInfo(inRecordType: "UserInfo", withField: "userKey", equalTo: MyVariables.username)
                do {sleep(1)}
                if (MyVariables.userType == 1){
                    MyVariables.userGroupNumLogs = 5
                    MyVariables.logsLeft = 5
                    MyVariables.blocksLeft = 5
                    askPermission()
                    MyVariables.moreLogsBool = true
                    MyVariables.homeDisplay = "Start Session: \n5 Rounds Left"
                }
                else {
                    MyVariables.userGroupNumLogs = 15
                    MyVariables.logsLeft = 15
                    MyVariables.blocksLeft = 2
                    MyVariables.moreLogsBool = true
                    askPermission()
                    MyVariables.homeDisplay = "Start Session: \n15 Rounds Left"
                }
                
                if MyVariables.boolVal == true {
                    viewRouter.currentPage = .page2
                }
            })
            {
                Text("Login") } .font(.system(size: 30))
                .buttonStyle(GradientBackgroundStyle()).disabled(MyVariables.loginButton == false)
            Link("How do I use this app?", destination: URL(string: MyLinks.tutorial)!).padding()
            Text("Please contact campuscompasscuse@gmail.com with any issues").multilineTextAlignment(.center).padding()
            
            Link("Privacy Policy", destination: URL(string: "https://sites.google.com/g.syr.edu/campuscompasscuse/home")!).padding()
            
        }
       
        }
}


//return true if id and code match an existing user
//checks if two record fields exist an correspond
func login(inRecordType: String, withField: String, pswd : String, equalTo: String) -> Bool {
    var returnVal = false
    let container = CKContainer(identifier: "iCloud.com.Fiona.OrientationTrackerPhone")
    let publicDatabase = container.publicCloudDatabase
    let pred = NSPredicate(format: "\(withField) == %@", equalTo)
    let query = CKQuery(recordType: inRecordType, predicate: pred)
    print(query)
    publicDatabase.perform(query, inZoneWith: nil, completionHandler: {results, er in
            if results != nil {
                print(results!)
                        if results?.count == 1 {
                            print(results![0].value(forKey: "userCode")!)
                            
                            if results![0].value(forKey: "userKey") as! String == pswd {
                                returnVal = true
                                print("correctPassword")
                            }
                            else {
                                print("incorrectPassword")
                            }
                        }

                    }
        
                })
    do {
        //gives time to check database, otherwise returnval will exit before query is finished
        sleep(UInt32(1.5))
    }
    return returnVal
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
                            MyVariables.accuracy = results![0].value(forKey: "directionAccuracy") as! Double
                    }
                else {
                    print("Issue in accessing correct record")
                    }
            }
                })
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

func sendTimeToDatabase(){
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(viewRouter: ViewRouter())
    }
}
