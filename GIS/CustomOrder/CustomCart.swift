//
//  CustomCart.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 30/12/22.
//  Copyright © 2022 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

let mRemovePopUp = UINib(nibName:"removepopup", bundle: .main).instantiate(withOwner: nil, options: nil).first as? RemovePopUp ?? RemovePopUp()

protocol DeleteCustomCartItems {
    func mDeleteCartItems(index:Int)
}

class RemovePopUp: UIView {
    var mType = ""
    var mCustomerId = ""
    var mCartId = ""
    var index = Int()
    
    var delegate:DeleteCustomCartItems? = nil

    @IBOutlet weak var mMessage: UILabel!
    @IBOutlet weak var mConfirmButton: UIButton!
    @IBOutlet weak var mCancelButton: UIButton!
    
    var mNavigation = UINavigationController()
    static func instantiate(message: String) -> RemovePopUp {
        let view: RemovePopUp = initFromNib()
        return view
    }

    @IBAction func mCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func mConfirm(_ sender: Any) {
        if mType == "deposit" || mType == "quotation" || mType == "giftCard" || mType == "refund" || mType == "exchange" {
            self.removeFromSuperview()
            self.delegate?.mDeleteCartItems(index:self.index)
            return
        }
        CommonClass.showFullLoader(view: self)
        let mParams = [ "customer_id":mCustomerId , "custom_cart_id":mCartId] as [String : Any]
        
        
        mGetData(url: mDeleteCartItem,headers: sGisHeaders,  params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
            if "\(response.value(forKey: "code") ?? "")" == "200" {
                self.removeFromSuperview()
                self.delegate?.mDeleteCartItems(index:self.index)
            }else{
          
            }
        }
    }
        
    }
}

class CustomCartItems : UITableViewCell {
    
    @IBOutlet weak var mServiceLabourView: UIView!
    @IBOutlet weak var mServiceLabourCount: UILabel!
    @IBOutlet weak var mServiceLabourCharges: UILabel!
    @IBOutlet weak var mShowServiceLabourButton: UIButton!
    @IBOutlet weak var mEditServiceLabourButton: UIButton!
    @IBOutlet weak var mEditServiceLabourIcon: UIImageView!
   
    
    
    @IBOutlet weak var mRemoveButton: UIButton!
    @IBOutlet weak var mCurrency: UILabel!
    @IBOutlet weak var mEditIcon: UIImageView!
    @IBOutlet weak var mDesignButton: UIButton!
    @IBOutlet weak var mMetalColorSize: UILabel!
    @IBOutlet weak var mProductName: UILabel!
    @IBOutlet weak var mProductPrice: UITextField!
    @IBOutlet weak var mMinusButton: UIButton!
    @IBOutlet weak var mSKUName: UILabel!
    @IBOutlet weak var mPickStockId: UIButton!
    @IBOutlet weak var mRemarks: UITextField!
    @IBOutlet weak var mChooseDateButton: UIButton!
    @IBOutlet weak var mPlusButton: UIButton!
    @IBOutlet weak var mProductImage: UIImageView!
    @IBOutlet weak var mStockId: UILabel!
    @IBOutlet weak var mDueDate: UITextField!
     @IBOutlet weak var mQuantityUnit: UILabel!
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var mSNView: UIView!
    
    
    @IBOutlet weak var mDiscountPercent: UITextField!
    @IBOutlet weak var mDiscountAmount: UITextField!
    @IBOutlet weak var mImageHolderView: UIView!
    @IBOutlet weak var mStockView: UIView!
    @IBOutlet weak var mQtyView: UIView!
    
    @IBOutlet weak var mOpenProductDetailsButton: UIButton!
    @IBOutlet weak var mAmountView: UIView!
    
    @IBOutlet weak var mSNo: UILabel!
    
    
    
     @IBOutlet weak var mRemarksView: UIView!
    
    
    func imageTapGesture(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        mProductImage.isUserInteractionEnabled = true
        mProductImage.addGestureRecognizer(tapGesture)
    }
    
}
class CustomCart: UIViewController, UIViewControllerTransitioningDelegate ,GetCustomerDataDelegate , UITableViewDataSource ,UITableViewDelegate, GetInventoryDataItemsDelegate , DeleteCustomCartItems, SearchDelegate, EditProductDelegate, ConfirmationDelegate, GetQuotationDelegate, ServiceLabourDelegate {
   

    @IBOutlet weak var mSearchField: UITextField!

    @IBOutlet weak var mTotalItems: UILabel!
    @IBOutlet weak var mGrandTotal: UILabel!
    @IBOutlet weak var mDepositAmount: UILabel!
    @IBOutlet weak var mOutstandingAmount: UILabel!
    @IBOutlet weak var mSelectedCustomerIcon: UIImageView!
    var mCustomerId = ""
    var isQuotation = false
    var mQuotationId = ""
    @IBOutlet weak var mNotes: UITextField!
    var mDepositPercentData = ["25%","50%","75%","100%"]
    var mDepositPercentValue = ["25","50","75","100"]
    var mCurrency = ""
    var mGrandTotalCart = "0.00"
    @IBOutlet weak var mDepositePercent: UILabel!
    var mDepositPercents = "100"
    var mGrandTotalAmounts = "0.00"
    var mTotalDepositAmounts = "0.00"
    var mOutStandingAmounts = "0.00"
    @IBOutlet weak var mCartTable: UITableView!
    var mCartData = NSMutableArray()
    var mCartDataMaster = NSArray()

    var mCartAmount = [Double]()
    var mQuantityData = [Int]()
    var mCurrentIndex = -1
    let mDatePicker:UIDatePicker = UIDatePicker()
    var isItemsAvailable =  false
    var isDeleted = false
    var mServiceAmounts = [Double]()
    @IBOutlet weak var mQuotationCount: UILabel!
    @IBOutlet weak var mQuoteButton: UIButton!
    
    @IBOutlet weak var mQuotationView: UIView!
    
    @IBOutlet weak var mHeadingLABEL: UILabel!
    
    @IBOutlet weak var mOutstandingBalance: UILabel!
    @IBOutlet weak var mDepositeLABEL: UILabel!
    @IBOutlet weak var mGrandTotalLABEL: UILabel!
    @IBOutlet weak var mNoteLABEL: UILabel!
    
    @IBOutlet weak var mCheckOutButton: UIButton!
    
    @IBOutlet weak var mBottomQuotationLABEL: UILabel!
    
    @IBOutlet weak var mBottomCustomerLABEL: UILabel!

    @IBOutlet weak var mBottomCatalogLABEL: UILabel!
    @IBOutlet weak var mBottomInventoryLABEL: UILabel!
    
    
    @IBOutlet weak var mAddressPickerIcon: UIImageView!
    @IBOutlet weak var mAddressPickerAlertIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        self.mNotes.keyboardType = .default
        self.mCartTable.delegate = self
        self.mCartTable.dataSource = self
        self.mCartTable.reloadData()
        mCustomerId  = UserDefaults.standard.string( forKey: "DEFAULTCUSTOMER") ?? ""
    }
    
    func mOnUpdated(data: NSDictionary) {
        mFetchCartItems()
    }
    
    @IBAction func mOpenProductStoneDetails(_ sender: UIButton) {
        let mIndex = sender.tag
        if let mData = mCartData[mIndex] as? NSDictionary,
           let customCartId = mData.value(forKey: "custom_cart_id") as? String,
           let productId = mData.value(forKey: "id") as? String {
            let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
            if let home = storyBoard.instantiateViewController(withIdentifier: "ProductStoneEdit") as? ProductStoneEdit {
                home.modalPresentationStyle = .automatic
                home.mCartId = "\(customCartId)"
                home.mCustomerId = mCustomerId
                home.mOrderType = "custom_order"
                home.mProductIds = "\(productId)"
                home.delegate = self
                home.transitioningDelegate = self
                self.present(home, animated: true)
            }
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        let mParams = [ "customer_id":mCustomerId ,"custom_data": mCartData] as [String : Any]
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        mQuoteButton.setTitle("QUOTE".localizedString, for: .normal)
        mCheckOutButton.setTitle("CHECK OUT".localizedString, for: .normal)
        mBottomQuotationLABEL.text = "Quotation".localizedString
        mBottomCatalogLABEL.text = "Catalog".localizedString
        mBottomInventoryLABEL.text = "Inventory".localizedString
        mBottomCustomerLABEL.text = "Customer".localizedString
        
        
        mHeadingLABEL.text = "Create your own".localizedString
        mNoteLABEL.text = "Note".localizedString
        mGrandTotalLABEL.text = "Grand Total".localizedString
        mDepositeLABEL.text = "Deposit".localizedString
        mOutstandingBalance.text = "Outstanding Balance".localizedString
        
        mTotalItems.text = "0 " + "Item".localizedString
        mSearchField.placeholder = "Search by SKU / Stock ID".localizedString
        mNotes.placeholder = "EX. Urgent Order".localizedString
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        
        mGrandTotal.text = "\(UserDefaults.standard.value(forKey: "currencySymbol") ?? "$") 0.00"
        mDepositAmount.text = mGrandTotal.text
        mOutstandingAmount.text = mGrandTotal.text
        
        mGetData(url: mFetchPaymentMethod,headers: sGisHeaders,  params: ["":""]) { response , status in
            if status {
                if let mData = response.value(forKey: "data") as? NSDictionary {
                    
                    //Store Cash Data
                    if let mCashData = mData.value(forKey: "Cash") as? NSArray {
                        if mCashData.count > 0 {
                            if let mData = mCashData[0] as? NSDictionary {
                                UserDefaults.standard.set(mData, forKey: "CASHDATA")
                            }
                        }
                    }
                    
                    //Store Credit Card Data
                    if let mCreditCard = mData.value(forKey: "Credit_Card") as? NSArray {
                        if mCreditCard.count > 0 {
                            UserDefaults.standard.set(mCreditCard, forKey: "CREDITCARDDATA")
                        }else{UserDefaults.standard.set(nil, forKey: "CREDITCARDDATA")}
                    }else{UserDefaults.standard.set(nil, forKey: "CREDITCARDDATA")}
                    
                    //Store Bank Data
                    if let mBankData = mData.value(forKey: "Bank") as? NSArray {
                        if mBankData.count > 0 {
                            UserDefaults.standard.set(mBankData, forKey: "BANKDATA")
                        }else{UserDefaults.standard.set(nil, forKey: "BANKDATA")}
                    }else{UserDefaults.standard.set(nil, forKey: "BANKDATA")}
                    
                    
                }
            }
        }
        
        
        if UserDefaults.standard.string(forKey: "cRemark") != nil {
            self.mNotes.text = "\(UserDefaults.standard.string(forKey: "cRemark") ?? "")"
        }
        if mCustomerId == "" {
            mOpenCustomerSheet()
        } else {
            self.mCheckAddresse()
        }
        
        let mParams = ["query":"{stones{id name}colors{id name}metals{id name}shapes{id name}claritys{id name}cuts{id name}sizes{id name}settingType{id name}stonecolors{id name}}"]
        AF.request(mGrapQlUrl, method:.post,parameters: mParams, encoding:JSONEncoding.default, headers: sGisHeaders).responseJSON
        { response in
            if(response.error != nil) {
                UserDefaults.standard.set(nil, forKey: "GRAPHQL")
                
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
                
                UserDefaults.standard.set(jsonResult, forKey: "GRAPHQL")
            }
        }
        
        
        AF.request(mGetShapes, method:.post,parameters: nil, headers: sGisHeaders).responseJSON
        { response in
            if(response.error != nil) {
                UserDefaults.standard.set(nil, forKey: "SHAPES")
                
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
                
                UserDefaults.standard.set(jsonResult, forKey: "SHAPES")
            }
        }
        
        mCustomerId  = UserDefaults.standard.string( forKey: "DEFAULTCUSTOMER") ?? ""
        if !mCustomerId.isEmpty {
            self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
            mFetchCartItems()
        }
        
        let isQuotation = UserDefaults.standard.bool(forKey: "isQuotation")
        self.mQuotationView.isHidden = !isQuotation
        self.mQuoteButton.isHidden = !isQuotation
        
        if isQuotation {
            mFetchQuote()
        }
    }
    
  func mFetchQuote(){
      
      
        mGetData(url: mGetAllQuotations,headers: sGisHeaders,  params: ["customer_id":self.mCustomerId]) { response , status in
             if status {
                if let mData = response.value(forKey: "data") as? NSArray {
                    if mData.count > 0 {
                        self.mQuotationCount.text = "\(mData.count)"
                    }else{
                        self.mQuotationCount.text = "\(mData.count)"
                    }
                    
                }
                
                
            }
        }
    }
    
    @IBAction func mSearchCart(_ sender: Any) {
    }
    
    
    @IBAction func mOpenCustomer(_ sender: Any) {
      
         mOpenCustomerSheet()
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
    
    @IBAction func mBack(_ sender: Any) {
        UserDefaults.standard.setValue(nil, forKey: "cRemark")

        self.navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }

    
    func mGetQuotationData(status:Bool, quotationId: String) {
        self.isQuotation = status
        self.mQuotationId = quotationId
        mFetchCartItems()
    }
    
    @IBAction func mShowQuotation(_ sender: Any) {
     
        let storyBoard: UIStoryboard = UIStoryboard(name: "quotation", bundle: nil)
        if let mCommonQuotations = storyBoard.instantiateViewController(withIdentifier: "CommonQuotations") as? CommonQuotations {
            mCommonQuotations.delegate = self
            mCommonQuotations.mCustomerId = mCustomerId
            mCommonQuotations.modalPresentationStyle = .overFullScreen
            mCommonQuotations.transitioningDelegate = self
            self.present(mCommonQuotations,animated: true)
        }
    }
    @IBAction func mCatalog(_ sender: Any) {
        self.isQuotation = false

        if mCustomerId == "" {
            CommonClass.showSnackBar(message: "Please choose customer first!")
            mOpenCustomerSheet()
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let mCommonCatalog = storyBoard.instantiateViewController(withIdentifier: "CommonCatalog") as? CommonCatalog {
            mCommonCatalog.delegate =  self
            mCommonCatalog.mCustomerId = mCustomerId
            mCommonCatalog.mOrderType = "custom_order"
            self.navigationController?.pushViewController(mCommonCatalog , animated: true)
        }
    }
    
    func mGetInventoryItems(items: [String]) {
        
        self.isQuotation = false
        mFetchCartItems()
    }
    
    
  
    func mFetchCartItems(){
        
        var mParams = [String:Any]()
        if isQuotation {
            mParams = ["quatation_id":self.mQuotationId] as [String : Any]
        }else{
            mParams = [ "customer_id":mCustomerId ,"custom_data": mCartData] as [String : Any]

        }
        
        mGetData(url: mFetchCustomProduct, headers: sGisHeaders, params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
            if "\(response.value(forKey: "code") ?? "")" == "200" {
                if let mData = response.value(forKey: "data") as? NSArray {
                    
                    self.isQuotation = false
                    if mData.count > 0 {
                        self.mCartDataMaster = mData
                        self.mCartData = NSMutableArray(array: mData)
                        self.mCartTable.delegate = self
                        self.mCartTable.dataSource = self
                        self.mQuantityData = [Int]()
                        self.mCartAmount = [Double]()
                        self.mCartTable.reloadData()
                        for i in self.mCartData {
                            if let mData = i as? NSDictionary,
                               let qty = mData.value(forKey: "Qty"),
                               let price = mData.value(forKey: "price") {
                                self.mQuantityData.append(Int("\(qty)") ?? 0)
                                self.mCartAmount.append(Double("\(price)") ?? 0.0)
                            }
                        }
                    }else{
                        UserDefaults.standard.setValue(nil, forKey: "cRemark")
                        self.mNotes.text = ""
                    }
                }
            
            }else{
          
            }
        }
    }
    }
    func uniqueElementsFrom(array:[String]) -> [String] {
        
        var set = Set<String>()
        
        let result = array.filter {
            guard !set.contains($0)  else {
                
                
                return  false
            }
            set.insert($0)
            return true
        }
        
        return result
    }

    @IBAction func mInventory(_ sender: Any) {
        self.isQuotation = false

        if mCustomerId == "" {
            CommonClass.showSnackBar(message: "Please choose customer first!")
            mOpenCustomerSheet()
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let mInv = storyBoard.instantiateViewController(withIdentifier: "CommonInventory") as? CommonInventory {
            mInv.modalPresentationStyle = .overFullScreen
            mInv.mOrderType = "custom_order"
            mInv.delegate =  self
            mInv.mCustomerId = mCustomerId
            mInv.transitioningDelegate = self
            self.present(mInv,animated: true)
        }
    }
    
    @IBAction func mCustomer(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerSearch") as? CustomerSearch {
            self.navigationController?.pushViewController(home, animated:true)
        }
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
        if let customerId = data.value(forKey: "id") as? String,
           let customerName = data.value(forKey: "name") as? String {
            UserDefaults.standard.set(customerId, forKey: "DEFAULTCUSTOMER")
            UserDefaults.standard.set(data.value(forKey: "profile") ?? "", forKey: "DEFAULTCUSTOMERPICTURE")
            UserDefaults.standard.set(customerName, forKey: "DEFAULTCUSTOMERNAME")
            
            self.mCustomerId = customerId
            self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
            self.isQuotation = false
            
            UserDefaults.standard.setValue(nil, forKey: "CustomerBillingAddressUDID")
            UserDefaults.standard.setValue(nil, forKey: "CustomerShippingAddressUDID")
            
            if let haveAddresses = data.value(forKey: "haveAddresses") as? Bool {
                mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
                mAddressPickerAlertIcon.isHidden = haveAddresses
            } else {
                mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
                mAddressPickerAlertIcon.isHidden = false
            }
            
            mFetchCartItems()
            
            if UserDefaults.standard.bool(forKey: "isQuotation") {
                mFetchQuote()
            }
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
    
    @IBAction func mDepositeDropdown(_ sender: Any) {
        let dropdown = DropDown()
        dropdown.anchorView = self.mDepositePercent
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y: self.mDepositePercent.frame.size.height)
        dropdown.width = 120
        dropdown.dataSource = mDepositPercentData
        dropdown.selectionAction = {
            [unowned self](index:Int, item: String) in
            self.mDepositePercent.text  = item
            self.mDepositPercents = self.mDepositPercentValue[index]
            if self.mCartData.count > 0{
                self.calculateItemsWithAmount()
            }
            
        }
        dropdown.show()
    }
    
    
    @IBAction func mQuoteItems(_ sender: Any) {
        if mCartData.count == 0 {
            CommonClass.showSnackBar(message: "Please add items to cart!")
            return
        }
        mConfirmQuote.frame = self.view.bounds
        mConfirmQuote.delegate = self
        mConfirmQuote.mNotes.text = ""
        mConfirmQuote.mNotes.placeholder = "Ex : Hold order".localizedString
        mConfirmQuote.mHeadingLabel.text = "Add Note".localizedString
        mConfirmQuote.mSubHeading.text = "Note for the order you want a quotation".localizedString
        mConfirmQuote.mDueDateLABEL.text = "Due Date".localizedString
        mConfirmQuote.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
        mConfirmQuote.mCreateQuote.setTitle("CREATE A QUOTE".localizedString, for: .normal)
        mConfirmQuote.mNewDate = Date.getCurrentDateGMT()
        mConfirmQuote.mCurrentDate.text = Date.getCurrentDate()
        self.view.addSubview(mConfirmQuote)
    }
    
    
    func mConfirmPayment(date: String, dateInGMT : Date, receiveAmount: String, outstanding: String, noOfReceived: String) {
       
            let mSummaryOrder = NSMutableDictionary()
            let mSellInfo = NSMutableDictionary()
            let mCustomerData = NSMutableDictionary()
            mCustomerData.setValue(self.mCustomerId, forKey: "id")
            mCustomerData.setValue(UserDefaults.standard.string(forKey:"DEFAULTCUSTOMERNAME") ?? "User", forKey: "name")
            mSummaryOrder.setValue(0, forKey: "labour")
            mSummaryOrder.setValue(0, forKey: "shipping")
            mSummaryOrder.setValue(0, forKey: "loyalty_points")
            mSummaryOrder.setValue(0, forKey: "tax_amount")
            mSummaryOrder.setValue(0, forKey: "tax_amount_int")
            mSummaryOrder.setValue(0, forKey: "tax_prect")
            mSummaryOrder.setValue("", forKey: "tax_type")
            mSummaryOrder.setValue(0, forKey: "discount")
            mSummaryOrder.setValue(0, forKey: "discount_percent")
            mSummaryOrder.setValue(mCustomerData, forKey: "customer_id")
            mSummaryOrder.setValue("", forKey: "sales_person_id")
            mSummaryOrder.setValue(Double(mDepositPercents) ?? 0.00, forKey: "deposit")
            mSummaryOrder.setValue(Double(self.mGrandTotalAmounts) ?? 0.00, forKey: "deposit_amount")
            mSummaryOrder.setValue(Double(self.mGrandTotalAmounts) ?? 0.00, forKey: "Sub_Total")
        
            mSellInfo.setValue(self.mCartData, forKey: "cart")
            mSellInfo.setValue(mSummaryOrder, forKey: "summary_order")
            mSellInfo.setValue("custom_order", forKey: "status_type")
            mSellInfo.setValue(Double(self.mGrandTotalAmounts) ?? 0.00, forKey: "totalamount")
        let  mFinalData = ["sell_info": mSellInfo, "totalamount":self.mGrandTotalAmounts,
                           "order_type":"custom_order",
                           "quatetime": noOfReceived ?? "Customer is interested but wants to hold for now",
                           
                           "duedate":date] as [String : Any]
        CommonClass.showFullLoader(view: self.view)
        
            mGetData(url: mSaveQuotation,headers: sGisHeaders,  params: mFinalData) { response , status in
                if status {
                    CommonClass.stopLoader()
                    CommonClass.showSnackBar(message: "Quotation Added Successfully")
                    self.mFetchQuote()
                    self.mCartDataMaster = NSArray()
                    self.mCartData = NSMutableArray()
                    self.mQuantityData = [Int]()
                    self.mCartAmount = [Double]()
                    self.mCartTable.reloadData()
                    self.calculateItemsWithAmount()
                    
                }
        }
        
    }
    func mGetDatePicker() {
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
            let mDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePick))
            let mSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let mCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(mCancelPick))
            mToolBar.setItems([mCancel, mSpace,mDone], animated: false)
        
        mConfirmQuote.mDueDate.inputAccessoryView = mToolBar
        mConfirmQuote.mDueDate.inputView = mDatePicker
        mConfirmQuote.mDueDate.becomeFirstResponder()
 }
    @objc
    func donePick(){
             let mDayd = DateFormatter()
                 mDayd.dateFormat = "dd"
             
             let mMonthm = DateFormatter()
                 mMonthm.dateFormat = "MM"
                   
             let mYeard = DateFormatter()
                 mYeard.dateFormat = "yyyy"
                 
        mConfirmQuote.mCurrentDate.text  = "\(mDayd.string(from: mDatePicker.date))/" +  "\(mMonthm.string(from: mDatePicker.date))/"+"\(mYeard.string(from: mDatePicker.date))"
        mConfirmQuote.mNewDate = mDatePicker.date
       
           self.view.endEditing(true)
        
                 
         }
         @objc func mCancelPick(){
             self.view.endEditing(true)
         }
    
    
    
    @IBAction func mCheckOut(_ sender: UIButton) {
        sender.showAnimation{ [self] in
            
            if self.mCartData.count == 0 {
                CommonClass.showSnackBar(message: "No items in cart!")
                return
            }
            if Double(self.mGrandTotalCart) ?? 0.00 == 0.0 {
                CommonClass.showSnackBar(message: "Please fill valid amount!")
                return
            }
            
            guard self.mAddressPickerAlertIcon.isHidden else {
                CommonClass.showSnackBar(message: "Add Billing and Shipping address")
                return
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "customOrder", bundle: nil)
            if let mCheckOut = storyBoard.instantiateViewController(withIdentifier: "CustomOrderCheckout") as? CustomOrderCheckout {
                mCheckOut.mTotalP = self.mTotalDepositAmounts
                mCheckOut.mSubTotalP = ""
                mCheckOut.mTaxP = ""
                mCheckOut.mTaxAm = ""
                mCheckOut.mStoreCurrency =  self.mCurrency
                mCheckOut.mOrderType = "custom_order"
                mCheckOut.mRemark = self.mNotes.text ?? ""
                mCheckOut.mTaxType =  ""
                mCheckOut.mTaxLabel =  ""
                mCheckOut.mLabourPoints = Int(self.mServiceAmounts.reduce(0, {$0 + $1}))
                mCheckOut.mTotalOutstandingAm = self.mOutStandingAmounts
                mCheckOut.mCurrencySymbol = self.mCurrency
                mCheckOut.mCartTotalAmount = self.mGrandTotalCart
                mCheckOut.mDepositPercents = self.mDepositPercents
                mCheckOut.mTotalWithDiscount =  self.mTotalDepositAmounts
                mCheckOut.mTaxPercent =  ""
                mCheckOut.mCustomerId = self.mCustomerId
                mCheckOut.mCartTableData =  self.mCartData
                self.navigationController?.pushViewController( mCheckOut, animated:true)
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCartData.count
        if mCartData.count == 0 {
            tableView.setError("No items found!")
        }else{
            tableView.clearBackground()
        }
       return mCartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCartItems") as? CustomCartItems else {
            return UITableViewCell()
        }
        
        cell.mSNo.text = "\(indexPath.row + 1)"
        cell.mOpenProductDetailsButton.tag = indexPath.row
        cell.mRemoveButton.tag = indexPath.row
        cell.mRemarks.tag = indexPath.row
        cell.mProductPrice.tag = indexPath.row
        cell.mPlusButton.tag = indexPath.row
        cell.mMinusButton.tag = indexPath.row
        cell.mChooseDateButton.tag = indexPath.row
        cell.mDesignButton.tag = indexPath.row
        cell.mEditServiceLabourButton.tag = indexPath.row
        cell.mShowServiceLabourButton.tag = indexPath.row
        
        guard let mData = mCartData[indexPath.row] as? NSDictionary else {
            return cell
        }
        
        let isServiceLabour = UserDefaults.standard.bool(forKey: "isServiceLabour")
        if isServiceLabour {
            if let mServiceLabourStatus =  mData.value(forKey: "Service_labour_exsist") as? Bool {
                mServiceLabourStatus ? (cell.mEditServiceLabourIcon.tintColor = UIColor(named:"themeColor")) : (cell.mEditServiceLabourIcon.tintColor = UIColor(named:"theme6A"))
                
                cell.mServiceLabourView.isHidden = false
                
                if mServiceLabourStatus {
                    if let mServiceLabour = mData.value(forKey: "Service_labour") as? NSDictionary {
                        if let mServiceItem = mServiceLabour.value(forKey: "service_laburelist") as? NSArray {
                            if mServiceItem.count > 0 {
                                cell.mServiceLabourCount.text = "Service Labour".localizedString + " (\(mServiceItem.count))"
                                var mAmounts = [Double]()
                                for i in mServiceItem {
                                    if let items = i as? NSDictionary,
                                       let serviceAmount = items.value(forKey: "scrviceamount") {
                                        let unFormatedAmount = "\(serviceAmount)".replacingOccurrences(of: ",", with: "")
                                        mAmounts.append(Double(unFormatedAmount) ?? 0.00)
                                    }
                                }
                                cell.mServiceLabourCharges.text = self.mCurrency + " " + String(format:"%.02f",locale:Locale.current,mAmounts.reduce(0, {$0 + $1}))
                            }else{
                                cell.mServiceLabourCharges.text = self.mCurrency + " 0.00"
                                cell.mServiceLabourCount.text = "Service Labour".localizedString + " (0)"
                            }
                        }
                    }
                    
                }else{
                    cell.mServiceLabourCharges.text = self.mCurrency + " 0.00"
                    cell.mServiceLabourCount.text = "Service Labour".localizedString + " (0)"
                }
            }else{
                cell.mServiceLabourView.isHidden = true
            }
        }else{
            cell.mServiceLabourView.isHidden = true
        }
            
        if let mCustomDesignStatus = mData.value(forKey: "Custom_design_status") as? Bool {
            if mCustomDesignStatus {
                cell.mEditIcon.image = UIImage(named: "edit_custom_green")
            }else{
                cell.mEditIcon.image = UIImage(named: "edit_custom")
            }
        }
        cell.mDueDate.text = "\(mData.value(forKey: "delivery_date") ?? "--")"
        cell.mCurrency.text = "\(mData.value(forKey: "currency") ?? "$")"
        self.mCurrency = "\(mData.value(forKey: "currency") ?? "$") "
        cell.mRemarks.keyboardType = .default
        cell.mRemarks.text = "\(mData.value(forKey: "remark") ?? "")"
        cell.mSKUName.text = "\(mData.value(forKey: "SKU") ?? "")"
        cell.mProductName.text = "\(mData.value(forKey: "name") ?? "")"
        cell.mMetalColorSize.text = "\(mData.value(forKey: "color_name") ?? "") " + "\(mData.value(forKey: "metal_name") ?? "") " + "\(mData.value(forKey: "size_name") ?? "")"
        cell.mProductPrice.text = "\(mData.value(forKey: "price") ?? "")"
        cell.mStockId.text = "\(mData.value(forKey: "stock_id") ?? "")"
        
        cell.mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "")")
        cell.mProductImage.tag = indexPath.row
        cell.imageTapGesture(target: self, action: #selector(handleImageTap(_:)))
        
        calculateItemsWithAmount()
        
        return cell
    }
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        let index = imageView.tag
        if let mData = mCartData[index] as? NSDictionary {
            let productId = "\(mData.value(forKey: "id") ?? "")"
            let sku = "\(mData.value(forKey: "SKU") ?? "")"

            mOpenGlobalImageViewer(mProductIdForImage: productId, mSKUForImage: sku)
        }
    }
    
    func mOpenGlobalImageViewer(mProductIdForImage: String , mSKUForImage: String){
        if mProductIdForImage != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
            if let mGlobalImageViewer = storyBoard.instantiateViewController(withIdentifier: "GlobalImageViewer") as? GlobalImageViewer {
                mGlobalImageViewer.modalPresentationStyle = .overFullScreen
                mGlobalImageViewer.mProductId = mProductIdForImage
                mGlobalImageViewer.mSKUName = mSKUForImage
                mGlobalImageViewer.transitioningDelegate = self
                self.present(mGlobalImageViewer,animated: false)
            }
        }
    }
    
    func mRemoveServiceLabour() {
        mFetchCartItems()
    }
    func mConfirmServiceLabour(data: NSDictionary) {
        mFetchCartItems()
    }
   
    
    @IBAction func mShowServiceLabour(_ sender: UIButton) {
        
        if let mData = self.mCartData[sender.tag] as? NSDictionary,
           let mServiceData = mData.value(forKey: "Service_labour") as? NSDictionary {
            let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
            if let mSelectedServiceLabour = storyBoard.instantiateViewController(withIdentifier: "SelectedServiceLabour") as? SelectedServiceLabour {
                mSelectedServiceLabour.modalPresentationStyle = .automatic
                mSelectedServiceLabour.mProductData = mServiceData
                mSelectedServiceLabour.transitioningDelegate = self
                self.present(mSelectedServiceLabour,animated: true)
            }
        }
        
    }
    
    @IBAction func mEditServiceLabour(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
        if let mCommonServiceLabour = storyBoard.instantiateViewController(withIdentifier: "CommonServiceLabour") as? CommonServiceLabour {
            mCommonServiceLabour.modalPresentationStyle = .overFullScreen
            mCommonServiceLabour.delegate = self
            mCommonServiceLabour.mProductData = self.mCartData[sender.tag] as? NSDictionary ?? NSDictionary()
            mCommonServiceLabour.transitioningDelegate = self
            self.present(mCommonServiceLabour,animated: true)
        }
    }
    
    func mGetSearchItems(id: String) {
 
        let mParams = ["product_id":[id], "customer_id":mCustomerId, "sales_person_id":"", "type":"catalog" , "order_type":"custom_order"] as [String : Any]
        
        mGetData(url: mAddCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
            if "\(response.value(forKey: "code") ?? "")" == "200" {
                self.mFetchCartItems()
            }else{
          
            }
        }
    }

    }
    
    @IBAction func mSearchnow(_ sender: Any) {
        
        self.isQuotation = false
        let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
        if let mCommonSearch = storyBoard.instantiateViewController(withIdentifier: "CommonSearch") as? CommonSearch {
            mCommonSearch.modalPresentationStyle = .overFullScreen
            mCommonSearch.delegate = self
            mCommonSearch.mType = "catalog"
            mCommonSearch.mFrom = "createYourOwn"
            mCommonSearch.transitioningDelegate = self
            self.present(mCommonSearch,animated: false)
        }
    }
    
    @IBAction func mMinusButton(_ sender: UIButton) {
      

        let index = sender.tag
        guard let mInvData = mCartData[index] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: index, section: 0)) as? CustomCartItems,
              let mOrgData = mCartDataMaster[index] as? NSDictionary else {
            return
        }
        
        let mMinQty = 1
        var mCurrentQty = Int(cells.mQuantityUnit.text ?? "0") ?? 0
        
        if  mCurrentQty == mMinQty {

        }else{
            mCurrentQty = mCurrentQty - 1
            if mCurrentQty == 1 {
                cells.mQuantityUnit.text = "\(mMinQty)"
                cells.mProductPrice.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) - (self.mCartAmount[sender.tag]))"
            }else{
                cells.mQuantityUnit.text = "\(mCurrentQty)"
                cells.mProductPrice.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) - (self.mCartAmount[sender.tag]))"
            }
        }
        
        var mData = NSMutableDictionary()
        mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
        mData.setValue("\(cells.mQuantityUnit.text ?? "0")", forKey: "Qty")
        mData.setValue("\(mInvData.value(forKey: "type") ?? "")", forKey: "type")
        mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "SKU")
        mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "1")", forKey: "po_QTY")
        mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stock_id")
        mData.setValue("\(cells.mProductPrice.text ?? "")", forKey: "price")
        mData.setValue("\(mInvData.value(forKey: "name") ?? "")", forKey: "name")
        mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "main_image")
        mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size_name")
        mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal_name")
        mData.setValue("\(mInvData.value(forKey: "stone_name") ?? "")", forKey: "stone_name")
        mData.setValue("\(mInvData.value(forKey: "collection_name") ?? "")", forKey: "collection_name")
        mData.setValue("\(mInvData.value(forKey: "location_name") ?? "")", forKey: "location_name")
        mData.setValue("\(mInvData.value(forKey: "custom_cart_id") ?? "")", forKey: "custom_cart_id")
         mData.setValue("\(mInvData.value(forKey: "remark") ?? "")", forKey: "remark")
        mData.setValue("\(mInvData.value(forKey: "currency") ?? "")", forKey: "currency")
        mData.setValue("\(mInvData.value(forKey: "delivery_date") ?? "")", forKey: "delivery_date")
        mData.setValue(mInvData.value(forKey: "Custom_design_status") ?? false, forKey: "Custom_design_status")
        
        if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            if mServiceLabourStatus {
                mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
            if let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                mData.setValue(mServiceLabour, forKey: "Service_labour")
            }
            }else{
                mData.setValue(false, forKey: "Service_labour_exsist")
            }
         }
        
        mCartData.removeObject(at: index)
        mCartData.insert(mData, at: index)
        mCartTable.reloadData()
        calculateItemsWithAmount()

    }
    
    
    @IBAction func mPlusButton(_ sender: UIButton) {
        let index = sender.tag
        
        guard let mOrgData = mCartDataMaster[sender.tag] as? NSDictionary,
              let mInvData = mCartData[index] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems else {
            return
        }
        let mMaxQty =  Int("\(mInvData.value(forKey: "po_QTY") ?? "1")") ?? 1
        var mCurrentQty = Int(cells.mQuantityUnit.text ?? "") ?? 0
        if mCurrentQty == mMaxQty {
            return
        }
        mCurrentQty = mCurrentQty + 1
        cells.mQuantityUnit.text = "\(mCurrentQty)"
        
        cells.mProductPrice.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) + (self.mCartAmount[sender.tag] ?? 0.0) )"

        var mData = NSMutableDictionary()
        mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
        mData.setValue("\(mInvData.value(forKey: "type") ?? "")", forKey: "type")
        mData.setValue("\(cells.mQuantityUnit.text ?? "")", forKey: "Qty")
        mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "SKU")
        mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "1")", forKey: "po_QTY")
        mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stock_id")
        mData.setValue("\(cells.mProductPrice.text ?? "")", forKey: "price")
        mData.setValue("\(mInvData.value(forKey: "name") ?? "")", forKey: "name")
        mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "main_image")
        mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size_name")
        mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal_name")
        mData.setValue("\(mInvData.value(forKey: "stone_name") ?? "")", forKey: "stone_name")
        mData.setValue("\(mInvData.value(forKey: "collection_name") ?? "")", forKey: "collection_name")
        mData.setValue("\(mInvData.value(forKey: "location_name") ?? "")", forKey: "location_name")
        mData.setValue("\(mInvData.value(forKey: "custom_cart_id") ?? "")", forKey: "custom_cart_id")
        mData.setValue("\(mInvData.value(forKey: "remark") ?? "")", forKey: "remark")

        mData.setValue("\(mInvData.value(forKey: "currency") ?? "")", forKey: "currency")
        mData.setValue("\(mInvData.value(forKey: "delivery_date") ?? "")", forKey: "delivery_date")
        mData.setValue(mInvData.value(forKey: "Custom_design_status") ?? false, forKey: "Custom_design_status")
        
        if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            if mServiceLabourStatus {
                mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
            if let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                mData.setValue(mServiceLabour, forKey: "Service_labour")
            }
            }else{
                mData.setValue(false, forKey: "Service_labour_exsist")
            }
         }
        
        mCartData.removeObject(at: index)
        mCartData.insert(mData, at: index)
        mCartTable.reloadData()
        calculateItemsWithAmount()
    }
    
    
    
     

    @IBAction func mChooseDate(_ sender: UIButton) {
        guard let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems else {
            return
        }

        mCurrentIndex = sender.tag
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
        mToolBar.setItems([mCancel, mSpace,mDone], animated: false)
        cells.mDueDate.inputAccessoryView = mToolBar
        cells.mDueDate.inputView = mDatePicker
        cells.mDueDate.becomeFirstResponder()

    }
    
    @objc
    func doneDatePick(){
        let mDayd = DateFormatter()
        mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        guard let cell1 = mCartTable.cellForRow(at: IndexPath(row: mCurrentIndex, section: 0)) as? CustomCartItems else {
            return
        }
        cell1.mDueDate.text  = "\(mMonthm.string(from: mDatePicker.date))/" +  "\(mDayd.string(from: mDatePicker.date))/"+"\(mYeard.string(from: mDatePicker.date))"
        guard let mInvData = mCartData[mCurrentIndex] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: mCurrentIndex , section: 0)) as? CustomCartItems else {
            return
        }
        
        var mData = NSMutableDictionary()
        mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
        mData.setValue("\(mInvData.value(forKey: "type") ?? "")", forKey: "type")
        mData.setValue("\(mInvData.value(forKey: "Qty") ?? "")", forKey: "Qty")
        mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "SKU")
        mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "1")", forKey: "po_QTY")
        mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stock_id")
        mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
        mData.setValue("\(mInvData.value(forKey: "name") ?? "")", forKey: "name")
        mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "main_image")
        mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size_name")
        mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal_name")
        mData.setValue("\(mInvData.value(forKey: "stone_name") ?? "")", forKey: "stone_name")
        mData.setValue("\(mInvData.value(forKey: "collection_name") ?? "")", forKey: "collection_name")
        mData.setValue("\(mInvData.value(forKey: "location_name") ?? "")", forKey: "location_name")
        mData.setValue("\(mInvData.value(forKey: "custom_cart_id") ?? "")", forKey: "custom_cart_id")
        mData.setValue("\(mInvData.value(forKey: "remark") ?? "")", forKey: "remark")
        mData.setValue("\(mInvData.value(forKey: "currency") ?? "")", forKey: "currency")
        mData.setValue("\(cells.mDueDate.text ?? "")", forKey: "delivery_date")
        mData.setValue(mInvData.value(forKey: "Custom_design_status") ?? false, forKey: "Custom_design_status")
        
        if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            if mServiceLabourStatus {
                mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                if let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                    mData.setValue(mServiceLabour, forKey: "Service_labour")
                }
            }else{
                mData.setValue(false, forKey: "Service_labour_exsist")
            }
        }
        mCartData.removeObject(at: mCurrentIndex)
        mCartData.insert(mData, at: mCurrentIndex)
        
        self.view.endEditing(true)
        
    }
    
    @objc func mCancelDatePick(){
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let mData = mCartData[indexPath.row] as? NSDictionary else {
                return
            }
            
            CommonClass.showFullLoader(view: self.view)
            let mParams = [ "customer_id":mCustomerId , "custom_cart_id":mData.value(forKey: "custom_cart_id") as? String ?? ""] as [String : Any]
            
            mGetData(url: mDeleteCartItem,headers: sGisHeaders,  params: mParams) { response , status in
                CommonClass.stopLoader()
                if status {
                    if "\(response.value(forKey: "code") ?? "")" == "200" {
                        CommonClass.stopLoader()
                        self.mDeleteRow(index: indexPath.row)
                    }else{
                        
                    }
                }
            }
            
            
        }
    }
    
    func mDeleteRow(index : Int) {
        self.mCartData.removeObject(at: index)
        self.mCartTable.reloadData()
        calculateItemsWithAmount()
    }

    func mDeleteCartItems(index: Int) {
        self.mCartData.removeObject(at: index)
        self.mCartTable.reloadData()
        calculateItemsWithAmount()
    }
    
    @IBAction func mRemoveCartItems(_ sender: UIButton) {
        
        guard let mData = mCartData[sender.tag] as? NSDictionary else {
            return
        }
        
        mRemovePopUp.frame = self.view.bounds
        mRemovePopUp.mCustomerId = mCustomerId
        mRemovePopUp.delegate = self
        mRemovePopUp.index = sender.tag
        mRemovePopUp.mType = ""
        mRemovePopUp.mCartId = mData.value(forKey: "custom_cart_id") as? String ?? ""
        mRemovePopUp.mMessage.text = "Are you sure want to remove ?".localizedString
        mRemovePopUp.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
        mRemovePopUp.mConfirmButton.setTitle("CONFIRM".localizedString, for: .normal)
        self.view.addSubview(mRemovePopUp)
    }

    @IBAction func mEditAmount(_ sender: UITextField) {
        
        guard let mInvData = mCartData[sender.tag] as? NSDictionary,
              let mOrgData = mCartDataMaster[sender.tag] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems else {
            return
        }
        
        cells.mQuantityUnit.text = "1"
        if sender.text == "" || sender.text == "0" {
            cells.mProductPrice.text = ""
            
            var mData = NSMutableDictionary()
            
            mData.setValue("0", forKey: "price")
            self.mCartAmount.remove(at: sender.tag)
            self.mCartAmount.insert(0.0, at: sender.tag)
            mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
            mData.setValue("\(mInvData.value(forKey: "type") ?? "")", forKey: "type")
            mData.setValue("\(mInvData.value(forKey: "Qty") ?? "")", forKey: "Qty")
            mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "SKU")
            mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "1")", forKey: "po_QTY")
            mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stock_id")
            mData.setValue("\(mInvData.value(forKey: "name") ?? "")", forKey: "name")
            mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "main_image")
            mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size_name")
            mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal_name")
            mData.setValue("\(mInvData.value(forKey: "stone_name") ?? "")", forKey: "stone_name")
            mData.setValue("\(mInvData.value(forKey: "collection_name") ?? "")", forKey: "collection_name")
            mData.setValue("\(mInvData.value(forKey: "location_name") ?? "")", forKey: "location_name")
            mData.setValue("\(mInvData.value(forKey: "custom_cart_id") ?? "")", forKey: "custom_cart_id")
            mData.setValue("\(mInvData.value(forKey: "remark") ?? "")", forKey: "remark")
            mData.setValue("\(mInvData.value(forKey: "currency") ?? "")", forKey: "currency")
            mData.setValue("\(mInvData.value(forKey: "delivery_date") ?? "")", forKey: "delivery_date")
            mData.setValue(mInvData.value(forKey: "Custom_design_status") ?? false, forKey: "Custom_design_status")
            
            if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                if mServiceLabourStatus {
                    mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                    if let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                        mData.setValue(mServiceLabour, forKey: "Service_labour")
                    }
                }else{
                    mData.setValue(false, forKey: "Service_labour_exsist")
                }
            }
            mCartData.removeObject(at: sender.tag)
            mCartData.insert(mData, at: sender.tag)
            calculateItemsWithAmount()
            return
        }
        
        
        let mData = NSMutableDictionary()
        self.mCartAmount.remove(at: sender.tag)
        self.mCartAmount.insert(Double("\(cells.mProductPrice.text ?? "")") ?? 0.0, at: sender.tag)
        mData.setValue(cells.mProductPrice.text ?? "", forKey: "price")
        mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
        mData.setValue("\(mInvData.value(forKey: "type") ?? "")", forKey: "type")
        mData.setValue("\(mInvData.value(forKey: "Qty") ?? "")", forKey: "Qty")
        mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "SKU")
        mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "1")", forKey: "po_QTY")
        mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stock_id")
        mData.setValue("\(mInvData.value(forKey: "name") ?? "")", forKey: "name")
        mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "main_image")
        mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size_name")
        mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal_name")
        mData.setValue("\(mInvData.value(forKey: "stone_name") ?? "")", forKey: "stone_name")
        mData.setValue("\(mInvData.value(forKey: "collection_name") ?? "")", forKey: "collection_name")
        mData.setValue("\(mInvData.value(forKey: "location_name") ?? "")", forKey: "location_name")
        mData.setValue("\(mInvData.value(forKey: "custom_cart_id") ?? "")", forKey: "custom_cart_id")
        mData.setValue("\(mInvData.value(forKey: "remark") ?? "")", forKey: "remark")
        mData.setValue("\(mInvData.value(forKey: "currency") ?? "")", forKey: "currency")
        mData.setValue("\(mInvData.value(forKey: "delivery_date") ?? "")", forKey: "delivery_date")
        mData.setValue(mInvData.value(forKey: "Custom_design_status") ?? false, forKey: "Custom_design_status")
        
        if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            if mServiceLabourStatus {
                mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                if let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                    mData.setValue(mServiceLabour, forKey: "Service_labour")
                }
            }else{
                mData.setValue(false, forKey: "Service_labour_exsist")
            }
        }
        mCartData.removeObject(at: sender.tag)
        mCartData.insert(mData, at: sender.tag)
        calculateItemsWithAmount()
        
    }
    
    @IBAction func mEditremarks(_ sender: UITextField) {
        
        guard let mInvData = mCartData[sender.tag] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems else {
            return
        }
        
        let mData = NSMutableDictionary()
        mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
        mData.setValue("\(mInvData.value(forKey: "type") ?? "")", forKey: "type")
        mData.setValue("\(mInvData.value(forKey: "Qty") ?? "")", forKey: "Qty")
        mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "SKU")
        mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "1")", forKey: "po_QTY")
        mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stock_id")
        mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
        mData.setValue("\(mInvData.value(forKey: "name") ?? "")", forKey: "name")
        mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "main_image")
        mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size_name")
        mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal_name")
        mData.setValue("\(mInvData.value(forKey: "stone_name") ?? "")", forKey: "stone_name")
        mData.setValue("\(mInvData.value(forKey: "collection_name") ?? "")", forKey: "collection_name")
        mData.setValue("\(mInvData.value(forKey: "location_name") ?? "")", forKey: "location_name")
        mData.setValue("\(mInvData.value(forKey: "custom_cart_id") ?? "")", forKey: "custom_cart_id")
        mData.setValue(cells.mRemarks.text ?? "", forKey: "remark")
        mData.setValue("\(mInvData.value(forKey: "currency") ?? "")", forKey: "currency")
        mData.setValue("\(mInvData.value(forKey: "delivery_date") ?? "")", forKey: "delivery_date")
        mData.setValue(mInvData.value(forKey: "Custom_design_status") ?? false, forKey: "Custom_design_status")
        
        if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            if mServiceLabourStatus {
                mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                if let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                    mData.setValue(mServiceLabour, forKey: "Service_labour")
                }
            }else{
                mData.setValue(false, forKey: "Service_labour_exsist")
            }
        }
        mCartData.removeObject(at: sender.tag)
        mCartData.insert(mData, at: sender.tag)
        
    }
   
    @IBAction func mOpenDesign(_ sender: UIButton) {
        
        self.isQuotation = false
        UserDefaults.standard.setValue("\(mNotes.text ?? "")", forKey: "cRemark")
        let storyBoard: UIStoryboard = UIStoryboard(name: "customOrder", bundle: nil)
        if #available(iOS 14.0, *) {
            let mIndex = sender.tag
            guard let mData = mCartData[mIndex] as? NSDictionary,
                  let mCustomDesign = storyBoard.instantiateViewController(withIdentifier: "CustomDesign") as? CustomDesign else {
                return
            }
            
            mCustomDesign.mData = mData
            mCustomDesign.mCustomerId = self.mCustomerId
            
            if let mCustomDesignStatus = mData.value(forKey: "Custom_design_status") as? Bool {
                if mCustomDesignStatus {
                    mCustomDesign.mStatus = "1"
                }else{
                    mCustomDesign.mStatus = "0"
                }
            }
            self.navigationController?.pushViewController(mCustomDesign, animated:true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func calculateItemsWithAmount(){
        var mAmounts = [Double]()
        var mQuantities = [Int]()
        mServiceAmounts = [Double]()
        
        for i in mCartData {
            if let mData = i as? NSDictionary {
                mQuantities.append(Int("\(mData.value(forKey: "Qty") ?? "0")") ?? 0 )
                mAmounts.append(Double("\(mData.value(forKey: "price") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00)
                
                if let mServiceLabourStatus =  mData.value(forKey: "Service_labour_exsist") as? Bool {
                    
                    if mServiceLabourStatus {
                        if let mServiceLabour = mData.value(forKey: "Service_labour") as? NSDictionary {
                            if let mServiceItem = mServiceLabour.value(forKey: "service_laburelist") as? NSArray {
                                if mServiceItem.count > 0 {
                                    var mAmounts = [Double]()
                                    for i in mServiceItem {
                                        if let items = i as? NSDictionary,
                                           let serviceAmount = items.value(forKey: "scrviceamount") {
                                            let serviceAmountUnformated = "\(serviceAmount)".replacingOccurrences(of: ",", with: "")
                                            mAmounts.append(Double(serviceAmountUnformated) ?? 0.00)
                                        }
                                    }
                                    
                                    mServiceAmounts.append(mAmounts.reduce(0, {$0 + $1}))
                                }else{
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        mTotalItems.text = "\(mCartData.count) " + "Items".localizedString
        mGrandTotal.text = self.mCurrency + String(format:"%.02f",locale:Locale.current,(mAmounts.reduce(0, {$0 + $1}) + mServiceAmounts.reduce(0, {$0 + $1}) ))
        
        mGrandTotalCart = "\((mAmounts.reduce(0, {$0 + $1}) + mServiceAmounts.reduce(0, {$0 + $1}) ))"
        self.mGrandTotalAmounts = "\((mAmounts.reduce(0, {$0 + $1}) + mServiceAmounts.reduce(0, {$0 + $1}) ))"
        if mDepositPercents == "100" {
            mDepositAmount.text =  mGrandTotal.text
            mOutstandingAmount.text = self.mCurrency + "0.00"
            self.mOutStandingAmounts = "0.00"
            self.mTotalDepositAmounts = self.mGrandTotalAmounts
            
        }else{
            let mTotalValue = (mAmounts.reduce(0, {$0 + $1}) + mServiceAmounts.reduce(0, {$0 + $1}))
            mDepositAmount.text = self.mCurrency + String(format:"%.02f",locale:Locale.current,calculatePercentage(value: mTotalValue, percent: Double(mDepositPercents) ?? 0.00))
            self.mTotalDepositAmounts = "\(calculatePercentage(value: mTotalValue, percent: Double(mDepositPercents) ?? 0.00))"
            let mOutstandingBal = mTotalValue - calculatePercentage(value: mTotalValue, percent: Double(mDepositPercents) ?? 0.00)
            self.mOutStandingAmounts = "\(mOutstandingBal)"
            self.mOutstandingAmount.text = self.mCurrency + String(format:"%.02f",locale:Locale.current,mOutstandingBal)
        }
        
        
        
        
    }
    
    func calculatePercentage(value:Double,percent: Double) -> Double {
        let val = value * percent
        return val/100.00
    }
    
}
