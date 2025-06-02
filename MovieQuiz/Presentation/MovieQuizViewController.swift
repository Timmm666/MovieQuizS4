import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 15
        textLabel.font = UIFont(name : "YSDisplay-Bold", size : 23)
    
        show(quiz : convert(model : questions[currentQuestionIndex]))
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    struct QuizStepViewModel { // вопрос показан
        let image : UIImage
        let question : String
        let questionNumber : String
    }
    
    struct QuizResultsViewModel { // результат квиза
        let title : String
        let text : String
        let buttonText : String
    }
    
    struct QuizQuestion { // картинка / вопрос / ответ на вопрос
        let image : String
        let text : String
        let correctAnswer : Bool
    }
    
    private let questions : [QuizQuestion] = [
        QuizQuestion (image : "The Godfather", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  true),
        QuizQuestion (image : "The Dark Knight", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  true),
        QuizQuestion (image : "Kill Bill", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  true),
        QuizQuestion (image : "The Avengers", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  true),
        QuizQuestion (image : "Deadpool", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  true),
        QuizQuestion (image : "The Green Knight", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  true),
        QuizQuestion (image : "Old", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  false),
        QuizQuestion (image : "The Ice Age Adventures of Buck Wild", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  false),
        QuizQuestion (image : "Tesla", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  false),
        QuizQuestion (image : "Vivarium", text : "Рейтинг этого фильма больше чем 6?", correctAnswer :  false),
    ]
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert (model : QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (image : UIImage(named: model.image) ?? UIImage(), question : model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show (quiz step : QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // приватный метод, который МЕНЯЕТ ЦВЕТ РАМКИ. принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult (isCorrect : Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
        
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10" // 1
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // приватный метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

