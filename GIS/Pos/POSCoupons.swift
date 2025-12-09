//
//  POSCoupons.swift
//  GIS
//
//  Created by Apple Hawkscode on 21/09/21.
//

import UIKit
import DropDown
import Alamofire

class POSCoupons: UIViewController ,GetCustomerDataDelegate, UIViewControllerTransitioningDelegate  {
    
    @IBOutlet weak var mCouponValidity: UITextField!
    @IBOutlet weak var mCouponNumber: UITextField!
    @IBOutlet weak var mCouponAmount: UITextField!
    @IBOutlet weak var mCouponCurrency: UILabel!
    @IBOutlet weak var mCouponRemarks: UITextField!
    @IBOutlet weak var mCouponName: UITextField!
    var mCurrencyImageData = [String]()
    var mCurrencyNameData = [String]()
    
    @IBOutlet weak var mCustomerName: UILabel!
    @IBOutlet weak var mCustomerImage: UIImageView!
    @IBOutlet weak var mSelectedCustomerIcon: UIImageView!
    var mCustomerId = ""
    var mCurrency = ""
    
    @IBOutlet weak var mCurrencyImage: UIImageView!
    var isEdit = ""
    var mCouponId = ""
    var mCCouponName = ""
    
    var mCCouponCode = ""
    var mCustomerNames = ""
    
    var mCCouponValidity = ""
    var mCCouponAmount = ""
    var mCCouponRemark = ""
    var mCCouponCurrency = ""
    let mDatePicker:UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var mChooseCurrencyButt: UIButton!
    @IBOutlet weak var mGiftCardNumberLABEL: UILabel!
    @IBOutlet weak var mValidDateLABEL: UILabel!
    
    @IBOutlet weak var mAddGiftCardLABEL: UILabel!
    
    @IBOutlet weak var mGiftCardNameLABEL: UILabel!
    @IBOutlet weak var mHeaderLABEL: UILabel!
    
    @IBOutlet weak var mAmountLABEL: UILabel!
    var mStoreCurrency = ""

    @IBOutlet weak var mCreateBUTTON: UIButton!
    @IBOutlet weak var mCustomerLABEL: UILabel!
    
    @IBOutlet weak var mAddressPickerIcon: UIImageView!
    @IBOutlet weak var mAddressPickerAlertIcon: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let mStoreCurr = UserDefaults.standard.string(forKey: "storeCurrency") {
            mStoreCurrency = mStoreCurr
        }
        mGetCurrency()
        mGiftCardNameLABEL.text = "Gift Card Name".localizedString
        mAmountLABEL.text = "Amount".localizedString
        mCreateBUTTON.setTitle("create".localizedString , for: .normal)
        mCouponName.placeholder = "Happy Birthday".localizedString
        mCouponRemarks.placeholder = "Remarks".localizedString
        mHeaderLABEL.text = "Gift Card".localizedString
        mCustomerLABEL.text = "Customer".localizedString
        mGiftCardNumberLABEL.text = "Gift Card Number".localizedString
        mValidDateLABEL.text = "Valid Date".localizedString
        
        
        mCustomerId  = UserDefaults.standard.string( forKey: "DEFAULTCUSTOMER") ?? ""
        self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
        self.mCustomerImage.contentMode = .scaleAspectFill
        self.mCustomerImage.downlaodImageFromUrl(urlString: UserDefaults.standard.string( forKey: "DEFAULTCUSTOMERPICTURE") ?? "")
        self.mCustomerName.text = UserDefaults.standard.string( forKey: "DEFAULTCUSTOMERNAME") ?? ""
        self.mCustomerName.isHidden = false
        
        if mCustomerId == "" {
            mOpenCustomerSheet()
        } else {
            mCheckAddresse()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap =  UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

        mCouponAmount.keyboardType = .numberPad
        mCurrencyImage.layer.cornerRadius = 0

        if isEdit != "" {
            
            if let mData = UserDefaults.standard.object(forKey: "EDITCARD") as? NSDictionary {
                self.mCouponName.text = "\(mData.value(forKey: "name") ?? "" )"
                self.mCouponNumber.text = "\(mData.value(forKey: "card_no") ?? "" )"
                self.mCouponRemarks.text = "\(mData.value(forKey: "remark") ?? "" )"
                self.mCouponValidity.text = "\(mData.value(forKey: "expire_date") ?? "" )"
                self.mCouponAmount.text = "\(mData.value(forKey: "amount") ?? "" )"
                self.mCouponId = "\(mData.value(forKey: "custom_cart_id") ?? "" )"
            }
            
        }
        self.mCouponCurrency.text = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "")"
        mShowDatePicker()
        
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        
        self.view.applyGradient(withColours: [#colorLiteral(red: 0.9607843137, green: 0.9411764706, blue: 0.9098039216, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)], gradientOrientation: .vertical)
        
        
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    func mGetCurrency(){
        print("7")
        let urlPath = mGetCurrencies
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:nil, headers: sGisHeaders2).responseJSON
            { response in
                
                if(response.error != nil){
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                }else{
                    guard let jsonData = response.data else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    guard let jsonResult = json as? NSDictionary else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    if let data = jsonResult.value(forKey: "data") as? NSArray {
                        self.mCurrencyNameData = [String]()
                        self.mCurrencyImageData = [String]()
                        for i in data {
                            
                            if let currencyData = i as? NSDictionary {
                                if let currency = currencyData.value(forKey:"currency") , let locationData = currencyData.value(forKey:"url") {
                                    self.mCurrencyNameData.append("\(currency)")
                                    self.mCurrencyImageData.append("\(locationData)")
                                    
                                    if "\(currency)" == self.mStoreCurrency {
                                        
                                        self.mCurrencyImage.downlaodImageFromUrl(urlString: "\(locationData)")
                                        self.mCouponCurrency.text =  "\(currency)"
                                        self.mCurrency = "\(currency)"
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
    
    
    @IBAction func mBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mAddCoupon(_ sender: Any) {
    }
    
    
    @IBAction func mCheckout(_ sender: Any) {
    }
    
    
    @IBAction func mOpenAddressPicker(_ sender: Any) {
        if !mCustomerId.isEmpty {
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddressPicker", bundle: nil)
            if let addressPicker = storyBoard.instantiateViewController(withIdentifier: "AddressPicker") as? AddressPicker {
                addressPicker.mCustomerId = mCustomerId
                self.navigationController?.pushViewController(addressPicker, animated: true)
            }
        }
    }
    
    
    @IBAction func mMyCoupons(_ sender: Any) {
        
        if mCustomerId != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let mCoupons = storyBoard.instantiateViewController(withIdentifier: "POSAllCoupons") as? POSAllCoupons {
                mCoupons.mCustomerId = self.mCustomerId
                self.navigationController?.pushViewController(mCoupons, animated:true)
            }
        }else{
            CommonClass.showSnackBar(message: "Please choose Customer!")
        }
    }
    @IBAction func mChooseCustomer(_ sender: Any) {
        mOpenCustomerSheet()
    }
    func mCreateNewCustomer() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let mCreateCustomer = storyBoard.instantiateViewController(withIdentifier: "CreateCustomer") as? CreateCustomer {
            self.navigationController?.pushViewController(mCreateCustomer, animated:true)
        }
    }
    
    func mCheckAddresse() {
        
        guard Reachability.isConnectedToNetwork() == true else {
            return
        }
        
        let params = ["id": mCustomerId] as [String : Any]
        
        AF.request(mCheckAddress, method:.post,parameters: params,encoding: JSONEncoding.default, headers: sGisHeaders).responseJSON { response in
            
            guard let jsonData = response.data else {
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                      let code = json["code"] as? Int else {
                    return
                }
                
                switch code {
                case 200:
                    if let haveAddress = json["AddressExists"] as? Bool, haveAddress {
                        self.mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
                        self.mAddressPickerAlertIcon.isHidden = true
                    } else {
                        self.mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
                        self.mAddressPickerAlertIcon.isHidden = false
                    }
                case 403:
                    CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                default:
                    break
                }
            } catch {
            }
        }
        
    }
    
    func mGetCustomerData(data: NSMutableDictionary) {
        
        if let id = data.value(forKey: "id") as? String {
            UserDefaults.standard.set(id, forKey: "DEFAULTCUSTOMER")
            self.mCustomerId = id
        }
        
        let profile = data.value(forKey: "profile") as? String ?? ""
        UserDefaults.standard.set(profile, forKey: "DEFAULTCUSTOMERPICTURE")
        
        if let name = data.value(forKey: "name") as? String {
            UserDefaults.standard.set(name, forKey: "DEFAULTCUSTOMERNAME")
            self.mCustomerName.isHidden = false
            self.mCustomerName.text = name
        }
        
        self.mCustomerId = data.value(forKey: "id") as? String ?? ""
        self.mCustomerImage.downlaodImageFromUrl(urlString: profile)
        self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
        self.mCustomerImage.contentMode = .scaleAspectFill
        
        UserDefaults.standard.setValue(nil, forKey: "CustomerBillingAddressUDID")
        UserDefaults.standard.setValue(nil, forKey: "CustomerShippingAddressUDID")
        
        if let haveAddresses = data.value(forKey: "haveAddresses") as? Bool, haveAddresses {
            mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
            mAddressPickerAlertIcon.isHidden = true
        } else {
            mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
            mAddressPickerAlertIcon.isHidden = false
        }
        
    }
    
    func mOpenCustomerSheet(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
            home.delegate = self
            home.modalPresentationStyle = .automatic
            home.transitioningDelegate = self
            self.present(home,animated: true)
        }
    }
    @IBAction func mChooseCurrency(_ sender: Any)
    {
        let dropdown = DropDown()
        dropdown.anchorView = self.mChooseCurrencyButt
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: 50)
        dropdown.width = 200
        dropdown.dataSource = self.mCurrencyNameData
        dropdown.cellNib = UINib(nibName: "Currency", bundle: nil)
        dropdown.customCellConfiguration = {
            (index:Index, item:String,cell: DropDownCell) -> Void in
            guard let cell = cell as? CurrencyCell else { return}
            
            cell.mCurrencyImage.downlaodImageFromUrl(urlString: "\(self.mCurrencyImageData[index])")
            
        }
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            
            self.mCouponCurrency.text = item
            self.mCurrency = item
            self.mCurrencyImage.downlaodImageFromUrl(urlString: self.mCurrencyImageData[index])
            
            
        }
        dropdown.show()
        
    }
    
    @IBAction func mAddCouponNow(_ sender: Any) {
        if mCustomerId == "" {
            mOpenCustomerSheet()
            CommonClass.showSnackBar(message: "Please Choose Customer!")
        }else if mCouponName.text == "" {
            CommonClass.showSnackBar(message: "Please Fill Coupon Name!")
        }else if mCouponNumber.text == "" {
            CommonClass.showSnackBar(message: "Please Fill Coupon Number!")
        }else if mCouponAmount.text == "" {
            CommonClass.showSnackBar(message: "Please Fill Coupon Amount!")
            
        }else  if Double(self.mCouponAmount.text ?? "0") ?? 0.00 == 0.0 {
            CommonClass.showSnackBar(message: "Please fill valid amount!")
            return
        }else if mCouponValidity.text == "" {
            CommonClass.showSnackBar(message: "Please Fill Coupon Validity!")
        }else if mCouponRemarks.text == "" {
            CommonClass.showSnackBar(message: "Please Fill Coupon Remarks!")
        }else{
            guard self.mAddressPickerAlertIcon.isHidden else {
                CommonClass.showSnackBar(message: "Add Billing and Shipping address")
                return
            }
            
            mAddCoupon()
        }
    }
    
    
    
    
    
    
    func mAddCoupon(){
        
        
        let mLocation = UserDefaults.standard.string(forKey: "location")
        
        
        var params = [String : Any]()
        var urlPath =  ""
        if self.isEdit != "" {
            
            urlPath =  mUpdateCoupons
            params = ["custom_cart_id": mCouponId,
                      "name":mCouponName.text ?? "",
                      "amount":Double(mCouponAmount.text ?? "0.00") ?? 0.00,
                      "currency":mCurrency,
                      "card_no":mCouponNumber.text ?? "",
                      "expire_date":mCouponValidity.text ?? "",
                      "remark":mCouponRemarks.text ?? ""]
            
        }else{
            urlPath =  mAddNewCoupons
            
            params = ["customer_id": mCustomerId,
                      "coupon_amount":Double(mCouponAmount.text ?? "0.00") ?? 0.00,
                      "coupon_code":mCouponNumber.text ?? "",
                      "coupon_expire_date":mCouponValidity.text ?? "",
                      "coupon_remark":mCouponRemarks.text ?? "",
                      "currency":mCurrency,
                      "coupon_name":mCouponName.text ?? "" ]
        }
        
        if Reachability.isConnectedToNetwork() == true {
            CommonClass.showFullLoader(view: self.view)
            AF.request(urlPath, method:.post, parameters:params,headers: sGisHeaders2).responseJSON
            { response in
                CommonClass.stopLoader()
                
                if(response.error != nil){
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                }else{
                    guard let jsonData = response.data else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    guard let jsonResult = json as? NSDictionary else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    if jsonResult.value(forKey: "code") as? Int == 200 {
                        if self.isEdit == "" {
                            CommonClass.showSnackBar(message: "Added Successfuly!")
                        }else {
                            CommonClass.showSnackBar(message: "Updated Successfuly!")
                        }
                        
                        self.openCouponCart()
                    }
                    else {
                        CommonClass.showSnackBar(message: "\(jsonResult.value(forKey: "message") ?? "Please try again later.")")
                        if let error = jsonResult.value(forKey: "error") as? String {
                            if error == "Authorization has been expired" {
                                CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                            }
                        }
                        
                    }
                    
                }
                
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
    
    private func openCouponCart(){
        
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if let posAllCoupon = controller as? POSAllCoupons {
                    self.navigationController?.popToViewController(posAllCoupon, animated: true)
                    return
                }
            }
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "moreBoard", bundle: nil)
        if let mCoupons = storyBoard.instantiateViewController(withIdentifier: "POSAllCoupons") as? POSAllCoupons {
            mCoupons.mCustomerId = self.mCustomerId
            self.navigationController?.pushViewController(mCoupons, animated:true)
        }
    }
    
    
    func mShowDatePicker(){
        let currentDate = Date()
        var datecomp = DateComponents()
        let min = Calendar.init(identifier: .gregorian)
        
        mDatePicker.preferredDatePickerStyle = .wheels
        datecomp.day = 0
        let minDates = min.date(byAdding: datecomp, to: currentDate)
        
        datecomp.year = 5
        let maxDates = min.date(byAdding: datecomp, to: currentDate)
        mDatePicker.minimumDate = minDates
        mDatePicker.maximumDate = maxDates
        mDatePicker.datePickerMode = .date
        mDatePicker.backgroundColor = .white
        //ToolBar
        let mToolBar = UIToolbar()
        mToolBar.sizeToFit()
        mToolBar.backgroundColor = .white
        mToolBar.barTintColor = .white
        let mDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePick))
        let mSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let mCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(mCancelDatePick))
        mToolBar.setItems([mDone, mSpace,mCancel], animated: false)
        
        mCouponValidity.inputAccessoryView = mToolBar
        mCouponValidity.inputView = mDatePicker
        
    }
    @objc func doneDatePick(){
        let mDayd = DateFormatter()
        mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        
        mCouponValidity.text  = "\(mYeard.string(from: mDatePicker.date))/" +  "\(mMonthm.string(from: mDatePicker.date))/"+"\(mDayd.string(from: mDatePicker.date))"
        
        self.view.endEditing(true)
        
    }
    @objc func mCancelDatePick(){
        self.view.endEditing(true)
    }
    
}
