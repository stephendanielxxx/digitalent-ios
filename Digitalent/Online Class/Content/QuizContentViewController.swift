//
//  QuizContentViewController.swift
//  Digitalent
//
//  Created by Teke on 06/11/20.
//

import UIKit

class QuizContentViewController: UIViewController {

    var delegate: QuizDelegate!
    var quizModel: AssessmentQuiz!
    var submaterial = ""
    var index: Int = 0
    var quizIndex = ""
    var totalQuestion = ""
    var timer = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        quizTimer.text = "\(timer)"
        
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
    }

    @IBAction func backAction(_ sender: UIButton) {
        delegate.prevAction(index: index)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        delegate.nextAction(index: index)
    }
}

protocol QuizDelegate {
    func nextAction(index: Int)
    func prevAction(index: Int)
}
