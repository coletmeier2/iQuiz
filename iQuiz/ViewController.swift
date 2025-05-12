//
//  ViewController.swift
//  iQuiz
//
//  Created by Cole Meier on 5/4/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let quizzes: [Quiz] = [
        Quiz(title: "Mathematics", description: "Test your math skills!", icon: UIImage(systemName: "function")!,
             questions: [
                Question(text: "What is 2 + 2?", options: ["3", "4", "5"], correctIndex: 1),
                Question(text: "What is 5 x 3?", options: ["15", "10", "20"], correctIndex: 0)
             ]),
        Quiz(title: "Marvel Super Heroes", description: "Are you a true Marvel fan?", icon: UIImage(systemName: "person.3.fill")!,
             questions: [
                Question(text: "Who is Iron Man?", options: ["Tony Stark", "Steve Rogers", "Bruce Banner"], correctIndex: 0),
                Question(text: "What is Black Widow's real name?", options: ["Natasha Romanoff", "Wanda Maximoff", "Jean Grey"], correctIndex: 0)
             ]),
        Quiz(title: "Science", description: "Explore the world of science.", icon: UIImage(systemName: "atom")!,
             questions: [
                Question(text: "What is the chemical symbol for water?", options: ["H2O", "CO2", "O2"], correctIndex: 0),
                Question(text: "What planet is known as the Red Planet?", options: ["Mars", "Jupiter", "Saturn"], correctIndex: 0)
             ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes"
        setupToolbar()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupToolbar() {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = quizzes[indexPath.row]
        let session = QuizSession(quiz: selectedQuiz)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let questionVC = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController else {
            fatalError("Could not find QuestionViewController in storyboard")
        }

        questionVC.session = session
        navigationController?.pushViewController(questionVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
