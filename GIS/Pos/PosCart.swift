//
//  PosCart.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 06/02/23.
//  Copyright © 2023 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
import DropDown


protocol GetParkItems {
    func mGetParkItems(parkId:String)
}

protocol SalesPersonTransactionDelegate {
    func mSelectedCustomer(customerId:String)
    
}


let mAddParkPopUp = UINib(nibName:"confirmpark",bundle:.main).instantiate(withOwner: nil, options: nil).first as? AddParkPopUp ?? AddParkPopUp()

class AddParkPopUp: UIView {
    var mType = ""
    var mCustomerId = ""
    var mCartId = ""
    var index = Int()
    var delegate:ProceedToPay? = nil
    @IBOutlet weak var mAddNoteLABEL: UILabel!
    
    @IBOutlet weak var mNoteForLABEL: UILabel!
    @IBOutlet weak var mMessage: UITextField!
    @IBOutlet weak var mConfirmButton: UIButton!
    @IBOutlet weak var mCancelButton: UIButton!
    
    var mNavigation = UINavigationController()
    static func instantiate(message: String) -> AddParkPopUp {
        let view: AddParkPopUp = initFromNib()
        return view
    }

    @IBAction func mCancel(_ sender: Any) {
        self.removeFromSuperview()

    }
    
    @IBAction func mConfirm(_ sender: Any) {
        self.removeFromSuperview()
        if mMessage.text != "" {
            self.delegate?.isProceedWithStatus(status: true, message: self.mMessage.text ?? "")
        }else{
            CommonClass.showSnackBar(message: "Please write a note!")
        }
    }

}

class PosCart:UIViewController, UIViewControllerTransitioningDelegate ,GetCustomerDataDelegate , UITableViewDataSource ,UITableViewDelegate, GetInventoryDataItemsDelegate , DeleteCustomCartItems , ProceedToPay,GetParkItems , SalesPersonTransactionDelegate, SearchDelegate, ServiceLabourDelegate, GetAddressDataDelegate {
    
    func isProceed(status: Bool) {
        
    }
   
    
    @IBOutlet weak var mParkCount: UILabel!
    @IBOutlet weak var mAvailableParkView: UIView!
    //TAX VIEWS
    
    
    @IBOutlet weak var mTaxView: UIView!
    @IBOutlet weak var mTaxSubTotal: UILabel!
    @IBOutlet weak var mTaxTotal: UILabel!
    
    @IBOutlet weak var mTaxAmount: UITextField!
    @IBOutlet weak var mTaxValue: UITextField!

    @IBOutlet weak var mTaxLabourCharge: UITextField!
    @IBOutlet weak var mTaxShippingCharge: UITextField!
    @IBOutlet weak var mTaxLoyaltyPoint: UITextField!

    @IBOutlet weak var mTaxDiscountPercents: UITextField!
    @IBOutlet weak var mTaxDiscountAmounts: UITextField!
    
    @IBOutlet weak var mSearchField: UITextField!

    @IBOutlet weak var mTotalItems: UILabel!
    @IBOutlet weak var mGrandTotal: UILabel!
    @IBOutlet weak var mDepositAmount: UILabel!
    @IBOutlet weak var mOutstandingAmount: UILabel!
    @IBOutlet weak var mSelectedCustomerIcon: UIImageView!
    var mCustomerId = ""
    
    @IBOutlet weak var mNotes: UITextField!
    
    @IBOutlet weak var mAddressPickerIcon: UIImageView!
    @IBOutlet weak var mAddressAlertIcon: UIImageView!
    
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


    var mQuantityData = [Int]()
    var mCartAmount = [Double]()
    var mCurrentIndex = -1
    let mDatePicker:UIDatePicker = UIDatePicker()
    var isItemsAvailable =  false
    var isDeleted = false
    @IBOutlet weak var mSalesPersonimag: UIImageView!
    @IBOutlet weak var mUpForwardIcon: UIImageView!
    
    @IBOutlet weak var mTaxAmountLABEL: UILabel!
    
    @IBOutlet weak var mTaxPercentLABEL: UILabel!
    @IBOutlet weak var mTaxSubTotalLABEL: UILabel!
    @IBOutlet weak var mDiscountAmountLABEL: UILabel!
    @IBOutlet weak var mDiscountPercentLABEL: UILabel!
    @IBOutlet weak var mTaxShippingLABEL: UILabel!
    @IBOutlet weak var mTaxLoyaltyPointLABEL: UILabel!
    
    @IBOutlet weak var mTaxLabourLABEL: UILabel!
    @IBOutlet weak var mTaxTotalLABEL: UILabel!
    @IBOutlet weak var mCheckOutBUTTON: UIButton!
   
    @IBOutlet weak var mParkBUTTON: UIButton!
    @IBOutlet weak var mHeadingLABEL: UILabel!
    
    @IBOutlet weak var mParkButtonView: UIView!
    @IBOutlet weak var mNoteLABEL: UILabel!
    
    @IBOutlet weak var mGrandTotalLABEL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mSalesPersonimag.downlaodImageFromUrl(urlString: UserDefaults.standard.string(forKey: "SALESPERSON_IMAGE") ?? "")
        self.mNotes.keyboardType = .default
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")

        self.mCartTable.delegate = self
        self.mCartTable.dataSource = self
        self.mCartTable.reloadData()
        mGrandTotal.text = "\(UserDefaults.standard.value(forKey: "currencySymbol") ?? "$") 0.00"
 
        UserDefaults.standard.setValue(nil, forKey: "CustomerBillingAddressUDID")
        UserDefaults.standard.setValue(nil, forKey: "CustomerShippingAddressUDID")
        
    }
    
    
    func mSelectedCustomer(customerId: String) {
        
    }
    
    
    
    @IBAction func mOpenSalesPerson(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "posBoard", bundle: nil)
        if let mSalesPerson = storyBoard.instantiateViewController(withIdentifier: "SalesPerson") as? SalesPerson {
            mSalesPerson.modalPresentationStyle = .overFullScreen
            mSalesPerson.delegate = self
            mSalesPerson.transitioningDelegate = self
            self.present(mSalesPerson,animated: true)
        }
    }
    func isProceedWithStatus(status: Bool, message : String) {
        if status {
            
            let mParkCarData = NSMutableArray()
        
            for i in self.mCartData {
                let mParkObjects = NSMutableDictionary()
                if let mData = i as? NSDictionary {
                    mParkObjects.setValue("\(mData.value(forKey: "Qty") ?? "" )", forKey: "Qty")
                    mParkObjects.setValue("pos_order", forKey: "type")
                    mParkObjects.setValue("\(mData.value(forKey: "retailprice_Inc") ?? "0")", forKey: "retailprice_Inc")
                    
                    mParkObjects.setValue("\(mData.value(forKey: "price") ?? "0" )", forKey: "price")
                    mParkObjects.setValue("pos_order", forKey: "order_type")
                    mParkObjects.setValue("\(mData.value(forKey: "Discount_Amount") ?? "0" )", forKey: "Discount_Amount")
                    mParkObjects.setValue("\(mData.value(forKey: "discount_percent") ?? "0" )", forKey: "discount_percent")
                    mParkObjects.setValue("\(mData.value(forKey: "custom_cart_id") ?? "" )", forKey: "custom_cart_id")
                    mParkObjects.setValue("\(mData.value(forKey: "name") ?? "" )", forKey: "name")
                    mParkObjects.setValue("\(mData.value(forKey: "main_image") ?? "" )", forKey: "main_image")
                    mParkObjects.setValue("\(mData.value(forKey: "currency") ?? "" )", forKey: "currency")
                    mParkObjects.setValue("\(mData.value(forKey: "stock_id") ?? "" )", forKey: "stock_id")
                }
                mParkCarData.add(mParkObjects)
                
            }
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
            mSummaryOrder.setValue(0, forKey: "deposit")
            mSummaryOrder.setValue(Double(self.mGrandTotalAmounts), forKey: "deposit_amount")
        
            mSellInfo.setValue(mParkCarData, forKey: "cart")
            mSellInfo.setValue(mSummaryOrder, forKey: "summary_order")
            mSellInfo.setValue("pos_order", forKey: "status_type")
            mSellInfo.setValue(Double(self.mGrandTotalAmounts), forKey: "totalamount")
            let  mFinalData = ["sell_info": mSellInfo, "totalamount":self.mGrandTotalAmounts,"order_type":"pos_order", "parktime": message] as [String : Any]
            
            
            
            mUserLoginToken = UserDefaults.standard.string(forKey: "token")
            mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
            mGetData(url: mAddToPark,headers: sGisHeaders,  params: mFinalData) { response , status in
                if status {
                    
                    self.mGetParkStatus()

                    
                }
        }
        }
    }
    
    
    @IBAction func mParkNow(_ sender: UIButton) {
        
        if mCartData.count  > 0 {
        mAddParkPopUp.frame = self.view.bounds
        mAddParkPopUp.mMessage.text = ""
            mAddParkPopUp.mMessage.placeholder = "Ex: Customer will back in 10 mins".localizedString
        mAddParkPopUp.delegate = self
            mAddParkPopUp.mAddNoteLABEL.text = "Add Note".localizedString
            mAddParkPopUp.mNoteForLABEL.text = "Not for the sale you want to park".localizedString
            mAddParkPopUp.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
            mAddParkPopUp.mConfirmButton.setTitle("PARK SALE".localizedString, for: .normal)
        self.view.addSubview(mAddParkPopUp)
    
        }else{
            CommonClass.showSnackBar(message: "No Items in Cart")
        }
        
    }
    
    func mGetParkItems(parkId: String) {
        
        if parkId != "" {
            
            let mParams = [ "park_id":parkId] as [String : Any]
            
            mUserLoginToken = UserDefaults.standard.string(forKey: "token")
            mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
            
            mGetData(url: mFetchCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
                CommonClass.stopLoader()
                if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {
                    if let mData = response.value(forKey: "data") as? NSArray, mData.count > 0 {
                        self.mCartDataMaster = mData
                        self.mCartData = NSMutableArray(array: mData)
                        self.mCartTable.delegate = self
                        self.mCartTable.dataSource = self
                        self.mQuantityData = [Int]()
                        self.mCartAmount = [Double]()
                        self.mGetParkStatus()
                        self.mCartTable.reloadData()
                        for i in self.mCartData {
                            if let mData = i as? NSDictionary {
                                self.mQuantityData.append(Int("\(mData.value(forKey: "Qty") ?? "0")") ?? 0)
                                self.mCartAmount.append(Double("\(mData.value(forKey: "price") ?? "0")") ?? 0.0)
                            }
                        }
                    }
                    
                    
                }else{
              
                }
            }
        }
        }else{
            mGetParkStatus()
        }
        
    }
    @IBAction func mViewPark(_ sender: UIButton) {
      
        let storyBoard: UIStoryboard = UIStoryboard(name: "posBoard", bundle: nil)
        if let mPOSPark = storyBoard.instantiateViewController(withIdentifier: "POSPark") as? POSPark {
            mPOSPark.modalPresentationStyle = .overFullScreen
            mPOSPark.delegate = self
            mPOSPark.transitioningDelegate = self
            self.present(mPOSPark,animated: true)
        }
    }
    
    
    @IBAction func mEditLabour(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "0"
            calculateItemsWithAmount()
        }else{
            calculateItemsWithAmount()
            
        }
    }
    @IBAction func mEditShipping(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "0"
            calculateItemsWithAmount()
        }else{
            calculateItemsWithAmount()
            
            
        }
    }
    
    @IBAction func mEditLoyaltyPoints(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "0"
            calculateItemsWithAmount()
        }else{
            calculateItemsWithAmount()
            
        }
    }
    @IBAction func mEditTaxDiscount(_ sender: UITextField) {
        var mCount = Int()
        if sender.text == "" {
         mCount = 0
        }else{
            mCount = Int(Double(sender.text ?? "") ?? 0)
        }
        if sender.text == "" || sender.text == "0"  || mCount > 100 {
            sender.text = "0"
            self.mTaxDiscountAmounts.text = "0"
            calculateItemsWithAmount()
        }else {
            let discountAmount = calculatePercentage(value: (Double(self.mGrandTotalAmounts) ?? 0.0), percent: Double(sender.text ?? "0") ?? 0)
            self.mTaxDiscountAmounts.text = String(format: "%.2f", discountAmount)
            calculateItemsWithAmount()
        }
    }
    @IBAction func mEditTaxDiscountAmount(_ sender: UITextField) {
        if sender.text == "" {
            
            sender.text = "0"
            self.mTaxDiscountPercents.text = "0"
            calculateItemsWithAmount()
        }else{
            let mPercent = (Double(sender.text ?? "") ?? 0) / (Double(self.mGrandTotalAmounts) ?? 0.0) * 100
            self.mTaxDiscountPercents.text = String(format: "%.2f", mPercent)
            calculateItemsWithAmount()
            
        }
    }
    
    @IBAction func mEditDiscount(_ sender: UITextField) {
        
        
        self.mTaxLabourCharge.text = ""
        self.mTaxShippingCharge.text = ""
        self.mTaxLoyaltyPoint.text = ""
        self.mTaxDiscountAmounts.text = ""
        self.mTaxDiscountPercents.text = ""
        let mIndexPath = IndexPath(row:sender.tag,section: 0)
        var mCount = Int()
        if sender.text == "" {
            mCount = 0
            sender.placeholder = "0.00"
            if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                cell.mDiscountAmount.text = ""
                cell.mProductPrice.text = "\(self.mCartAmount[sender.tag])"
                if let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                   let mData = mInvData.mutableCopy() as? NSMutableDictionary {
                    
                    mData.setValue( self.mCartAmount[sender.tag], forKey: "price")
                    mData.setValue("0", forKey: "discount_percent")
                    mData.setValue("0", forKey: "Discount_Amount")
                    
                    if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                        mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                        if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                            mData.setValue(mServiceLabour, forKey: "Service_labour")
                        }
                    } else {
                        mData.setValue(false, forKey: "Service_labour_exsist")
                    }
                    
                    if mInvData.value(forKey: "stock_id_options") == nil {
                        mData.setValue([], forKey: "stock_id_options")
                    }
                    
                    self.mCartData.removeObject(at: sender.tag)
                    self.mCartData.insert(mData, at: sender.tag)
                    
                    self.calculateItemsWithAmount()
                }
            }
        }else{
            mCount = Int(Double(sender.text ?? "") ?? 0)
            if sender.text == "" || sender.text == "0" || mCount > 100 {
                if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                    cell.mProductPrice.text = "\(self.mCartAmount[sender.tag])"
                    cell.mDiscountAmount.text = "0"

                    if let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                       let mData = mInvData.mutableCopy() as? NSMutableDictionary {
                        
                        mData.setValue( self.mCartAmount[sender.tag], forKey: "price")
                        mData.setValue("0", forKey: "discount_percent")
                        mData.setValue("0", forKey: "Discount_Amount")
                        
                        if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                            mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                            if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                                mData.setValue(mServiceLabour, forKey: "Service_labour")
                            }
                        } else {
                            mData.setValue(false, forKey: "Service_labour_exsist")
                        }
                        
                        if mInvData.value(forKey: "stock_id_options") == nil {
                            mData.setValue([], forKey: "stock_id_options")
                        }
                        
                        self.mCartData.removeObject(at: sender.tag)
                        self.mCartData.insert(mData, at: sender.tag)
                        self.calculateItemsWithAmount()
                    }
                }
            }else {
                guard let mData1 = mCartData[sender.tag] as? NSDictionary else { return }
                
                let mAmount = self.mCartAmount[sender.tag]

                let mDiscountPrice = "\(calculatePercentage(value: Double("\(mAmount)") ?? 0.00, percent: Double(sender.text ?? "0") ?? 0.00))"
                if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                    let val = String(format: "%.02f", locale: Locale.current, Double(Double(mAmount) - (Double(mDiscountPrice) ?? 0.00)))
                    cell.mProductPrice.text = "\(val)"
                    cell.mDiscountAmount.text = "\(mDiscountPrice)"
                    
                    guard let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                          let mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }
                    
                    let price = Double(val.replace(string: ",", replacement: "")) ?? 0
                    mData.setValue(price, forKey: "price")
                    mData.setValue(sender.text ?? "", forKey: "discount_percent")
                    mData.setValue("\(mDiscountPrice)", forKey: "Discount_Amount")
                    
                    if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                        mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                        if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                            mData.setValue(mServiceLabour, forKey: "Service_labour")
                        }
                    } else {
                        mData.setValue(false, forKey: "Service_labour_exsist")
                    }

                    if mInvData.value(forKey: "stock_id_options") == nil {
                        mData.setValue([], forKey: "stock_id_options")
                    }

                    self.mCartData.removeObject(at: sender.tag)
                    self.mCartData.insert(mData, at: sender.tag)
                    
                    self.calculateItemsWithAmount()
                }
            }
       
           
        }
        
    }
    
    @IBAction func mEditDiscountAmount(_ sender: UITextField) {
        self.mTaxLabourCharge.text = ""
        self.mTaxShippingCharge.text = ""
        self.mTaxLoyaltyPoint.text = ""
        self.mTaxDiscountAmounts.text = ""
        self.mTaxDiscountPercents.text = ""
    
        let mIndexPath = IndexPath(row:sender.tag,section: 0)

        if sender.text == "" {
            sender.placeholder = "0.00"
            if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                cell.mDiscountPercent.text = ""
                cell.mProductPrice.text = "\(self.mCartAmount[sender.tag])"

                guard let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                      let mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }

                mData.setValue(self.mCartAmount[sender.tag], forKey: "price")
                mData.setValue("0", forKey: "discount_percent")
                mData.setValue("0", forKey: "Discount_Amount")

                if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                    mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                    if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                        mData.setValue(mServiceLabour, forKey: "Service_labour")
                    }
                } else {
                    mData.setValue(false, forKey: "Service_labour_exsist")
                }

                if mInvData.value(forKey: "stock_id_options") == nil {
                    mData.setValue([], forKey: "stock_id_options")
                }

                self.mCartData.removeObject(at: sender.tag)
                self.mCartData.insert(mData, at: sender.tag)
                self.calculateItemsWithAmount()
            }

        }else{
            var mCount = Int()
            if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                if cell.mDiscountPercent.text != "" {
                    mCount = Int(Double(cell.mDiscountPercent.text ?? "0") ?? 0)
                }else{
                    mCount = 0
                }
                
            }
            if sender.text == "" || sender.text == "0" || mCount > 100 {
                
                if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                    let mData1 = mCartData[sender.tag] as? NSDictionary

                    cell.mDiscountPercent.text = "0"
                    cell.mDiscountAmount.text = "0"
                    cell.mProductPrice.text = "\(self.mCartAmount[sender.tag])"

                    if let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                       let mData = mInvData.mutableCopy() as? NSMutableDictionary {
                        
                        mData.setValue(self.mCartAmount[sender.tag], forKey: "price")
                        mData.setValue("0", forKey: "discount_percent")
                        mData.setValue("0", forKey: "Discount_Amount")
                        
                        if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                            mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                            if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                                mData.setValue(mServiceLabour, forKey: "Service_labour")
                            }
                        } else {
                            mData.setValue(false, forKey: "Service_labour_exsist")
                        }
                        
                        if mInvData.value(forKey: "stock_id_options") == nil {
                            mData.setValue([], forKey: "stock_id_options")
                        }
                        
                        self.mCartData.removeObject(at: sender.tag)
                        self.mCartData.insert(mData, at: sender.tag)
                        self.calculateItemsWithAmount()
                    }
                }

            }else {
                let mData1 = mCartData[sender.tag] as? NSDictionary
                if let cell = self.mCartTable.cellForRow(at: mIndexPath) as? CustomCartItems {
                    let mValue = self.mCartAmount[sender.tag]
                    let mAmount = Double(mValue) - (Double(sender.text ?? "") ?? 0)
                    let mPercent = (Double(sender.text ?? "") ?? 0) / Double(mValue) * 100
                    cell.mDiscountPercent.text = String(format: "%.2f", mPercent)
                    let val = String(format: "%.02f", locale: Locale.current, mAmount)
                    cell.mProductPrice.text = "\(val)"

                    if let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                       let mData = mInvData.mutableCopy() as? NSMutableDictionary {
                        
                        let price = Double(val.replace(string: ",", replacement: "")) ?? 0
                        mData.setValue(price, forKey: "price")
                        mData.setValue(String(format: "%.2f", mPercent), forKey: "discount_percent")
                        mData.setValue("0", forKey: "Discount_Amount")
                        
                        if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                            mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                            if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                                mData.setValue(mServiceLabour, forKey: "Service_labour")
                            }
                        } else {
                            mData.setValue(false, forKey: "Service_labour_exsist")
                        }
                        
                        if mInvData.value(forKey: "stock_id_options") == nil {
                            mData.setValue([], forKey: "stock_id_options")
                        }
                        
                        self.mCartData.removeObject(at: sender.tag)
                        self.mCartData.insert(mData, at: sender.tag)
                        self.calculateItemsWithAmount()
                    }
                }
               
            }
        }
    
    }
    
    
    @IBAction func mShowTax(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
         if sender.isSelected {
            mUpForwardIcon.image = UIImage(named: "top_ic")
            UIView.animate(withDuration: 1.0) {
                self.mTaxView.isHidden = false
                self.view.layoutIfNeeded() }
        }else{
            mUpForwardIcon.image = UIImage(named: "forward_ic")
             UIView.animate(withDuration: 1.0) {
                self.mTaxView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }

        
    }
   
    @IBAction func mOpenProductStoneDetails(_ sender: UIButton) {
        let mIndex = sender.tag
        let mData = mCartData[mIndex] as? NSDictionary
        if let mPoProductId = mData?.value(forKey: "po_product_id") as? String {
            if mPoProductId != "" {
                let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
                if let home = storyBoard.instantiateViewController(withIdentifier: "SKUProductSummary") as? SKUProductSummary{
                    home.mKey = mPoProductId
                    home.modalPresentationStyle = .automatic
                    home.transitioningDelegate = self
                    self.present(home,animated: true)
                }
            }
        }

      
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mTaxAmountLABEL.text = "TAX (Amount)".localizedString
        mTaxPercentLABEL.text = "TAX (%)".localizedString
        mTaxSubTotalLABEL.text = "Sub Total".localizedString
        mDiscountAmountLABEL.text = "Discount (Amount)".localizedString
        mDiscountPercentLABEL.text = "Discount (%)".localizedString
        mTaxShippingLABEL.text = "Shipping".localizedString
        mTaxLoyaltyPointLABEL.text = "Loyalty point".localizedString
        mTaxLabourLABEL.text = "Labour".localizedString
        mTaxTotalLABEL.text = "Total".localizedString
        mCheckOutBUTTON.setTitle("CHECK OUT".localizedString, for: .normal)
        mParkBUTTON.setTitle("PARK".localizedString, for: .normal)
        mHeadingLABEL.text = "POS".localizedString
        mNoteLABEL.text = "Note".localizedString
        mGrandTotalLABEL.text = "Grand Total".localizedString
 
        mTotalItems.text = "0 " + "Item".localizedString
        mSearchField.placeholder = "Search by SKU / Stock ID".localizedString
        mNotes.placeholder = "EX. Urgent Order".localizedString
        
        
        
        if UserDefaults.standard.string(forKey: "cRemark") != nil {
            self.mNotes.text = "\(UserDefaults.standard.string(forKey: "cRemark") ?? "")"
        }
        
        mCustomerId  = UserDefaults.standard.string( forKey: "DEFAULTCUSTOMER") ?? ""
        if mCustomerId == "" {
            mOpenCustomerSheet()
        }else{
            self.mCheckAddresse()
            self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
            mFetchCartItems()
        }
        
        let mParams = ["query":"{stones{id name}colors{id name}metals{id name}shapes{id name}claritys{id name}cuts{id name}sizes{id name}settingType{id name}stonecolors{id name}}"]
        AF.request(mGrapQlUrl, method:.post,parameters: mParams, encoding:JSONEncoding.default, headers: sGisHeaders).responseJSON
        {response in
     
            if(response.error != nil) {
                UserDefaults.standard.set(nil, forKey: "GRAPHQL")
            }else{
                if let jsonData = response.data {
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let jsonResult = json as? NSDictionary {
                        UserDefaults.standard.set(jsonResult, forKey: "GRAPHQL")
                    }
                }
            }
        }
        
        
        AF.request(mGetShapes, method:.post,parameters: nil, headers: sGisHeaders).responseJSON { response in

            if(response.error != nil) {
                UserDefaults.standard.set(nil, forKey: "SHAPES")

            }else{
                if let jsonData = response.data {
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let jsonResult = json as? NSDictionary {
                        
                        UserDefaults.standard.set(jsonResult, forKey: "SHAPES")
                    }
                }
            }
        }
        
        let isPark = UserDefaults.standard.bool(forKey: "isPark")
        if isPark {
            self.mParkButtonView.isHidden = false
            mGetParkStatus()
        }else{
            self.mAvailableParkView.isHidden = true
            self.mParkButtonView.isHidden = true
        }
   
    }
    
    func mGetParkStatus(){
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mGetData(url: mGetPark,headers: sGisHeaders,  params: ["":""]) { response , status in
                if status {
                    if let mData = response.value(forKey: "data") as? NSArray {
                         
                        if mData.count > 0 {
                            self.mAvailableParkView.isHidden = false
                            self.mParkCount.text = "\(mData.count)"
                        }else{
                            self.mAvailableParkView.isHidden = true

                        }
                    }
                }else{
                    self.mAvailableParkView.isHidden = true

                }
        }
    }
    func mGetSearchItems(id: String) {
        var mParams = [String : Any]()
        

            mParams = ["product_id":[id], "customer_id":mCustomerId, "sales_person_id":"", "type":"inventory", "order_type":"pos_order"]
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")

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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
        if let mCommonSearch = storyBoard.instantiateViewController(withIdentifier: "CommonSearch") as? CommonSearch {
            mCommonSearch.modalPresentationStyle = .overFullScreen
            mCommonSearch.delegate = self
            mCommonSearch.mType = "inventory"
            mCommonSearch.mFrom = "pos"
            
            mCommonSearch.transitioningDelegate = self
            self.present(mCommonSearch,animated: false)
        }
    }
    
    @IBAction func mSearchCart(_ sender: Any) {
                
           
    }
    
    
    @IBAction func mOpenCustomer(_ sender: Any) {
      
         mOpenCustomerSheet()
    }
    
    
    @IBAction func mOpenAddressPicker(_ sender: Any) {
        mOpenAddressPicker()
    }
    
    @IBAction func mBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

     }

    @IBAction func mCatalog(_ sender: Any) {
        if mCustomerId == "" {
            CommonClass.showSnackBar(message: "Please choose customer first!")
            mOpenCustomerSheet()
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let mFilters = storyBoard.instantiateViewController(withIdentifier: "CommonCatalog") as? CommonCatalog {
            mFilters.mOrderType = "pos_order"
            
            mFilters.modalPresentationStyle = .overFullScreen
            mFilters.transitioningDelegate = self
            self.present(mFilters,animated: true)
        }
    }
    
    func mGetInventoryItems(items: [String]) {

        mFetchCartItems()
    }
    
    
  
    func mFetchCartItems(){
 
        let mParams = [ "customer_id":mCustomerId ] as [String : Any]
        
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mGetData(url: mFetchCustomProduct, headers:sGisHeaders ,params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
            if "\(response.value(forKey: "code") ?? "")" == "200" {
                if let mData = response.value(forKey: "data") as? NSArray, mData.count > 0 {
                    
                        self.mCartDataMaster = mData
                        self.mCartData = NSMutableArray(array: mData)
                        self.mCartTable.delegate = self
                        self.mCartTable.dataSource = self
                        self.mQuantityData = [Int]()
                        self.mCartAmount = [Double]()

                        self.mCartTable.reloadData()
                        for i in self.mCartData {
                            if let mData = i as? NSDictionary {
                                self.mQuantityData.append(Int("\(mData.value(forKey: "Qty") ?? "0")") ?? 0)
                                self.mCartAmount.append(Double("\(mData.value(forKey: "price") ?? "0")") ?? 0.0)
                            }
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
                return false
            }
            set.insert($0)
            return true
        }
        
        return result
    }
    @IBAction func mInventory(_ sender: Any) {
        if mCustomerId == "" {
            CommonClass.showSnackBar(message: "Please choose customer first!")
            mOpenCustomerSheet()
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let mInv = storyBoard.instantiateViewController(withIdentifier: "CommonInventory") as? CommonInventory{
            mInv.modalPresentationStyle = .overFullScreen
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
    func mGetCustomerData(data: NSMutableDictionary) {
       
        UserDefaults.standard.set(data.value(forKey: "id") ?? "", forKey: "DEFAULTCUSTOMER")
        UserDefaults.standard.set(data.value(forKey: "profile") ?? "", forKey: "DEFAULTCUSTOMERPICTURE")
        UserDefaults.standard.set(data.value(forKey: "name") ?? "", forKey: "DEFAULTCUSTOMERNAME")

        self.mCustomerId = data.value(forKey: "id") as? String ?? ""
        self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
        
        UserDefaults.standard.setValue(nil, forKey: "CustomerBillingAddressUDID")
        UserDefaults.standard.setValue(nil, forKey: "CustomerShippingAddressUDID")
        
        if let haveAddresses = data.value(forKey: "haveAddresses") as? Bool, haveAddresses {
            mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
            mAddressAlertIcon.isHidden = true
        } else {
            mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
            mAddressAlertIcon.isHidden = false
        }
        
        mFetchCartItems()

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
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let code = json["code"] as? Int {
                    switch code {
                    case 200:
                        if let haveAddress = json["AddressExists"] as? Bool, haveAddress {
                            self.mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
                            self.mAddressAlertIcon.isHidden = true
                        } else {
                            self.mAddressPickerIcon.image = UIImage(named: "address_pick_ic_green")
                            self.mAddressAlertIcon.isHidden = false
                        }
                    case 403:
                        CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                    default:
                        break
                    }
                }
            } catch {
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
    
    func mOpenAddressPicker(){
        if !mCustomerId.isEmpty {
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddressPicker", bundle: nil)
            if let addressPicker = storyBoard.instantiateViewController(withIdentifier: "AddressPicker") as? AddressPicker {
                addressPicker.delegate = self
                addressPicker.mCustomerId = mCustomerId
                self.navigationController?.pushViewController(addressPicker, animated: true)
            }
        }
    }
    
    func mGetAddress(data: NSMutableDictionary) {
        
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
    
    
    @IBAction func mCheckOut(_ sender: UIButton) {
        sender.showAnimation{
            
            if self.mCartData.count == 0 {
                CommonClass.showSnackBar(message: "No items in cart!")
                return
            }
            if Double(self.mTotalDepositAmounts) ?? 0.00 == 0.0 {
                CommonClass.showSnackBar(message: "Please fill valid amount!")
                return
            }
            
            guard self.mAddressAlertIcon.isHidden else {
                CommonClass.showSnackBar(message: "Add Billing and Shipping address")
                return
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
            guard let mCheckOut = storyBoard.instantiateViewController(withIdentifier: "POSCheckout") as? POSCheckout else { return }
            mCheckOut.mTotalP = self.mTotalDepositAmounts
            mCheckOut.mSubTotalP = ""
            mCheckOut.mTaxP = ""
            mCheckOut.mTaxAm = ""
            mCheckOut.mStoreCurrency =  self.mCurrency
            mCheckOut.mOrderType = "pos_order"
            mCheckOut.mRemark = self.mNotes.text ?? ""
            mCheckOut.mTotalOutstandingAm = self.mOutStandingAmounts
            mCheckOut.mCurrencySymbol = self.mCurrency
            mCheckOut.mCartTotalAmount = self.mGrandTotalCart
            mCheckOut.mDepositPercents = self.mDepositPercents
            mCheckOut.mTotalWithDiscount =  self.mTotalDepositAmounts
            
            mCheckOut.mLabourPoints = Double(self.mTaxLabourCharge.text ?? "") ?? 0.00
            mCheckOut.mShippingPoints = Double(self.mTaxShippingCharge.text ?? "") ?? 0.00
            mCheckOut.mLoyaltyPoints = Double(self.mTaxLoyaltyPoint.text ?? "") ?? 0.00
            mCheckOut.mTaxAmount = Double(self.mTaxAmount.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            mCheckOut.mTaxAmountInt = Double(self.mTaxAmount.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            mCheckOut.mTaxInPercent = Double(self.mTaxValue.text ?? "") ?? 0.0
            mCheckOut.mTaxDiscountAmount = Double(self.mTaxDiscountAmounts.text ?? "") ?? 0.0
            mCheckOut.mTaxDiscountPercent = Double(self.mTaxDiscountPercents.text ?? "") ?? 0.0
            
            mCheckOut.mTaxTypeIE = UserDefaults.standard.string(forKey: "taxType") ?? ""
            mCheckOut.mCustomerId = self.mCustomerId
            mCheckOut.mCartTableData =  self.mCartData
            
            self.navigationController?.pushViewController( mCheckOut, animated:true)
        }
    }

    func mUpdateCartProduct(newStockId: String,qty: Int , index: Int){
        
        guard let mData = mCartData[index] as? NSDictionary,
        let cartId = mData.value(forKey: "custom_cart_id") as? String,
        let oldStockId = mData.value(forKey: "stock_id") as? String else { return }
        
        let mParams = [ "cart_id": cartId, "old_stockId": oldStockId, "new_stockId": newStockId, "qty": qty ] as [String : Any]
    
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mGetData(url: mStockIdManage, headers:sGisHeaders ,params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
            if "\(response.value(forKey: "code") ?? "")" == "200" {
                self.mFetchCartItems()
            }else{
                CommonClass.showSnackBar(message: "Oop! Something went wrong!")
            }
        }
        }
    }
    
    @IBAction func mPickStockId(_ sender: UIButton) {
        guard let mCartDatas = mCartData[sender.tag] as? NSDictionary else { return }
        if let mCartItems = mCartDatas.value(forKey: "stock_id_options") as? NSArray {
            if mCartItems.count < 1 {
                return
            }
            
            var mStockIds = [String]()
            for i in mCartItems {
                if let data = i as? NSDictionary {
                    mStockIds.append("\(data.value(forKey: "value") ?? "")")
                }
            }

            let dropdown = DropDown()
            dropdown.anchorView = sender
            dropdown.direction = .any
            dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            dropdown.width = 200
            dropdown.dataSource = mStockIds
            dropdown.selectionAction = {
                [unowned self](index:Int, item: String) in
                let cell1 = mCartTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CustomCartItems
               
                mUpdateCartProduct(newStockId: item, qty: mCartDatas.value(forKey: "Qty") as? Int ?? 0 , index: sender.tag)
                cell1?.mStockId.text = item
                
                guard let mInvData = self.mCartData[sender.tag] as? NSDictionary,
                      let mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }

                mData.setValue(item, forKey: "stock_id")

                if let mServiceLabourStatus =  mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                    mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                    if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                        mData.setValue(mServiceLabour, forKey: "Service_labour")
                    }
                } else {
                    mData.setValue(false, forKey: "Service_labour_exsist")
                }

                if mInvData.value(forKey: "stock_id_options") == nil {
                    mData.setValue([], forKey: "stock_id_options")
                }

                self.mCartData.removeObject(at: sender.tag)
                self.mCartData.insert(mData, at: sender.tag)
                self.calculateItemsWithAmount()
            }
            dropdown.show()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        cell.mPickStockId.tag = indexPath.row
        cell.mProductPrice.tag = indexPath.row
        cell.mPlusButton.tag = indexPath.row
        cell.mMinusButton.tag = indexPath.row
        cell.mDiscountAmount.tag = indexPath.row
        cell.mDiscountPercent.tag = indexPath.row
        cell.mEditServiceLabourButton.tag = indexPath.row
        cell.mShowServiceLabourButton.tag = indexPath.row

        guard let mData = mCartData[indexPath.row] as? NSDictionary else { return UITableViewCell() }
        
        let isServiceLabour = UserDefaults.standard.bool(forKey: "isServiceLabour")
        if isServiceLabour {
            if let mServiceLabourStatus =  mData.value(forKey: "Service_labour_exsist") as? Bool {
                mServiceLabourStatus ? (cell.mEditServiceLabourIcon.tintColor = UIColor(named:"themeColor")) : (cell.mEditServiceLabourIcon.tintColor = UIColor(named:"theme6A"))
                
                cell.mServiceLabourView.isHidden = false
                
                if mServiceLabourStatus {
                    
                    self.mTaxLabourCharge.isEnabled = false
                    if let mServiceLabour = mData.value(forKey: "Service_labour") as? NSDictionary {
                        if let mServiceItem = mServiceLabour.value(forKey: "service_laburelist") as? NSArray {
                            if mServiceItem.count > 0 {
                                cell.mServiceLabourCount.text = "Service Labour".localizedString + " (\(mServiceItem.count))"
                                var mAmounts = [Double]()
                                for i in mServiceItem {
                                    if let items = i as? NSDictionary {
                                        mAmounts.append(Double("\(items.value(forKey: "scrviceamount") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00)
                                    }
                                }
                                cell.mServiceLabourCharges.text = self.mCurrency + " " + String(format:"%.02f",locale:Locale.current,mAmounts.reduce(0, {$0 + $1}))
                            }else{
                                self.mTaxLabourCharge.isEnabled = true
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
                self.mTaxLabourCharge.isEnabled = true
            }
        } else {
            cell.mServiceLabourView.isHidden = true
        }
        
        cell.mCurrency.text = "\(mData.value(forKey: "currency") ?? "$")"
        self.mCurrency = "\(mData.value(forKey: "currency") ?? "$") "
 
        cell.mSKUName.text = "\(mData.value(forKey: "SKU") ?? "")"
        cell.mDiscountAmount.text = "\(mData.value(forKey: "Discount_Amount") ?? "")"
        cell.mDiscountPercent.text = "\(mData.value(forKey: "discount_percent") ?? "")"
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
        if let mData = self.mCartData[sender.tag] as? NSDictionary {
            
            if let mServiceData = mData.value(forKey: "Service_labour") as? NSDictionary {
                let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
                if let mSelectedServiceLabour = storyBoard.instantiateViewController(withIdentifier: "SelectedServiceLabour") as? SelectedServiceLabour {
                    mSelectedServiceLabour.modalPresentationStyle = .automatic
                    mSelectedServiceLabour.mProductData = mServiceData
                    mSelectedServiceLabour.transitioningDelegate = self
                    self.present(mSelectedServiceLabour,animated: true)
                }
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
    
    @IBAction func mMinusButton(_ sender: UIButton) {
        let index = sender.tag
        guard let mInvData = mCartData[index] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems else {
            return
        }
        let mOrgData = mCartDataMaster[sender.tag] as? NSDictionary
        let mMinQty = 1
        var mCurrentQty = Int(cells.mQuantityUnit.text ?? "") ?? 0
        if mCurrentQty == mMinQty {
            return
        } else {
            mCurrentQty -= 1
            cells.mQuantityUnit.text = "\(mCurrentQty)"

            cells.mProductPrice.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0))"
        }

        guard let mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }
        
        let finalQTY = Int(cells.mQuantityUnit.text ?? "") ?? 0
        let finalPrice = Double((cells.mProductPrice.text ?? "0").replace(string: ",", replacement: "")) ?? 0
        mData.setValue(finalQTY, forKey: "Qty")
        mData.setValue(finalPrice, forKey: "price")

        if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
            if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                mData.setValue(mServiceLabour, forKey: "Service_labour")
            }
        } else {
            mData.setValue(false, forKey: "Service_labour_exsist")
        }

        if mInvData.value(forKey: "stock_id_options") == nil {
            mData.setValue([], forKey: "stock_id_options")
        }

        mCartData.removeObject(at: index)
        mCartData.insert(mData, at: index)
        mCartTable.reloadData()
        calculateItemsWithAmount()
    }

    @IBAction func mPlusButton(_ sender: UIButton) {
        let index = sender.tag

        let mOrgData = mCartDataMaster[sender.tag] as? NSDictionary
        guard let mInvData = mCartData[index] as? NSDictionary,
              let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems else {
            return
        }
        let mMaxQty =  Int("\(mInvData.value(forKey: "po_QTY") ?? "1")") ?? 1
        var mCurrentQty = Int(cells.mQuantityUnit.text ?? "") ?? 0
        if mCurrentQty == mMaxQty {
            return
        }
        mCurrentQty += 1
        cells.mQuantityUnit.text = "\(mCurrentQty)"

        cells.mProductPrice.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0))"

        guard let mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }

        let finalQTY = Int(cells.mQuantityUnit.text ?? "") ?? 0
        let finalPrice = Double((cells.mProductPrice.text ?? "0").replace(string: ",", replacement: "")) ?? 0
        mData.setValue(finalQTY, forKey: "Qty")
        mData.setValue(finalPrice, forKey: "price")

        if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
            mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
            if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                mData.setValue(mServiceLabour, forKey: "Service_labour")
            }
        } else {
            mData.setValue(false, forKey: "Service_labour_exsist")
        }

        if mInvData.value(forKey: "stock_id_options") == nil {
            mData.setValue([], forKey: "stock_id_options")
        }

        mCartData.removeObject(at: index)
        mCartData.insert(mData, at: index)
        mCartTable.reloadData()
        calculateItemsWithAmount()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
       if editingStyle == .delete {
 
           guard let mData = mCartData[indexPath.row] as? NSDictionary else {
               return
           }
           CommonClass.showFullLoader(view: self.view)
           let mParams = [ "customer_id":mCustomerId , "custom_cart_id":mData.value(forKey: "custom_cart_id") as? String ?? ""] as [String : Any]
           
           mUserLoginToken = UserDefaults.standard.string(forKey: "token")
           mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
           
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
    func mDeleteRow(index : Int)
    {
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
        
        mRemovePopUp.frame = self.view.bounds
        mRemovePopUp.mCustomerId = mCustomerId
        mRemovePopUp.delegate = self
        mRemovePopUp.index = sender.tag
        mRemovePopUp.mType = ""
        if let mData = mCartData[sender.tag] as? NSDictionary {
            mRemovePopUp.mCartId = mData.value(forKey: "custom_cart_id") as? String ?? ""
        }
        mRemovePopUp.mMessage.text = "Are you sure want to remove ?".localizedString
        mRemovePopUp.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
        mRemovePopUp.mConfirmButton.setTitle("CONFIRM".localizedString, for: .normal)
        self.view.addSubview(mRemovePopUp)
    }

    @IBAction func mEditAmount(_ sender: UITextField) {
        
        self.mTaxLabourCharge.text = ""
        self.mTaxShippingCharge.text = ""
        self.mTaxLoyaltyPoint.text = ""
        self.mTaxDiscountAmounts.text = ""
        self.mTaxDiscountPercents.text = ""
        
        if let mInvData = mCartData[sender.tag] as? NSDictionary,
        let mOrgData = mCartDataMaster[sender.tag] as? NSDictionary,
           let cells = mCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? CustomCartItems {
            cells.mQuantityUnit.text = "1"
            cells.mDiscountAmount.text = "0"
            cells.mDiscountPercent.text = "0"
            if sender.text == "" || sender.text == "0" {
                cells.mProductPrice.text = ""
                
                guard var mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }
                mData.setValue(0, forKey: "price")
                self.mCartAmount[sender.tag] = 0.0
                
                mData.setValue("0", forKey: "discount_percent")
                mData.setValue("0", forKey: "Discount_Amount")
                
                if let mServiceLabourStatus = mInvData.value(forKey: "Service_labour_exsist") as? Bool {
                    mData.setValue(mServiceLabourStatus, forKey: "Service_labour_exsist")
                    if mServiceLabourStatus, let mServiceLabour = mInvData.value(forKey: "Service_labour") as? NSDictionary {
                        mData.setValue(mServiceLabour, forKey: "Service_labour")
                    }
                } else {
                    mData.setValue(false, forKey: "Service_labour_exsist")
                }
                
                if let mStockData = mInvData.value(forKey: "stock_id_options") as? NSArray {
                    mData.setValue(mStockData, forKey: "stock_id_options")
                } else {
                    mData.setValue([], forKey: "stock_id_options")
                }
                
                mCartData[sender.tag] = mData
                calculateItemsWithAmount()
                return
            }
            
            guard var mData = mInvData.mutableCopy() as? NSMutableDictionary else { return }
            self.mCartAmount.remove(at: sender.tag)
            self.mCartAmount.insert(Double("\(cells.mProductPrice.text ?? "")") ?? 0.0, at: sender.tag)
            
            let finalPrice = Double((cells.mProductPrice.text ?? "0").replace(string: ",", replacement: "")) ?? 0
            mData.setValue(finalPrice, forKey: "price")
            
            mData.setValue("0", forKey: "discount_percent")
            mData.setValue("0", forKey: "Discount_Amount")
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
            
            if let mStockData = mInvData.value(forKey: "stock_id_options") as? NSArray {
                mData.setValue(mStockData, forKey: "stock_id_options")
            }else{
                mData.setValue([], forKey: "stock_id_options")
                
            }
            mCartData.removeObject(at: sender.tag)
            mCartData.insert(mData, at: sender.tag)
            calculateItemsWithAmount()
        }
    }
    
    @IBAction func mEditremarks(_ sender: UITextField) {
        

    }
    
    
    
    func calculateItemsWithAmount(){
        var mAmounts = [Double]()
        var mQuantities = [Int]()
        
        var mServiceAmounts = [Double]()
        
        for i in mCartData {
            if let mData = i as? NSDictionary {
                let qty = Int("\(mData.value(forKey: "Qty") ?? "0")") ?? 0
                let amount = Double("\(mData.value(forKey: "price") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00
                mQuantities.append(qty)
                mAmounts.append(amount * Double(qty))
                
                if let mServiceLabourStatus = mData.value(forKey: "Service_labour_exsist") as? Bool {
                    
                    if mServiceLabourStatus {
                        if let mServiceLabour = mData.value(forKey: "Service_labour") as? NSDictionary {
                            if let mServiceItem = mServiceLabour.value(forKey: "service_laburelist") as? NSArray,
                               mServiceItem.count > 0 {
                                var mAmounts = [Double]()
                                for i in mServiceItem {
                                    if let items = i as? NSDictionary {
                                        mAmounts.append(Double("\(items.value(forKey: "scrviceamount") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00)
                                    }
                                }
                                
                                mServiceAmounts.append(mAmounts.reduce(0, {$0 + $1}))
                            }
                        }
                        
                    }
                }
            }
        }
        
        self.mTaxLabourCharge.text = "\(mServiceAmounts.reduce(0, {$0 + $1}))"
        mTotalItems.text = "\(mCartData.count) items"
        mGrandTotal.text = self.mCurrency + String(format:"%.02f",locale:Locale.current,mAmounts.reduce(0, {$0 + $1}))
        self.mTaxTotal.text = self.mCurrency + String(format:"%.02f",locale:Locale.current,mAmounts.reduce(0, {$0 + $1}))
        
        mGrandTotalCart = "\(mAmounts.reduce(0, {$0 + $1}))"
        self.mGrandTotalAmounts = "\(mAmounts.reduce(0, {$0 + $1}))"
        self.mTaxValue.text = "\((Double("\(UserDefaults.standard.string(forKey: "taxValue") ?? "0")") ?? 0.00))"
        self.mTaxTotal.text =  self.mCurrency + " " + self.mGrandTotalAmounts.formatPrice()
        if mDepositPercents == "100" {
            var mAdditionalAmount =  Double()
            let mDiscountA = Double(self.mTaxDiscountAmounts.text ?? "") ?? 0.0
            let mLabour = Double(self.mTaxLabourCharge.text ?? "") ?? 0.0
            let mShipping = Double(self.mTaxShippingCharge.text ?? "") ?? 0.0
            let mLoyalty = Double(self.mTaxLoyaltyPoint.text ?? "") ?? 0.0
            mAdditionalAmount = mLabour + mShipping + mLoyalty
            
            mDepositAmount.text =  mGrandTotal.text
            mOutstandingAmount.text = self.mCurrency + "0.00"
            self.mOutStandingAmounts = "0.00"
            self.mTotalDepositAmounts = self.mGrandTotalAmounts

             let mTaxType = UserDefaults.standard.string(forKey: "taxType") ?? ""
                if mTaxType.lowercased() == "inclusive" {
                    let grandTotal = Double(self.mGrandTotalAmounts.replacingOccurrences(of: ",", with: "")) ?? 0.0
                    let taxPercent = Double(UserDefaults.standard.string(forKey: "taxValue") ?? "0.0") ?? 0.0

                    let taxAmount = calculateInclusiveTax(value: grandTotal, percent: taxPercent)

                    mTaxAmount.text = String(format: "%.02f", locale: Locale.current, taxAmount)
                    
                    let subTotal = grandTotal - taxAmount
                    mTaxSubTotal.text = "\(self.mCurrency) \(String(format: "%.02f", locale: Locale.current, subTotal))"

                    var includingDiscount = (Double(self.mGrandTotalAmounts) ?? 0.00) - (mDiscountA)
                    includingDiscount = includingDiscount + mAdditionalAmount
                    
                    mGrandTotal.text = self.mCurrency + "\(includingDiscount)".formatPrice()
                self.mTotalDepositAmounts  = String(format: "%.2f", includingDiscount)

                }
            if mTaxType.lowercased() == "exclusive" {
            
                let grandTotal = Double(self.mGrandTotalAmounts.replacingOccurrences(of: ",", with: "")) ?? 0.0
                let taxPercent = Double(UserDefaults.standard.string(forKey: "taxValue") ?? "0.0") ?? 0.0
                let taxAmount = calculateExclusiveTax(value: grandTotal, percent: taxPercent)
                mTaxAmount.text = String(format: "%.02f", locale: Locale.current, taxAmount)

                let taxSubTotal = grandTotal + taxAmount + mAdditionalAmount - mDiscountA
                mTaxSubTotal.text = self.mCurrency + " " + String(format: "%.02f", locale: Locale.current, taxSubTotal)

                var includingDiscount = (Double(self.mGrandTotalAmounts) ?? 0.00) - (mDiscountA)
                includingDiscount = includingDiscount + mAdditionalAmount + calculateExclusiveTax(value: (Double(self.mGrandTotalAmounts.replacingOccurrences(of: ",", with: "")) ?? 0.0), percent: (Double("\(UserDefaults.standard.string(forKey: "taxValue") ?? "0")") ?? 0.0))
                
                
                mGrandTotal.text = self.mCurrency + "\(includingDiscount)".formatPrice()
            self.mTotalDepositAmounts  = String(format: "%.2f", includingDiscount)
            }
                  
            }else{
              let mTotalValue = mAmounts.reduce(0, {$0 + $1})
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
    func calculateInclusiveTax(value:Double,percent: Double) -> Double {
            let val = value * percent
        return val/(100.00 + (Double("\(UserDefaults.standard.string(forKey: "taxValue") ?? "0")") ?? 0.00))
      
    }
    func calculateExclusiveTax(value:Double,percent: Double) -> Double {
        let val = value * percent
        return val/100.00
    }

    
}
extension Double {
    
    func toInt() -> Int? {
        let roundedValue = rounded(.toNearestOrEven)
        return Int(exactly: roundedValue)
    }
    
}
