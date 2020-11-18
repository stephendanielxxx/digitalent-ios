//
//  QuizContentViewController.swift
//  Digitalent
//
//  Created by Teke on 06/11/20.
//

import UIKit
import MaterialComponents.MDCCard
import Toast_Swift

class QuizContentViewController: BaseViewController {

    var delegate: QuizDelegate!
    var quizModel: AssessmentQuiz!
    var course_id = ""
    var submaterial = ""
    var index: Int = 0
    var quizIndex = ""
    var totalQuestion = ""
    var tempAnswer = ""
    var transactionId = ""
    var userId = ""
    var quiz_duration = ""
    var score = 0
    
    var totalHour = Int()
    var totalMinut = Int()
    var totalSecond = Int()
    var timer:Timer?
    
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizNumber: UILabel!
    @IBOutlet weak var totalQuiz: UILabel!
    @IBOutlet weak var quizTimer: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizQuestion: UITextView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var answerAText: UITextView!
    @IBOutlet weak var answerBText: UITextView!
    @IBOutlet weak var answerCText: UITextView!
    @IBOutlet weak var answerDText: UITextView!
    @IBOutlet weak var answerEText: UITextView!
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonA: MDCCard!
    @IBOutlet weak var buttonB: MDCCard!
    @IBOutlet weak var buttonC: MDCCard!
    @IBOutlet weak var buttonD: MDCCard!
    @IBOutlet weak var buttonE: MDCCard!
    @IBOutlet weak var barButtonA: UIView!
    @IBOutlet weak var barButtonB: UIView!
    @IBOutlet weak var barButtonC: UIView!
    @IBOutlet weak var barButtonD: UIView!
    @IBOutlet weak var barButtonE: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = readStringPreference(key: DigitalentKeys.ID)
        
        buttonPrev.layer.cornerRadius = 18
        buttonNext.layer.cornerRadius = 18
        
        if index == 0 {
            buttonPrev.isHidden = true
        }
        
        if quizIndex == totalQuestion {
            buttonNext.setTitle("FINISH", for: .normal)
            buttonNext.backgroundColor = UIColor(named: "color_589D0B")
        }
        
        quizTitle.text = submaterial
        quizNumber.text = "\(quizIndex)/\(totalQuestion)"
        totalQuiz.text = "\(totalQuestion) Questions"
//        quizTimer.text = "\(timer)"
        
        let durations = quiz_duration.components(separatedBy: ":")
        let hours = durations[0]
        let minutes = durations[1]
        let seconds = durations[2]
        
        totalSecond = (Int(hours)! * 3600) + (Int(minutes)! * 60) + (Int(seconds)! * 1)
        
        startTimer()
        
        let progress =  Float(quizIndex)! / Float(totalQuestion)!
        progressView.setProgress(progress, animated: true)
        
        quizQuestion.attributedText = quizModel.question.htmlToAttributedString
        
        if quizModel.quizImage == "none" {
            quizImage.isHidden = true
            imageHeight.constant = 0
        }
        
        answerAText.attributedText = quizModel.pil1.htmlToAttributedStringAnswer
        answerBText.attributedText = quizModel.pil2.htmlToAttributedStringAnswer
        answerCText.attributedText = quizModel.pil3.htmlToAttributedStringAnswer
        answerDText.attributedText = quizModel.pil4.htmlToAttributedStringAnswer
        answerEText.attributedText = quizModel.pil5.htmlToAttributedStringAnswer
        
        let tapA = QuizAnswerTapGesture(target: self, action: #selector(sendAnswer(_:)))
        tapA.answer = quizModel.pil1
        tapA.selected = "A"
        buttonA.addGestureRecognizer(tapA)
        
        let tapB = QuizAnswerTapGesture(target: self, action: #selector(sendAnswer(_:)))
        tapB.answer = quizModel.pil2
        tapB.selected = "B"
        buttonB.addGestureRecognizer(tapB)
        
        let tapC = QuizAnswerTapGesture(target: self, action: #selector(sendAnswer(_:)))
        tapC.answer = quizModel.pil3
        tapC.selected = "C"
        buttonC.addGestureRecognizer(tapC)
        
        let tapD = QuizAnswerTapGesture(target: self, action: #selector(sendAnswer(_:)))
        tapD.answer = quizModel.pil4
        tapD.selected = "D"
        buttonD.addGestureRecognizer(tapD)
        
        let tapE = QuizAnswerTapGesture(target: self, action: #selector(sendAnswer(_:)))
        tapE.answer = quizModel.pil5
        tapE.selected = "E"
        buttonE.addGestureRecognizer(tapE)
        
        let parameters: [String:Any] = [
            "transaction_id": "\(transactionId)",
            "user_id": "\(userId)",
            "course_id": "\(course_id)",
            "sub_material_id": "\(quizModel.materialID)",
            "quiz_id": "\(quizModel.quizID)"
        ]
        postRequest(url: "quiz/checkanswer", parameters: parameters, tag: "load answer")
        
       
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer?.invalidate()
    }

    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int

        if totalSecond == 0 {
            timer?.invalidate()
        }
        
        if totalSecond > 0 {
            
            if totalSecond == 60 {
                let alert = UIAlertController(title: "", message: "1 Minute left", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            totalSecond = totalSecond - 1
            hours = totalSecond / 3600
            minutes = (totalSecond % 3600) / 60
            seconds = (totalSecond % 3600) % 60
            quizTimer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }else{
            // do something when time is up
            let alert = UIAlertController(title: "", message: "Time's Up", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {action in
                self.delegate.timesUp(index: self.index, duration: self.quizTimer.text!, score: self.score)
            }))
            self.present(alert, animated: true)
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        
        if quizTimer.text != nil && !quizTimer.text!.isEmpty{
            delegate.prevAction(index: index, duration: quizTimer.text!, score: score)
        }else{
            delegate.prevAction(index: index, duration: quiz_duration, score: score)
        }
        
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        if tempAnswer.isEmpty {
            showErrorToast(message: "Please select the answer")
        }else{
            var point = 0
            if tempAnswer.caseInsensitiveCompare(quizModel.answer) == .orderedSame {
                point = 1
                score = score + 1
            }
            
            let parameters: [String:Any] = [
                "transaction_id": "\(transactionId)",
                "user_id": "\(userId)",
                "course_id": "\(course_id)",
                "sub_material_id": "\(quizModel.materialID)",
                "quiz_id": "\(quizModel.quizID)",
                "user_answer": "\(tempAnswer)",
                "point": "\(point)"
            ]
            postRequest(url: "quiz/insertanswer", parameters: parameters, tag: "insert answer")
            
            if quizIndex == totalQuestion {
                // show finish dialog
                delegate.finishAction(score: score)
            }else{
                if quizTimer.text != nil && !quizTimer.text!.isEmpty {
                    delegate.nextAction(index: index, duration: quizTimer.text!, score: score)
                }else{
                    delegate.nextAction(index: index, duration: quiz_duration, score: score)
                }
            }
        }
        
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        
        if tag == "load answer" {
            do{
                let loadAnswerModel = try decoder.decode(LoadAnswerModel.self, from:data)

                if loadAnswerModel.status == "69" {
                    switch loadAnswerModel.data![0].userAnswer {
                    case quizModel.pil1:
                        barButtonA.backgroundColor = UIColor(named: "color_2C64EE")
                        tempAnswer = quizModel.pil1
                        break
                    case quizModel.pil2:
                        barButtonB.backgroundColor = UIColor(named: "color_2C64EE")
                        tempAnswer = quizModel.pil2
                        break
                    case quizModel.pil3:
                        barButtonC.backgroundColor = UIColor(named: "color_2C64EE")
                        tempAnswer = quizModel.pil3
                        break
                    case quizModel.pil4:
                        barButtonD.backgroundColor = UIColor(named: "color_2C64EE")
                        tempAnswer = quizModel.pil4
                        break
                    case quizModel.pil5:
                        barButtonE.backgroundColor = UIColor(named: "color_2C64EE")
                        tempAnswer = quizModel.pil5
                        break
                    default:
                        break
                    }
                }

            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func sendAnswer(_ sender: QuizAnswerTapGesture?) {
        let answer = sender!.answer!
        let selectedAnswer = sender!.selected!
        tempAnswer = answer
        
        switch selectedAnswer {
        case "A":
            barButtonA.backgroundColor = UIColor(named: "color_2C64EE")
            barButtonB.backgroundColor = UIColor.black
            barButtonC.backgroundColor = UIColor.black
            barButtonD.backgroundColor = UIColor.black
            barButtonE.backgroundColor = UIColor.black
            break
        case "B":
            barButtonA.backgroundColor = UIColor.black
            barButtonB.backgroundColor = UIColor(named: "color_2C64EE")
            barButtonC.backgroundColor = UIColor.black
            barButtonD.backgroundColor = UIColor.black
            barButtonE.backgroundColor = UIColor.black
            break
        case "C":
            barButtonA.backgroundColor = UIColor.black
            barButtonB.backgroundColor = UIColor.black
            barButtonC.backgroundColor = UIColor(named: "color_2C64EE")
            barButtonD.backgroundColor = UIColor.black
            barButtonE.backgroundColor = UIColor.black
            break
        case "D":
            barButtonA.backgroundColor = UIColor.black
            barButtonB.backgroundColor = UIColor.black
            barButtonC.backgroundColor = UIColor.black
            barButtonD.backgroundColor = UIColor(named: "color_2C64EE")
            barButtonE.backgroundColor = UIColor.black
            break
        case "E":
            barButtonA.backgroundColor = UIColor.black
            barButtonB.backgroundColor = UIColor.black
            barButtonC.backgroundColor = UIColor.black
            barButtonD.backgroundColor = UIColor.black
            barButtonE.backgroundColor = UIColor(named: "color_2C64EE")
            break
        default:
            barButtonA.backgroundColor = UIColor.black
            barButtonB.backgroundColor = UIColor.black
            barButtonC.backgroundColor = UIColor.black
            barButtonD.backgroundColor = UIColor.black
            barButtonE.backgroundColor = UIColor.black
        }
    }
    
    func showErrorToast(message: String) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.red
        style.messageColor = UIColor.white
        ToastManager.shared.style = style
        self.view.hideAllToasts()
        self.view.makeToast(message)
    }
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        delegate.closeAction(index: index, duration: quizTimer.text!, score: score)
    }
}

protocol QuizDelegate {
    func nextAction(index: Int, duration: String, score: Int)
    func prevAction(index: Int, duration: String, score: Int)
    func closeAction(index: Int, duration: String, score: Int)
    func finishAction(score: Int)
    func timesUp(index: Int, duration: String, score: Int)
}
