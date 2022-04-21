//
//  MotherView.swift
//  NavigatinInSwiftUIStarter
//
//  Created by Andreas Schultz on 29.10.20.
//
import SwiftUI

struct MotherView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .page1:
            Login(viewRouter: viewRouter)
        case .page2:
            Home(viewRouter: viewRouter)
        case .page3:
            logOrientation(viewRouter: viewRouter)
        case .page4:
            ContentView(viewRouter: viewRouter)
        case .page5:
            Calibrate(viewRouter: viewRouter)
        
        
         }
    
    
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter())    }
}
