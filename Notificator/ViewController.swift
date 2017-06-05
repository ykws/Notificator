//
//  ViewController.swift
//  Notificator
//
//  Created by Yoshiyuki Kawashima on 2017/06/05.
//  Copyright © 2017 ykws. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    setDatePicker(mode: segmentedControl.selectedSegmentIndex)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Notification
  
  @IBAction func setNotification(_ sender: Any) {
    let identifier = segmentedControl.selectedSegmentIndex == 0 ? "CalendarNotification" : "TimerNotification"
    let trigger = notificationTrigger(mode: segmentedControl.selectedSegmentIndex)
    let request = notificationRequest(identifier: identifier, trigger: trigger)
    let center = UNUserNotificationCenter.current()
    center.add(request, withCompletionHandler: { (error: Error?) in
      if let theError = error {
        print(theError.localizedDescription)
      }
    })
  }
  
  func notificationTrigger(mode: Int) -> UNNotificationTrigger {
    if mode == 0 {
      let calendar = NSCalendar.current
      let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: datePicker.date)
      return UNCalendarNotificationTrigger.init(dateMatching: components, repeats: false)
    }
    
    let timeInterval = datePicker.countDownDuration
    return UNTimeIntervalNotificationTrigger.init(timeInterval: timeInterval, repeats: false)
  }
  
  func notificationRequest(identifier: String, trigger: UNNotificationTrigger) -> UNNotificationRequest {
    let content = UNMutableNotificationContent()
    content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
    content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
    content.sound = UNNotificationSound.default()
    
    return UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }

  // MARK: - Segment
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    setDatePicker(mode: sender.selectedSegmentIndex)
  }
  
  func setDatePicker(mode: Int) {
    if mode == 0 {
      datePicker.datePickerMode = .dateAndTime
      datePicker.date = Date()
    } else {
      datePicker.datePickerMode = .countDownTimer
    }
  }
}

