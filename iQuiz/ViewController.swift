// ViewController.swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var quizzes: [Quiz] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes"
        setupToolbar()
        tableView.delegate = self
        tableView.dataSource = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveQuizzes(_:)),
            name: .didDownloadQuizzes,
            object: nil
        )

        loadInitialQuizzes()
    }

    private func setupToolbar() {
        let settingsButton = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    @objc private func showSettings() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = sb.instantiateViewController(
            withIdentifier: "SettingsViewController"
        ) as! SettingsViewController
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    private func loadInitialQuizzes() {
        let urlString = UserDefaults.standard.string(forKey: Defaults.quizURLKey)
            ?? Defaults.defaultQuizURL
        NetworkManager.shared.fetchQuizzes(from: urlString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetched):
                    self.quizzes = fetched
                case .failure:
                    self.quizzes = self.defaultQuizzes()
                }
                self.tableView.reloadData()
            }
        }
    }

    private func defaultQuizzes() -> [Quiz] {
        // YOUR original hard‑coded quizzes:
        return [
            Quiz(
              title: "Mathematics",
              description: "Test your math skills!",
              icon: UIImage(systemName: "function")!,
              questions: [
                Question(text: "What is 2 + 2?", options: ["3","4","5"], correctIndex: 1),
                Question(text: "What is 5 x 3?", options: ["15","10","20"], correctIndex: 0)
              ]
            ),
            Quiz(
              title: "Marvel Super Heroes",
              description: "Are you a true Marvel fan?",
              icon: UIImage(systemName: "person.3.fill")!,
              questions: [
                Question(text: "Who is Iron Man?", options: ["Tony Stark","Steve Rogers","Bruce Banner"], correctIndex: 0),
                Question(text: "What is Black Widow's real name?", options: ["Natasha Romanoff","Wanda Maximoff","Jean Grey"], correctIndex: 0)
              ]
            ),
            Quiz(
              title: "Science",
              description: "Explore the world of science.",
              icon: UIImage(systemName: "atom")!,
              questions: [
                Question(text: "What is the chemical symbol for water?", options: ["H2O","CO2","O2"], correctIndex: 0),
                Question(text: "What planet is known as the Red Planet?", options: ["Mars","Jupiter","Saturn"], correctIndex: 0)
              ]
            )
        ]
    }

    @objc private func didReceiveQuizzes(_ notification: Notification) {
        if let newQuizzes = notification.object as? [Quiz] {
            quizzes = newQuizzes
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {
        let quiz = quizzes[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "QuizCell",
            for: indexPath
        )
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = quiz.icon
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let session = QuizSession(quiz: quizzes[indexPath.row])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionVC = storyboard.instantiateViewController(
            withIdentifier: "QuestionViewController"
        ) as! QuestionViewController
        questionVC.session = session
        navigationController?.pushViewController(questionVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
