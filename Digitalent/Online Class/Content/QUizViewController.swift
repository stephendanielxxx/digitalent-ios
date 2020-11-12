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
                    openQuiz(index: indexPage, duration: quiz_duration)
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }else if tag == "post get checkpoint" {
            do{
                let getCheckPointModel = try decoder.decode(GetCheckPointModel.self, from:data)
                if getCheckPointModel.status == "69"{
                    let checkPointModel: CheckPointModel = getCheckPointModel.data![0]
                    indexPage = Int(checkPointModel.lastPosition)! - 1
                    quiz_duration = checkPointModel.duration
                }
                
                let parameters: [String:Any] = [
                    "material_id": "\(material_id)"
                ]
                postRequest(url: "quiz/get_quiz_course", parameters: parameters, tag: "post get quiz")
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

extension QUizViewController: QuizDelegate{
   
    func openQuiz(index: Int, duration: String){
        let content = QuizContentViewController()
        content.quiz_duration = duration
        content.course_id = course_id
        content.transactionId = transactionId
        content.delegate = self
        
        let quizModel: AssessmentQuiz = self.getQuizModel.assessmentQuiz[index]
        content.quizModel = quizModel
        content.totalQuestion = String(self.getQuizModel.assessmentQuiz.count)
        content.index = index
        content.quizIndex = String(index + 1)
        
        content.submaterial = submaterial
        content.modalPresentationStyle = .fullScreen
        embed(content, inParent: self, inView: embedView)
    }
    
    func nextAction(index: Int, duration: String) {
        openQuiz(index: index + 1, duration: duration)
    }
    
    func prevAction(index: Int, duration: String) {
        openQuiz(index: index - 1, duration: duration)
    }
    
    func closeAction(index: Int, duration: String) {
        let parameters: [String: Any] = [
            "material_id": "\(material_id)",
            "user_id": "\(userId)",
            "cour_id": "\(course_id)",
            "last_pos": "\(index + 1)",
            "last_score": "0",
            "duration": "\(duration)"
        ]
        
        postRequest(url: "quiz/checkpoint", parameters: parameters, tag: "save checkpoint")
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
