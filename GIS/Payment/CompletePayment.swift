//
//  CompletePayment.swift
//  GIS
//
//  Created by Apple Hawkscode on 17/12/20.
//

import UIKit
import Alamofire

class EmailPopUp: UIView {
    var mType = ""
    @IBOutlet weak var mEmailConfirmationLABEL: UILabel!
    var mOrderId = ""
    
    @IBOutlet weak var mPleaseConfrimLABEL: UILabel!
    @IBOutlet weak var mConfirmButton: UIButton!
    @IBOutlet weak var mEmail: UITextField!
    
    
    var mNavigation = UINavigationController()
    static func instantiate(message: String) -> EmailPopUp {
        let view: EmailPopUp = initFromNib()
        return view
    }

    @IBAction func mClose(_ sender: Any) {
        self.removeFromSuperview()

    }
    
    @IBAction func mConfirm(_ sender: Any) {

        self.removeFromSuperview()

        if mEmail.text == "" {
            CommonClass.showSnackBar(message: "Please fill email!")
        }else if !CommonClass.isValidEmail(emailString: mEmail.text ?? "") {
            CommonClass.showSnackBar(message: "Please fill valid email!")
        }else{
            mEmailUser(mail: mEmail.text ?? "", orderId: mOrderId)

        }
        
       
    }
    func mEmailUser(mail : String , orderId : String ){
        
        
        CommonClass.showFullLoader(view: self)
        
        
        let urlPath =  mEmailReport
        let params = ["email":mail ,"id":orderId ]
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters: params, headers: sGisHeaders2).responseJSON
            { response in
                
                CommonClass.stopLoader()
                
                if(response.error != nil){
                    
                    
                }else{
                    guard let jsonData = response.data else {
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    guard let jsonResult = json as? NSDictionary else {
                        return
                    }
                    if jsonResult.value(forKey: "code") as? Int == 200 {
                        
                        
                        CommonClass.showSnackBar(message: "Email has been sent successfully!")
                        
                    }else{
                        if let error = jsonResult.value(forKey: "error") as? String {
                            if error == "Authorization has been expired" {
                                
                            }
                        }

                    }

                }


            }
        }else{
            CommonClass.showSnackBar(message: "Something went wrong!")
        }

    }


    
    
}
class CompletePayment: UIViewController {

    
    @IBOutlet weak var mCompleteLABEL: UILabel!
    @IBOutlet weak var mGoBackBUTTON: UIButton!
    
    
    
    @IBOutlet weak var mTotalItems: UILabel!
    @IBOutlet weak var mTotalOutStanding: UILabel!
    @IBOutlet weak var mTotalDeposit: UILabel!
    @IBOutlet weak var mGrandTotal: UILabel!
    
    @IBOutlet weak var mDepositePercent: UILabel!
    
    
    
    @IBOutlet weak var mOutstandingLABEL: UILabel!
    @IBOutlet weak var mGrandTotalLABEL: UILabel!
    @IBOutlet weak var mOrderSummaryLABEL: UILabel!
    @IBOutlet weak var mOrderSuccessfulLABEL: UILabel!
    @IBOutlet weak var mOutStandingView: UIStackView!

    @IBOutlet weak var mDepositView: UIStackView!
    var mTotal = ""
    var mDue = ""
    var mType = ""
    var mEmailId = ""
    var mOrderId = ""
    var mCurrency = "$"
    var mTotalQuantity = "1"
    var mTotalOutstandingBal = "0.00"
    var mDepositPercents = "100"
    var mDepositAmount = "0.00"
    var mGrandTotalAmount = "0.00"
    var mUrl = ""
    
    @IBOutlet weak var mGoBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTotalOutStanding.text =  mCurrency + " " + mTotalOutstandingBal.formatPrice()
        mTotalDeposit.text =  mCurrency + " " + mDepositAmount.formatPrice()
        mDepositePercent.text = "Received".localizedString
        mGoBackBUTTON.setTitle("BACK TO POS".localizedString, for: .normal)
        mOutstandingLABEL.text = "Outstanding Balance".localizedString
        mGrandTotalLABEL.text = "Grand Total".localizedString
        mOrderSummaryLABEL.text = "Order Summary".localizedString
        mOrderSuccessfulLABEL.text = "Order Successful".localizedString
         if mType == "exchange_order" || mType == "refund_order" || mType == "deposit" {
            mDepositView.isHidden = true
            mOutStandingView.isHidden = true
        }
        mGrandTotal.text = mCurrency + " " + mGrandTotalAmount.formatPrice()
        if mTotalQuantity != "1"  {
            mTotalItems.text = "\(mTotalQuantity) " + "Item".localizedString
            
        }else{
            mTotalItems.text = "\(mTotalQuantity) " + "Items".localizedString
            
        }
        
        if mType == "Deposit" {
            
        }else if mType == "Refund" {
           
        }else if mType == "Exchange" {
            
        }else if mType == "Gift Card" {
            
        }else{

        }
       
    }
    
    
    
    @IBAction func mPrint(_ sender: Any) {
        
         if mUrl != "" {
            if let url = URL(string: mUrl) {
                UIApplication.shared.open(url)
            }
        }
       
    }
    
    @IBAction func mEmail(_ sender: Any) {
    
        if let mEmailPopUp = UINib(nibName:"emailpopup",bundle:.main).instantiate(withOwner: nil, options: nil).first as? EmailPopUp {
            
            mEmailPopUp.frame = self.view.bounds
            mEmailPopUp.mOrderId = mOrderId
            mEmailPopUp.mEmail.text = mEmailId
            mEmailPopUp.mEmailConfirmationLABEL.text = "Email Confirmation".localizedString
            mEmailPopUp.mPleaseConfrimLABEL.text = "Please confirm your email address where invoice to be sent".localizedString
            mEmailPopUp.mEmail.placeholder = "example: name@mail.com"
            mEmailPopUp.mConfirmButton.setTitle("Confirm".localizedString, for: .normal)
            self.view.addSubview(mEmailPopUp)
            
        }
        
    }
    
    @IBAction func mShare(_ sender: Any) {
         if mUrl != "" {
            let items = [mUrl]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        }
      
    }
    
    @IBAction func mGoBack(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "HomePage1") as? HomePage {
            self.navigationController?.pushViewController(home, animated:true)
        }
    }
    
    func mEmailUser(type: String ){

        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        let urlInvoice = UserDefaults.standard.string(forKey: "reportAPI")
        if urlInvoice != nil {
            mUrl = urlInvoice!
        }
   
        let urlPath =  mEmailReport
        let params = ["location": mLocation, "type":type, "printUrl":mUrl]
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters: params, headers: sGisHeaders2).responseJSON
            { response in

                if(response.error != nil){


                }else{
                    guard let jsonData = response.data else {
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    guard let jsonResult = json as? NSDictionary else {
                        return
                    }
                    if jsonResult.value(forKey: "code") as? Int == 200 {
                        
                        CommonClass.showSnackBar(message: "Email has been sent successfully!")
                        
                    }else{
                        if let error = jsonResult.value(forKey: "error") {
                            if "\(error)" == "Authorization has been expired" {
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


}
