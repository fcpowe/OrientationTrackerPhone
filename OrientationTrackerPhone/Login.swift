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
}

struct Login: View {
    @State private var willMoveToNextScreen = false
    @State private var username = ""
    @State private var password: String = ""
    //error message string
    @State private var toChange: String = ""
    

    var body: some View {
        VStack{
            //variable to decide if error message should be displayed
            var logError = true
            Text("Welcome")
                .padding()
            TextField("ID", text: $username)
                .padding()
            TextField("Code", text: $password)
                .padding()
            TextField("",text: $toChange).padding().disabled(true)
            Button(action: {
                MyVariables.username = username
                //check if user input for ID and Code match an existing user
                        willMoveToNextScreen = doesRecordExist(inRecordType: "UserInfo", withField : "userKey", pswd: password, equalTo : username  )
                logError = willMoveToNextScreen
                    if !logError {
                self.toChange = "Incorrect ID or Code"
                    }
                    else {
                        //will only display briefly if at all
                        self.toChange = "Correct ID or Code"
                    }
            })
            {
                Text("Login")            }.buttonStyle(GradientBackgroundStyle())        }.navigate(to: Home(), when: $willMoveToNextScreen)
        }
}


//return true if id and code match an existing user
//checks if two record fields exist an correspond
func doesRecordExist(inRecordType: String, withField: String, pswd : String, equalTo: String) -> Bool {
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
                            if results![0].value(forKey: "userCode") as! String == pswd {
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
        sleep(1)
    }
    return returnVal
}
 
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            
    }
}
