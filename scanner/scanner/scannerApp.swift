//
//  scannerApp.swift
//  scanner
//
//  Created by Alonso Huerta on 05/05/24.
//

import SwiftUI
import UserNotifications
import PushKit

@main
struct scannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Injecting AppDelegate
    @State private var id: String?


    var body: some Scene {
        WindowGroup {
            ContentView(id: $id)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    @State private var id: String? = nil
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permission for push notifications allowed.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission for push notifications denied.")
            }
        }
        UNUserNotificationCenter.current().delegate = self // Set delegate here
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
        // Get the meeting ID from the original notification.
        let userInfo = response.notification.request.content.userInfo
            
        print(userInfo)
            
        // Always call the completion handler when done.
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                 willPresent notification: UNNotification,
                 withCompletionHandler completionHandler:
                    @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            // Extract the pipe_id from the userInfo dictionary
            if let pipeID = userInfo["pipe_id"] as? String {
                // Use the pipeID value
                print("Pipe ID: \(pipeID)")
            }
        }

        // Modify the presentation options as needed
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }

}

