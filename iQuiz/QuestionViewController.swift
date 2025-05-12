//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Cole Meier on 5/12/25.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    var session: QuizSession!
    private var selectedAnswerIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = session.quiz.title

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        displayCurrentQuestion()

    }

    func displayCurrentQuestion() {
        let q = session.currentQuestion
        questionLabel.text = q.text
        selectedAnswerIndex = nil
        tableView.reloadData()
    }

    @IBAction func submitTapped(_ sender: Any) {
        guard let choice = selectedAnswerIndex else {
            return
        }
        session.submitAnswer(choice)
        
        performSegue(withIdentifier: "ShowAnswer", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnswer",
           let answerVC = segue.destination as? AnswerViewController {
            answerVC.session = session
            answerVC.selectedIndex = selectedAnswerIndex!
        }
    }
}

extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.currentQuestion.options.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = session.currentQuestion.options[indexPath.row]
        
        cell.accessoryType = (indexPath.row == selectedAnswerIndex) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        tableView.reloadData()
    }
}
