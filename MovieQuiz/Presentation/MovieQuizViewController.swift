import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    // MARK: - Lifecycle
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var currentQuestion : QuizQuestion?
    private var alertPresenter: AlertPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        currentQuestionIndex = 0
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate : self)
        self.questionFactory = questionFactory
        
        // Запрос первого вопроса через делегат
        questionFactory.requestNextQuestion()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 15
        textLabel.font = UIFont(name : "YSDisplay-Bold", size : 23)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else{
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert (model : QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (image : UIImage(named: model.image) ?? UIImage(), question : model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
        
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    
    // приватный метод для показа результатов раунда квиза
    private func showQuizResults() {
        let text = correctAnswers == questionsAmount ?
        "Поздравляем, вы ответили на 10 из 10" :
        "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз"
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                (self.questionFactory as? QuestionFactory)?.reset()
                self.questionFactory?.requestNextQuestion()
            }
        )
        
        alertPresenter?.show(model: alertModel)
    }
}

