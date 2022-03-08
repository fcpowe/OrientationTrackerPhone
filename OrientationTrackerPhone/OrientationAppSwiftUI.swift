//
//  OrientationAppSwiftUI.swift
//  OrientationTrackerPhone
//
//  Created by Fiona Powers Beggs on 12/10/21.
//


import SwiftUI
import CloudKit


@main
struct OrientationAppSwiftUI: App {
    @StateObject var viewRouter = ViewRouter()

     var body: some Scene {
         WindowGroup {
             MotherView(viewRouter: viewRouter)         }
     }
 }

struct MyLinks {
    static var controlTest = "https://worldle.teuteuf.fr/"
    static var tutorial = "https://tinyurl.com/mdy5wj47"
    static var resultForm = "https://forms.gle/WrJTrf3GQyYaKpWA7"
    
}
func getLink(inRecordType: String, withField: String, equalTo: String)  {
    let container = CKContainer(identifier: "iCloud.com.Fiona.OrientationTrackerPhone")
    let publicDatabase = container.publicCloudDatabase
    let pred = NSPredicate(format: "\(withField) == %@", equalTo)
    let query = CKQuery(recordType: inRecordType, predicate: pred)
    print(query)
    publicDatabase.perform(query, inZoneWith: nil, completionHandler: {results, er in
            if results != nil {
                print(results!)
                        if results?.count == 1 {
                            MyLinks.controlTest = results![0].value(forKey: "ControlTest") as! String
                            MyLinks.tutorial = results![0].value(forKey: "Tutorial") as! String
                            MyLinks.resultForm = results![0].value(forKey: "ResultLink") as! String
                           
                    }
                else {
                    print("Issue in accessing correct record")
                    }
            }
                })
    do {
        //gives time to check database, otherwise returnval will exit before query is finished
        sleep(1)
    }
}
