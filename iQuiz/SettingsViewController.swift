//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Cole Meier on 5/14/25.
//

import UIKit
import SystemConfiguration

class SettingsViewController: UIViewController {

    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var checkNowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        let saved = UserDefaults.standard.string(forKey: Defaults.quizURLKey)
            ?? Defaults.defaultQuizURL
        urlTextField.text = saved
    }

    @IBAction private func checkNowTapped(_ sender: Any) {
        view.endEditing(true)

        guard let urlString = urlTextField.text,
              !urlString.isEmpty else {
            showAlert(title: "Error", message: "Please enter a URL.")
            return
        }

        UserDefaults.standard.set(urlString, forKey: Defaults.quizURLKey)

        guard isNetworkAvailable() else {
            showAlert(title: "No Network", message: "Please check your connection.")
            return
        }

        NetworkManager.shared.fetchQuizzes(from: urlString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quizzes):
                    NotificationCenter.default.post(
                        name: .didDownloadQuizzes,
                        object: quizzes
                    )
                    self.showAlert(title: "Success", message: "Quizzes updated.")
                case .failure(let error):
                    self.showAlert(
                        title: "Download Failed",
                        message: error.localizedDescription
                    )
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isNetworkAvailable() -> Bool {
        var zeroAddr = sockaddr_in()
        zeroAddr.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddr))
        zeroAddr.sin_family = sa_family_t(AF_INET)
        guard let ref = withUnsafePointer(to: &zeroAddr, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return false }
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(ref, &flags)
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
}

extension Notification.Name {
    static let didDownloadQuizzes = Notification.Name("didDownloadQuizzes")
}
