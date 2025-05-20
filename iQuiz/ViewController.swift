// ViewController.swift

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var quizzes: [Quiz] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quizzes"
        setupToolbar()
        tableView.delegate   = self
        tableView.dataSource = self

        loadInitialQuizzes()
    }

    private func setupToolbar() {
        let settings = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(openSystemSettings)
        )
        navigationItem.rightBarButtonItem = settings
    }

    @objc private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString)
        else { return }
        UIApplication.shared.open(url)
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
                    if let cached = NetworkManager.shared.loadCachedQuizzes() {
                        self.quizzes = cached
                    } else {
                        self.quizzes = self.defaultQuizzes()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func defaultQuizzes() -> [Quiz] {
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let quiz = quizzes[ip.row]
        let cell = tv.dequeueReusableCell(withIdentifier: "QuizCell", for: ip)
        cell.textLabel?.text       = quiz.title
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image      = quiz.icon
        return cell
    }
    func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
        let session = QuizSession(quiz: quizzes[ip.row])
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "QuestionViewController")
            as! QuestionViewController
        vc.session = session
        navigationController?.pushViewController(vc, animated: true)
        tv.deselectRow(at: ip, animated: true)
    }
}
