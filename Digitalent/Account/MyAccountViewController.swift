//
//  MyAccountViewController.swift
//  Digitalent
//
//  Created by Teke on 13/11/20.
//

import UIKit
import DropDown

class MyAccountViewController: BaseViewController {
    
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
    
    var genderDropDown: DropDown!
    let provincePicker = UIPickerView()
    let cityPicker = UIPickerView()
    var getProvinceModel: GetProvinceModel!
    var getCityModel: GetCityModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        let signoutAccountGesture = UITapGestureRecognizer(target: self, action: #selector(myTargetFunction(sender:)))
        genderField.isUserInteractionEnabled = true
        genderField.addGestureRecognizer(signoutAccountGesture)
        
        provinceField.inputView = provincePicker
        cityField.inputView = cityPicker
        
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
        
//        let province = readStringPreference(key: DigitalentKeys.PROVINCE)
//        provinceField.text = province
        
        let city = readStringPreference(key: DigitalentKeys.CITY)
        cityField.text = city
        
        let zipCode = readStringPreference(key: DigitalentKeys.POSCODE)
        zipCodeField.text = zipCode
        
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
                    provinceField.text = userProvince[0].provinceName
                    
                    let param:[String: Any] = [
                        "province_id":"\(userProvince[0].provinceID)"
                    ]
                    postRequest(url: "api/city", parameters: param, tag: "post init city")
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
}

extension MyAccountViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePicker{
            return getProvinceModel?.province.count ?? 0
        }else{
            return getCityModel?.city.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == provincePicker{
            return getProvinceModel!.province[row].provinceName
        }else {
            return getCityModel!.city[row].cityName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == provincePicker{
            let provinceModel: ProvinceModel = getProvinceModel!.province[row]
            provinceField.text = provinceModel.provinceName
            
            let parameters:[String: Any] = [
                "province_id":"\(provinceModel.provinceID)"
            ]
            
            postRequest(url: "api/city", parameters: parameters, tag: "post city")
        }else{
            let cityModel: CityModel = getCityModel!.city[row]
            cityField.text = cityModel.cityName
        }
    }
    
}
