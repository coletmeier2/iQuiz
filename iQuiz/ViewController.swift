//
//  ViewController.swift
//  iQuiz
//
//  Created by Cole Meier on 5/4/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let quizzes : [Quiz] = [
        Quiz(title: "Mathematics", description: "Test your math skills!", icon: UIImage(systemName: "function")!),
        Quiz(title: "Marvel Super Heroes", description: "Are you a true Marvel fan?", icon: UIImage(systemName: "person.3.fill")!),
        Quiz(title: "Science", description: "Explore the world of science.", icon: UIImage(systemName: "atom")!)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes"
        setupToolbar()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupToolbar () {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func showSettings () {
        let alert = UIAlertController(title: "Settings", message: "This is the settings page", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quiz = quizzes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = quiz.icon
        return cell
    }
}

