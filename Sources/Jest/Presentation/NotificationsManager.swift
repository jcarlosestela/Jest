//
//  NotificationsManager.swift
//  Jest
//
//  Created by José Carlos Estela Anguita on 10/06/2020.
//

import Foundation

public protocol NotificationsManagerProtocol: UNUserNotificationCenterDelegate {
    associatedtype Handler
    var handler: Handler? { get set }
    func registerForRemoteNotifications()
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data)
}

public protocol NotificationsHandler: class {
    func handleNotification(withUserInfo userInfo: [AnyHashable: Any])
}
