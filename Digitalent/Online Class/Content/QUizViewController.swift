//
//  QUizViewController.swift
//  Digitalent
//
//  Created by Teke on 06/11/20.
//

import UIKit

class QUizViewController: BaseViewController {
    
    var course_id = ""
    var material_id = ""
    var submaterial = ""
    var transactionId = ""
    var quiz_duration = ""
    var getQuizModel: GetQuizModel!
    var indexPage = 0
    var userId = ""
    var lastScore = 0
    @IBOutlet weak var embedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = readStringPreference(key: DigitalentKeys.ID)
        
        let parametersCheckPoint: [String:Any] = [
            "material_id": "\(material_id)",
            "user_id": "\(userId)"
        ]
        postRequest(url: "quiz/checkpoint_status", parameters: parametersCheckPoint, tag: "post get checkpoint")
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        
        if tag == "post get quiz" {
            do{
                self.getQuizModel = try decoder.decode(GetQuizModel.self, from:data)
                
                if self.getQuizModel.assessmentQuiz.count > 0 {
                    openQuiz(index: indexPage, duration: quiz_duration, score: lastScore)
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }else if tag == "post get checkpoint" {
            do{
                let getCheckPointModel = try decoder.decode(GetCheckPointModel.self, from:data)
                if getCheckPointModel.status == "69"{
                    let checkPointModel: CheckPointModel = getCheckPointModel.data![0]
                    let lastIndex = Int(checkPointModel.lastPosition)!
                    if lastIndex > 0 {
                        indexPage = lastIndex - 1
                    }else{
                        indexPage = lastIndex
                    }
                    quiz_duration = checkPointModel.duration
                    lastScore = Int(checkPointModel.lastScore)!
                }
                
                let parameters: [String:Any] = [
                    "material_id": "\(material_id)"
                ]
                postRequest(url: "quiz/get_quiz_course", parameters: parameters, tag: "post get quiz")
            }catch{
                print(error.localizedDescription)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension QUizViewController: QuizDelegate, LeaveQuizDelegate, FinishQuizDelegate{
    
    func openQuiz(index: Int, duration: String, score: Int){
        let content = QuizContentViewController()
        content.quiz_duration = duration
        content.course_id = course_id
        content.transactionId = transactionId
        content.delegate = self
        content.score = score
        
        let quizModel: AssessmentQuiz = self.getQuizModel.assessmentQuiz[index]
        content.quizModel = quizModel
        content.totalQuestion = String(self.getQuizModel.assessmentQuiz.count)
        content.index = index
        content.quizIndex = String(index + 1)
        
        content.submaterial = submaterial
        content.modalPresentationStyle = .fullScreen
        embed(content, inParent: self, inView: embedView)
    }
    
    func nextAction(index: Int, duration: String, score: Int) {
        openQuiz(index: index + 1, duration: duration, score: score)
        debugPrint("SCORE \(score)")
    }
    
    func prevAction(index: Int, duration: String, score: Int) {
        openQuiz(index: index - 1, duration: duration, score: score)
    }
    
    func timesUp(index: Int, duration: String, score: Int) {
        let parameters: [String: Any] = [
            "material_id": "\(material_id)",
            "user_id": "\(userId)",
            "cour_id": "\(course_id)",
            "last_pos": "\(index + 1)",
            "last_score": "\(score)",
            "duration": "\(duration)"
        ]
        
        postRequest(url: "quiz/checkpoint", parameters: parameters, tag: "save checkpoint")
        
        countScore(score: score)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeAction(index: Int, duration: String, score: Int) {
        let leaveDialog = LeaveQuizViewController()
        leaveDialog.delegate = self
        leaveDialog.index = index
        leaveDialog.duration = duration
        leaveDialog.score = score
        leaveDialog.providesPresentationContextTransitionStyle = true
        leaveDialog.definesPresentationContext = true
        leaveDialog.modalPresentationStyle = .overCurrentContext
        leaveDialog.modalTransitionStyle = .crossDissolve
        present(leaveDialog, animated: true, completion: nil)
    }
    
    func finishAction(score: Int) {
        let finishDialog = FinishQuizViewController()
        finishDialog.delegate = self
        finishDialog.score = score
        finishDialog.providesPresentationContextTransitionStyle = true
        finishDialog.definesPresentationContext = true
        finishDialog.modalPresentationStyle = .overCurrentContext
        finishDialog.modalTransitionStyle = .crossDissolve
        present(finishDialog, animated: true, completion: nil)
    }
    
    func onLeave(index: Int, duration: String, score: Int){
        let parameters: [String: Any] = [
            "material_id": "\(material_id)",
            "user_id": "\(userId)",
            "cour_id": "\(course_id)",
            "last_pos": "\(index + 1)",
            "last_score": "\(score)",
            "duration": "\(duration)"
        ]
        
        postRequest(url: "quiz/checkpoint", parameters: parameters, tag: "save checkpoint")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func onFinish(score: Int) {
        let parameters: [String: Any] = [
            "material_id": "\(material_id)",
            "user_id": "\(userId)",
            "cour_id": "\(course_id)",
            "last_pos": "0",
            "last_score": "\(score)",
            "duration": "00:00:01"
        ]
        
        postRequest(url: "quiz/checkpoint", parameters: parameters, tag: "save checkpoint")
        
        countScore(score: score)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func countScore(score: Int){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let currentDate = dateFormatterGet.string(from: date)
        
        let params:[String: Any] = [
            "user_id": "\(userId)",
            "course_id": "\(course_id)",
            "sub_material_id": "\(material_id)",
            "start_at": "\(currentDate)",
            "total_score": "\(score)"
        ]
        
        postRequest(url: "quiz/insert_scorepunyadigitalent", parameters: params, tag: "post total score")
    }
    
}
