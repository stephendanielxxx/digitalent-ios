//
//  MyAccountViewController.swift
//  Digitalent
//
//  Created by Teke on 13/11/20.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire

class MyAccountViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var institutionLabel: UILabel!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var aboutField: BottomBorderTF!
    @IBOutlet weak var genderField: BottomBorderTF!
    @IBOutlet weak var birthplaceField: BottomBorderTF!
    @IBOutlet weak var birthdateField: BottomBorderTF!
    @IBOutlet weak var addressField: BottomBorderTF!
    @IBOutlet weak var provinceField: BottomBorderTF!
    @IBOutlet weak var cityField: BottomBorderTF!
    @IBOutlet weak var zipCodeField: BottomBorderTF!
    @IBOutlet weak var occupationField: BottomBorderTF!
    @IBOutlet weak var gradeField: BottomBorderTF!
    @IBOutlet weak var jobField: BottomBorderTF!
    @IBOutlet weak var gradeTitle: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var institutionField: BottomBorderTF!
    @IBOutlet weak var saveButton: UIButton!
    
    var genderDropDown: DropDown!
    let provincePicker = UIPickerView()
    let cityPicker = UIPickerView()
    let occupationPicker = UIPickerView()
    let gradePicker = UIPickerView()
    let jobPicker = UIPickerView()
    var getProvinceModel: GetProvinceModel!
    var getCityModel: GetCityModel!
    var occupationData: [String] = [String]()
    var gradeData: [String] = [String]()
    var jobData: [String] = [String]()
    var imagePicker = UIImagePickerController()
    var provinceId = ""
    var cityId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        occupationData = ["Student","Employee"]
        gradeData = ["1-SD","2-SD","3-SD","4-SD","5-SD","6-SD","7-SMP","8-SMP","9-SMP","10-SMA","11-SMA","12-SMA","10-SMK","11-SMK","12-SMK","D3","S1","S2","S3"]
        jobData = ["Chiropractor","Dentist","Dietitian","Optometrist","Pharmacist","Physician","Physician Assistant","Podiatrist","Registered Nurse","Therapist","Veterinarian","Health Technologist or Technician","Other Healthcare Practitioners and Technical Occupation","Nursing, Psychiatric, or Home Health Aide","Occupational and Physical Therapist Assistant or Aide","Other Healthcare Support Occupation","Chief Executive","General and Operations Manager","Advertising, Marketing, Promotions, Public Relations, and Sales Manager","Operations Specialties Manager (e.g., IT or HR Manager)","Construction Manager","Engineering Manager","Accountant, Auditor","Business Operations or Financial Specialist","Business Owner","Other Business, Executive, Management, Financial Occupation","Architect, Surveyor, or Cartographer","Engineer","Other Architecture and Engineering Occupation","Postsecondary Teacher (e.g., College Professor)","Primary, Secondary, or Special Education School Teacher","Other Teacher or Instructor","Other Education, Training, and Library Occupation","Arts, Design, Entertainment, Sports, and Media Occupations","Computer Specialist, Mathematical Science","Counselor, Social Worker, or Other Community and Social Service Specialist","Lawyer, Judge","Life Scientist (e.g., Animal, Food, Soil, or Biological Scientist, Zoologist)","Physical Scientist (e.g., Astronomer, Physicist, Chemist, Hydrologist)","Religious Worker (e.g., Clergy, Director of Religious Activities or Education)","Social Scientist and Related Worker","Other Professional Occupation","Supervisor of Administrative Support Workers","Financial Clerk","Secretary or Administrative Assistant","Material Recording, Scheduling, and Dispatching Worker","Other Office and Administrative Support Occupation","Protective Service (e.g., Fire Fighting, Police Officer, Correctional Officer)","Chef or Head Cook","Cook or Food Preparation Worker","Food and Beverage Serving Worker (e.g., Bartender, Waiter, Waitress)","Building and Grounds Cleaning and Maintenance","Personal Care and Service (e.g., Hairdresser, Flight Attendant, Concierge)","Sales Supervisor, Retail Sales","Retail Sales Worker","Insurance Sales Agent","Sales Representative","Real Estate Sales Agent","Other Services Occupation","Construction and Extraction (e.g., Construction Laborer, Electrician)","Farming, Fishing, and Forestry","Installation, Maintenance, and Repair","Production Occupations","Other Agriculture, Maintenance, Repair, and Skilled Crafts Occupation","Aircraft Pilot or Flight Engineer","Motor Vehicle Operator (e.g., Ambulance, Bus, Taxi, or Truck Driver)","Other Transportation Occupation","Military","Homemaker","Other Occupation","Not Applicable"]
        
        loadData()
        
        saveButton.layer.cornerRadius = 17
        
        let signoutAccountGesture = UITapGestureRecognizer(target: self, action: #selector(myTargetFunction(sender:)))
        genderField.isUserInteractionEnabled = true
        genderField.addGestureRecognizer(signoutAccountGesture)
        
        provinceField.inputView = provincePicker
        cityField.inputView = cityPicker
        occupationField.inputView = occupationPicker
        gradeField.inputView = gradePicker
        jobField.inputView = jobPicker
        
        occupationPicker.delegate = self
        occupationPicker.dataSource = self
        gradePicker.delegate = self
        gradePicker.dataSource = self
        jobPicker.delegate = self
        jobPicker.dataSource = self
    }
    
    fileprivate func initGenderDropdown() {
        genderDropDown = DropDown()
        
        genderDropDown.anchorView = genderField
        
        genderDropDown.dataSource = ["Male", "Female"]
        
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                genderField.text = "M"
            }else{
                genderField.text = "F"
            }
        }
        
        genderDropDown.width = 200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        initGenderDropdown()
    }
    
    @objc func myTargetFunction(sender: UITapGestureRecognizer) {
        genderDropDown.show()
    }
    
    func loadData(){
        let firstName = readStringPreference(key: DigitalentKeys.FIRST_NAME)
        let lastName = readStringPreference(key: DigitalentKeys.LAST_NAME)
        nameLabel.text = "\(firstName) \(lastName)"
        
        let kelas = readStringPreference(key: DigitalentKeys.KELAS)
        let institution = readStringPreference(key: DigitalentKeys.INSTITUTION)
        institutionLabel.text = "\(kelas) at \(institution)"
        
        let image = readStringPreference(key: DigitalentKeys.USER_PROFILE)
        let baseUrl = DigitalentURL.URL_IMAGE_PROFILE
        let imageURL = "\(baseUrl)\(image)"
        let url = Foundation.URL(string: "\(imageURL)")
        
        imageProfile.pin_setImage(from: url)
        
        imageProfile.makeRoundedWithBorder()
        
        let about = readStringPreference(key: DigitalentKeys.ABOUT)
        aboutField.text = about
        
        let gender = readStringPreference(key: DigitalentKeys.GENDER)
        genderField.text = gender
        
        let birthplace = readStringPreference(key: DigitalentKeys.TEMPAT_LAHIR)
        birthplaceField.text = birthplace
        
        let birthdate = readStringPreference(key: DigitalentKeys.BIRTH_DATE)
        birthdateField.text = birthdate
        
        let address = readStringPreference(key: DigitalentKeys.ADDRESS)
        addressField.text = address
        
        let zipCode = readStringPreference(key: DigitalentKeys.POSCODE)
        zipCodeField.text = zipCode
        
        let occupation = readStringPreference(key: DigitalentKeys.LAST_EDUCATION)
        occupationField.text = occupation
        
        let grade = readStringPreference(key: DigitalentKeys.KELAS)
        gradeField.text = grade
        
        let jobs = readStringPreference(key: DigitalentKeys.SELECT_JOB)
        jobField.text = jobs
        
        institutionField.text = institution
        
        let province = readStringPreference(key: DigitalentKeys.PROVINCE)
        provinceId = province
        
        let city = readStringPreference(key: DigitalentKeys.CITY)
        cityId = city
        
        getRequest(url: "api/province", tag: "get province")
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        if tag == "get province" {
            do {
                self.getProvinceModel = try decoder.decode(GetProvinceModel.self, from: data)
                
                if self.getProvinceModel!.province.count > 0 {
                    provincePicker.delegate = self
                    provincePicker.dataSource = self
                    
                    let provinceId = readStringPreference(key: DigitalentKeys.PROVINCE)
                    let provinces: [ProvinceModel] = self.getProvinceModel!.province
                    let userProvince = provinces.filter({ (province: ProvinceModel) -> Bool in
                        return province.provinceID == provinceId
                    })
                    if userProvince.count > 0 {
                        provinceField.text = userProvince[0].provinceName
                        
                        let param:[String: Any] = [
                            "province_id":"\(userProvince[0].provinceID)"
                        ]
                        postRequest(url: "api/city", parameters: param, tag: "post init city")
                    }
                    
                }
                
            }
            catch{
                print(error.localizedDescription)
            }
        }else if tag == "post city" {
            do {
                self.getCityModel = try decoder.decode(GetCityModel.self, from: data)
                
                if self.getCityModel!.city.count > 0 {
                    cityPicker.delegate = self
                    cityPicker.dataSource = self
                    
                    cityField.text = self.getCityModel!.city[0].cityName
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }else if tag == "post init city" {
            do {
                self.getCityModel = try decoder.decode(GetCityModel.self, from: data)
                
                cityPicker.delegate = self
                cityPicker.dataSource = self
                
                let cityId = readStringPreference(key: DigitalentKeys.CITY)
                let cities: [CityModel] = self.getCityModel!.city
                let userCity = cities.filter({ (city: CityModel) -> Bool in
                    return city.cityID == cityId
                })
                cityField.text = userCity[0].cityName
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calendarAction(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    self.birthdateField.text = formatter.string(from: dt)
                }
            }
    }
    
    @IBAction func changeImageAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageProfile.image = image
        }
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        updateAccount()
    }
    
    func updateAccount(){
        
        self.showSpinner(onView: self.view)
        let uid = readStringPreference(key: DigitalentKeys.ID)
        let gender = genderField.text!
        let tempatlahir = birthplaceField.text!
        let birth_date = birthdateField.text!
        let address = addressField.text!
        let province = provinceId
        let city = cityId
        let poscode = zipCodeField.text!
        let last_education = occupationField.text!
        let kelas = gradeField.text!
        let select_job = jobField.text!
        let institution = institutionField.text!
        let about = aboutField.text!
    
        let upload_file = imageProfile.image!
        
        var parameters = [String:AnyObject]()
        parameters = ["id":uid,
                      "gender":gender,
                      "tempatlahir":tempatlahir,
                      "birth_date":birth_date,
                      "address":address,
                      "province":province,
                      "city":city,
                      "poscode":poscode,
                      "last_education":last_education,
                      "kelas":kelas,
                      "select_job":select_job,
                      "institution":institution,
                      "about":about,
                      "image": upload_file] as [String : AnyObject]
        
        let URL = "\(DigitalentURL.BASE_URL)user/auth/uploadProfile"
        
        uploadImage(endUrl: URL, imageData: upload_file.jpegData(compressionQuality: 0.6), parameters: parameters)
    }
    
    func uploadImage(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((_ isSuccess:Bool) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let headers: HTTPHeaders = [
            
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "\(Date.init().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
        },
                  to: endUrl, method: .post , headers: headers)
            .responseData { response in
                
                switch response.result {
                case .success(let data):
                    self.removeSpinner()
                    let decoder = JSONDecoder()
                    do{
                        let updateProfileModel = try decoder.decode(UpdateProfileModel.self, from:data)
                        if updateProfileModel.code == "200" {
                            self.saveStringPreference(value: self.aboutField.text!, key: DigitalentKeys.ABOUT)
                            self.saveStringPreference(value: self.genderField.text!, key: DigitalentKeys.GENDER)
                            self.saveStringPreference(value: self.birthplaceField.text!, key: DigitalentKeys.TEMPAT_LAHIR)
                            self.saveStringPreference(value: self.birthdateField.text!, key: DigitalentKeys.BIRTH_DATE)
                            self.saveStringPreference(value: self.addressField.text!, key: DigitalentKeys.ADDRESS)
                            self.saveStringPreference(value: self.provinceId, key: DigitalentKeys.PROVINCE)
                            self.saveStringPreference(value: self.cityId, key: DigitalentKeys.CITY)
                            self.saveStringPreference(value: self.zipCodeField.text!, key: DigitalentKeys.POSCODE)
                            self.saveStringPreference(value: self.occupationField.text!, key: DigitalentKeys.LAST_EDUCATION)
                            self.saveStringPreference(value: self.gradeField.text!, key: DigitalentKeys.KELAS)
                            self.saveStringPreference(value: self.jobField.text!, key: DigitalentKeys.SELECT_JOB)
                            self.saveStringPreference(value: self.institutionField.text!, key: DigitalentKeys.INSTITUTION)
                            self.saveStringPreference(value: updateProfileModel.newImage!, key: DigitalentKeys.USER_PROFILE)
                            
                            let alert = UIAlertController(title: "Success", message: "\(updateProfileModel.message)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                                self.loadData()
                            }))
                            self.present(alert, animated: true)
                        }else{
                            let alert = UIAlertController(title: "Failed", message: "\(updateProfileModel.message)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                case .failure(_):
                    self.removeSpinner()
                }
        }
    }
}

extension MyAccountViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePicker{
            return getProvinceModel?.province.count ?? 0
        }else if pickerView == cityPicker{
            return getCityModel?.city.count ?? 0
        }else if pickerView == occupationPicker{
            return occupationData.count
        }else if pickerView == gradePicker{
            return gradeData.count
        }else{
            return jobData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == provincePicker{
            return getProvinceModel!.province[row].provinceName
        }else if pickerView == cityPicker{
            return getCityModel!.city[row].cityName
        }else if pickerView == occupationPicker{
            return occupationData[row]
        }else if pickerView == gradePicker{
            return gradeData[row]
        }else{
            return jobData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == provincePicker{
            let provinceModel: ProvinceModel = getProvinceModel!.province[row]
            provinceField.text = provinceModel.provinceName
            provinceId = provinceModel.provinceID
            
            let parameters:[String: Any] = [
                "province_id":"\(provinceModel.provinceID)"
            ]
            
            postRequest(url: "api/city", parameters: parameters, tag: "post city")
        }else if pickerView == cityPicker{
            let cityModel: CityModel = getCityModel!.city[row]
            cityId = cityModel.cityID
            cityField.text = cityModel.cityName
        }else if pickerView == occupationPicker{
            let selected = occupationData[row]
            occupationField.text = selected
            
            if selected == "Student" {
                gradeTitle.textColor = UIColor.black
                jobTitle.textColor = UIColor.lightGray
                gradeField.isEnabled = true
                jobField.isEnabled = false
                jobField.text = ""
            }else{
                jobTitle.textColor = UIColor.black
                gradeTitle.textColor = UIColor.lightGray
                jobTitle.isEnabled = true
                gradeField.isEnabled = false
                gradeField.text = ""
            }
        }else if pickerView == gradePicker{
            let selected = gradeData[row]
            gradeField.text = selected
        }else{
            let selected = jobData[row]
            jobField.text = selected
        }
    }
    
}
