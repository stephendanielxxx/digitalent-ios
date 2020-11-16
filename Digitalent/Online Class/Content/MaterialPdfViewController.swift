//
//  MaterialPdfViewController.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit
import PDFKit

class MaterialPdfViewController: UIViewController {

    var pdf = ""
    var pdfDOC: PDFDocument!

    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openPDF()
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
