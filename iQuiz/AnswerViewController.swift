//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Cole Meier on 5/12/25.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var session: QuizSession!
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = session.quiz.title
        displayAnswer()
    }
    
    private func displayAnswer() {
        let question = session.quiz.questions[session.current]
        questionLabel.text = question.text
        
        let correctIdx = question.correctIndex
        correctAnswerLabel.text = "Correct answer: \(question.options[correctIdx])"
        
        if selectedIndex == correctIdx {
            feedbackLabel.text = "✅ You’re right!"
        } else {
            feedbackLabel.text = "❌ That’s incorrect."
        }
        
        if session.isLastQuestion {
            nextButton.setTitle("Finish", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if session.isLastQuestion {
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        } else {
            session.advance()
            // Pop to the Question VC and update it
            if let questionVC = navigationController?.viewControllers.first(where: { $0 is QuestionViewController }) as? QuestionViewController {
                questionVC.session = session
                questionVC.displayCurrentQuestion()
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            finishedVC.session = session
        }
    }
}
