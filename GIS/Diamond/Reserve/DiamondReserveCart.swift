//
//  DiamondReserveCart.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 31/10/22.
//  Copyright © 2022 Hawkscode. All rights reserved.
//

import UIKit
import UIDrawer
import Alamofire

class DiamondReserveCart: UIViewController , GetCustomerDataDelegate , UIViewControllerTransitioningDelegate , UITextViewDelegate {
 
    
    
    @IBOutlet weak var mCustomerName: UILabel!
    @IBOutlet weak var mCustomerImage: UIImageView!
    
    @IBOutlet weak var mSelectedCustomerIcon: UIImageView!
    
    @IBOutlet weak var mProductImage: UIImageView!
    
    
    
    

    
    
    @IBOutlet weak var mCheckOutView: UIView!
    

    @IBOutlet weak var mProductInfo: UILabel!
    
    @IBOutlet weak var mShape: UILabel!
    
    @IBOutlet weak var mTotalCarats: UILabel!
    
    @IBOutlet weak var mStockId: UILabel!
    
    
    @IBOutlet weak var mAmount: UILabel!
    @IBOutlet weak var mDueDate: UITextField!
    @IBOutlet weak var mNotes: UITextView!
    
    let mDatePicker:UIDatePicker = UIDatePicker()
    var mData = NSDictionary()
    var mCustomerId = ""
    

    @IBOutlet weak var mSubmitButton: UIButton!
    @IBOutlet weak var mNoteLABEL: UILabel!
    @IBOutlet weak var mCustomerLABEL: UILabel!
    @IBOutlet weak var mHeading: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mSubmitButton.setTitle("SUBMIT".localizedString, for: .normal)
        mNoteLABEL.text = "Note".localizedString
        mHeading.text = "Reserve".localizedString
        mCustomerLABEL.text = "Customer".localizedString

        // Do any additional setup after loading the view.
        
        self.mProductInfo.text = "\(mData.value(forKey: "Carat") ?? "") Carat, \(mData.value(forKey: "Shape") ?? "") - \(mData.value(forKey: "Colour") ?? "")/\(mData.value(forKey: "Clarity") ?? "")"
        
        self.mStockId.text = "\(mData.value(forKey: "StockID") ?? "")"
        self.mShape.text = "\(mData.value(forKey: "Shape") ?? "")"
        self.mTotalCarats.text = "\(mData.value(forKey: "Carat") ?? "")"
        self.mAmount.text = "\(mData.value(forKey: "Price") ?? "")"
        self.mProductImage.downlaodImageFromUrl(urlString: "")
        self.mCustomerName.text = ""
        mCustomerImage.contentMode = .scaleAspectFill

        
        mNotes.delegate = self
        mNotes.text = "Eg. Urgent Order"
        mNotes.textColor = .placeholderText
        mNotes.borderWidth = 0
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyy"
        mDueDate.text =  formatter.string(from: currentDateTime)
        }
    
    override
    func viewDidAppear(_ animated: Bool) {
        
        mShowDatePicker()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
            home.delegate = self
            home.modalPresentationStyle = .automatic
            home.transitioningDelegate = self
            self.present(home,animated: true)
        }
    }

    @IBAction func mBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == mNotes {
            
            mNotes.text = ""
            mNotes.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
       
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == mNotes {
            if mNotes.text == "" {
                mNotes.text = "Eg. Urgent Order"
                mNotes.textColor = .placeholderText
            }
        }
    }
   
    
    
    @IBAction func mDeleteReserve(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mOpenImages(_ sender: Any) {
  
    }
    
    func mCreateNewCustomer() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let mCreateCustomer = storyBoard.instantiateViewController(withIdentifier: "CreateCustomer") as? CreateCustomer {
            self.navigationController?.pushViewController(mCreateCustomer, animated:true)
        }
    }
    func mGetCustomerData(data: NSMutableDictionary) {
        
        UserDefaults.standard.set(data.value(forKey: "id") as? String ?? "", forKey: "DEFAULTCUSTOMER")
        UserDefaults.standard.set(data.value(forKey: "profile") ?? "", forKey: "DEFAULTCUSTOMERPICTURE")
        UserDefaults.standard.set(data.value(forKey: "name") as? String ?? "", forKey: "DEFAULTCUSTOMERNAME")

        self.mCustomerName.text = data.value(forKey: "name") as? String
        self.mCustomerId = data.value(forKey: "id") as? String ?? ""
        self.mCustomerImage.contentMode = .scaleAspectFill
        self.mCustomerImage.downlaodImageFromUrl(urlString: data.value(forKey: "profile") as? String ?? "")
        self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")

    }

    
    @IBAction func mChooseCustomer(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
            home.delegate = self
            home.modalPresentationStyle = .automatic
            home.transitioningDelegate = self
            self.present(home,animated: true)
        }
    }
   
    
    
    @IBAction func mCreateReseveNow(_ sender: Any) {
        
        if mCustomerId == "" {
            CommonClass.showSnackBar(message: "Please choose customer!")
            
        }
        
        if mDueDate.text?.count == 0 {
            CommonClass.showSnackBar(message: "Please choose due date!")
            return
        }
        if mNotes.text == "Eg. Urgent Order" {
            CommonClass.showSnackBar(message: "Please fill notes!")
            return
        }
        if mNotes.text?.count == 0 {
            CommonClass.showSnackBar(message: "Please fill notes!")
            return
        }
        
        let currentDateTime = Date()
        let formattedDate =  currentDateTime.getFormattedDate(format: "MM/dd/yyy")
        
        
        let params:[String: Any] = ["id" : mData.value(forKey: "id") as? String ?? "" , "customer_id": self.mCustomerId, "date":formattedDate,"dueDate":self.mDueDate.text ?? "", "remark":self.mNotes.text ?? ""]
        
        CommonClass.showFullLoader(view: self.view)
        
        mGetData(url: mDiamondCreateReserveAPI,headers: sGisHeaders,  params: params) { response , status in
            CommonClass.stopLoader()
            if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "diamondModule", bundle: nil)
                    if let mDiamondProductDetails = storyBoard.instantiateViewController(withIdentifier: "DiamondReservedItems") as? DiamondReservedItems {
                        var controllers = self.navigationController?.viewControllers
                        controllers?.removeLast()
                        controllers?.removeLast()
                        controllers?.append(mDiamondProductDetails)
                        if let navStack = controllers {
                            self.navigationController?.setViewControllers(navStack, animated: true)
                        }
                    }
                }else if "\(response.value(forKey: "code") ?? "")" == "403" {
                    CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                }
            }
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
    
        mDueDate.inputAccessoryView = mToolBar
        mDueDate.inputView = mDatePicker
    
    }
    @objc func doneDatePick(){
        let mDayd = DateFormatter()
            mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
            mMonthm.dateFormat = "MM"
              
        let mYeard = DateFormatter()
            mYeard.dateFormat = "yyyy"
              
        
        mDueDate.text  = "\(mMonthm.string(from: mDatePicker.date))/" +  "\(mDayd.string(from: mDatePicker.date))/"+"\(mYeard.string(from: mDatePicker.date))"

        self.view.endEditing(true)
   
    }
    @objc func mCancelDatePick(){
        self.view.endEditing(true)
    }
    
}

extension Date {
    
    func getFormattedDate(format:String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
