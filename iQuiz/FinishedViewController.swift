//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Cole Meier on 5/12/25.
//

import UIKit

class FinishedViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    var session: QuizSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz Finished"
        displayResults()
    }

    private func displayResults() {
        let score = session.correctCount
        let total = session.quiz.questions.count
        
        scoreLabel.text = "You scored \(score) out of \(total)."
        
        switch score {
        case total:
            resultLabel.text = "Perfect! 🎉"
        case total - 1:
            resultLabel.text = "Almost there!"
        default:
            resultLabel.text = "Better luck next time!"
        }
    }

    @IBAction func finishTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
