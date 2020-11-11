//
//  QUizViewController.swift
//  Digitalent
//
//  Created by Teke on 06/11/20.
//

import UIKit

class QUizViewController: BaseViewController {

    var material_id = ""
    var submaterial = ""
    var getQuizModel: GetQuizModel!
    var indexPage = 0
    @IBOutlet weak var embedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters: [String:Any] = [
            "material_id": "\(material_id)"
        ]
        postRequest(url: "quiz/get_quiz_course", parameters: parameters, tag: "post get quiz")
        
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        
        if tag == "post get quiz" {
            do{
                self.getQuizModel = try decoder.decode(GetQuizModel.self, from:data)
                
                if self.getQuizModel.assessmentQuiz.count > 0 {
                    openQuiz(index: indexPage)
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

extension QUizViewController: QuizDelegate{
    func openQuiz(index: Int){
        let content = QuizContentViewController()
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
    
    func nextAction(index: Int) {
        openQuiz(index: index + 1)
    }
    
    func prevAction(index: Int) {
        openQuiz(index: index - 1)
    }

}
