import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory?.requestNextQuestion()
        
        if let firstQuestion = questionFactory?.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }

        
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
        show(quiz: viewModel)
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion : QuizQuestion?
    
    
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
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз"
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else {
            currentQuestionIndex += 1
            if let nextQuestion = questionFactory?.requestNextQuestion() {
                currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)

                show(quiz: viewModel)
            }
        }
    }
    
    // приватный метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            if let firstQuestion = self.questionFactory?.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)

                self.show(quiz: viewModel)
            }
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

