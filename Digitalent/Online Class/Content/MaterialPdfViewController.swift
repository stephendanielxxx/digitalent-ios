//
//  MaterialPdfViewController.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit
import PDFKit

class MaterialPdfViewController: BaseViewController {

    var pdf = ""
    var pdfDOC: PDFDocument!
    
    var course_id = ""
    var sub_material_id = ""

    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openPDF()
        
        let userId = readStringPreference(key: DigitalentKeys.ID)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let currentDate = dateFormatterGet.string(from: date)
        
        let params:[String: Any] = [
            "user_id":"\(userId)",
            "sub_material_id":"\(sub_material_id)",
            "course_id":"\(course_id)",
            "start_at":"\(currentDate)",
            "end_at":"\(currentDate)",
            "status":"1"
        ]
        
        postRequest(url: "quiz/submit_pdf", parameters: params, tag: "post submit pdf")
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        do {
            let submitModel = try decoder.decode(SubmitProgressModel.self, from: data)
            print(submitModel.status)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openPDF(){
        let urlString = "\(DigitalentURL.URL_PDF_CLASS)\(pdf)"
            guard let url = URL(string: urlString) else {return}
            do{
                let data = try Data(contentsOf: url)
                pdfDOC = PDFDocument(data: data)
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                pdfView.displaysAsBook = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDOC
                pdfView.autoScales = true
                pdfView.maxScaleFactor = 4.0
                pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
            }catch let err{
                print(err.localizedDescription)
            }
        }
}
