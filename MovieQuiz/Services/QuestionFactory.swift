import Foundation


class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    

        let questions : [QuizQuestion] = [
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
        
    func setup (delegate : QuestionFactoryDelegate){
        self.delegate = delegate
    }
    
    private var currentIndex = 0

    func requestNextQuestion() {
        if currentIndex < questions.count {
            let question = questions[currentIndex]
            delegate?.didReceiveNextQuestion(question: question)
            currentIndex += 1
        } else {
            delegate?.didReceiveNextQuestion(question: nil)
        }
    }

    func reset() {
        currentIndex = 0
    }

    }
    
