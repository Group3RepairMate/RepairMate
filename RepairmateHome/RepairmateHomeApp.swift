
import SwiftUI

@main
struct RepairmateHomeApp: App {
    var garagehelper = Garagehelper()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(garagehelper)
        }
    }
}
