//
//  ViewController.swift
//  ClockUIKit
//
//  Created by Engy on 12/6/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hour: UIImageView!
    @IBOutlet weak var minute: UIImageView!
    @IBOutlet weak var second: UIImageView!

    var isRotated: Bool = false
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        setUpNotificationCenter()
    }

    func updateUI() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let todayDate = Date()
            let currentHour = Calendar.current.component(.hour, from: todayDate)
            let currentMin = Calendar.current.component(.minute, from: todayDate)
            let currentSec = Calendar.current.component(.second, from: todayDate)

            // Update clock images for hour, minute, and second
            self.hour.image = UIImage(named: String(currentHour))
            self.minute.image = UIImage(named: String(currentMin))
            self.second.image = UIImage(named: String(currentSec))
        }
    }

    func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }

    @objc func orientationChanged() {
        if UIDevice.current.orientation == .landscapeLeft {
            if !isRotated {
                rotateClockImages(by: .pi / 2)
                isRotated = true
            }
        } else if UIDevice.current.orientation == .portrait {
            if isRotated {
                rotateClockImages(by: -(.pi / 2))
                isRotated = false
            }
        }
    }

    private func rotateClockImages(by angle: CGFloat) {
        hour.transform = hour.transform.rotated(by: angle)
        minute.transform = minute.transform.rotated(by: angle)
        second.transform = second.transform.rotated(by: angle)
    }

    deinit {
        // Remove the observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
}
