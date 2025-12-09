//
//  CustomOrderCheckout.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 03/02/23.
//  Copyright © 2023 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Stripe
import StripePaymentSheet


let mConfirmationPopUp = UINib(nibName:"confirmation",bundle:.main).instantiate(withOwner: nil, options: nil).first as? ConfirmationPopUp ?? ConfirmationPopUp()

protocol ProceedToPay {
    func isProceed(status:Bool)
    func isProceedWithStatus(status:Bool, message : String)
}

class ConfirmationPopUp: UIView {
    
    var mType = ""
    var mCustomerId = ""
    var mCartId = ""
    var index = Int()
    var delegate:ProceedToPay? = nil
    @IBOutlet weak var mMessage: UILabel!
    @IBOutlet weak var mConfirmButton: UIButton!
    @IBOutlet weak var mCancelButton: UIButton!
    
    var mNavigation = UINavigationController()
    static func instantiate(message: String) -> ConfirmationPopUp {
        let view: ConfirmationPopUp = initFromNib()
        return view
    }
    
    @IBAction func mCancel(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    @IBAction func mConfirm(_ sender: Any) {
        self.removeFromSuperview()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.isProceed(status: true)
            
        }
        
    }
    
}

class CustomOrderCheckout: UIViewController, UITextFieldDelegate , UITableViewDelegate ,UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,GetVerification , ProceedToPay, UIViewControllerTransitioningDelegate, QRCodeViewDelegate,STPAuthenticationContext {
    
    
    
    func isProceedWithStatus(status: Bool, message: String) {}
    
    // Tab bar for select option -:
    
    private var paymentSheet: PaymentSheet?
    @IBOutlet weak var mIBLabel: UILabel!
    @IBOutlet weak var mChequeLabel: UILabel!
    
    @IBOutlet weak var mSelectedTabIB: UILabel!
    
    @IBOutlet weak var mSelectedTabCheque: UILabel!
    
    @IBOutlet weak var mIBSelect: UIButton!
    
    @IBOutlet weak var mChequeSelect: UIButton!
    
    @IBOutlet weak var mTabBarContainer: UIView!
    
    @IBOutlet weak var mSelectPaymentOptionContainer: UIView!
    
    
    @IBOutlet weak var mEnterAmountText: UITextField!
    
    @IBOutlet weak var mSelectIBBankImage: UIImageView!
    
    @IBOutlet weak var mSelectIBBank: UITextField!
    
    let qrCodeView = QRCodeView.loadFromNib()
    
    //Icons and Text
    
    @IBOutlet weak var mCashIcon: UIImageView!
    @IBOutlet weak var mCreditNoteIcon: UIImageView!
    @IBOutlet weak var mBankIcon: UIImageView!
    @IBOutlet weak var mCreditCardIcon: UIImageView!
    
    //CreditNote
    @IBOutlet weak var mCreditNoteDetailsView: UIView!
    @IBOutlet weak var mTotalCreditAmount: UILabel!
    
    @IBOutlet weak var mItemsSelected: UILabel!
    @IBOutlet weak var mTotalSelectedAmount: UILabel!
    
    @IBOutlet weak var mCreditNoteTable: UITableView!
    @IBOutlet weak var mSubmitCreditNote: UIButton!
    var mCreditNoteData = NSMutableArray()
    var mSelectedIndex = [IndexPath]()
    
    //CashView
    var mCurrencyImageData = [String]()
    var mCurrencyNameData = [String]()
    var mCashAmounts = ""
    var mSelectedStoreCurrency = ""
    var mStoreCurrency = ""
    var isQRCodeDeleted = false
    
    @IBOutlet weak var mEditCashView: UIView!
    @IBOutlet weak var mCashCurrencyImage: UIImageView!
    
    @IBOutlet weak var mCurrencyName: UILabel!
    @IBOutlet weak var mChooseCurrencyButt: UIButton!
    
    @IBOutlet weak var mCashAmount:
    UITextField!
    
    @IBOutlet weak var mExchangeRateLabel: UILabel!
    
    @IBOutlet weak var mExchangeRateValue: UITextField!
    
    @IBOutlet weak var mConvertedAmount: UILabel!
    
    @IBOutlet weak var mCardNumberContainer: UIView!
    @IBOutlet weak var mCardNameContainer: UIStackView!
    
    var mConvertedAmounts = "0"
    
    var mExchangeRateData = [String]()
    var mClientReferenceID = ""
    var mTotalP = ""
    var mTotalAm = ""
    var mSubTotalP = ""
    var mTaxP = ""
    var mTaxAm = ""
    
    var mRemark = ""
    var mTaxType = ""
    var mTaxLabel = ""
    var mTaxPercent = ""
    var mTotalWithDiscount = ""
    var mCustomerId = ""
    var mCartTableData = NSMutableArray()
    
    @IBOutlet weak var mSubmitTx: UIButton!
    @IBOutlet weak var mTaxCalView: UIView!
    
    @IBOutlet weak var mTotalTx: UILabel!
    
    @IBOutlet weak var mTotalDiscountTx: UILabel!
    
    @IBOutlet weak var mSubTotalTx: UILabel!
    
    @IBOutlet weak var mTaxVal: UITextField!
    @IBOutlet weak var mFinalTaxAmount: UITextField!
    @IBOutlet weak var mTaxAmountTx: UILabel!
    @IBOutlet weak var mTaxValueTx: UILabel!
    
    @IBOutlet weak var mExchangeTx: UILabel!
    
    
    @IBOutlet weak var mLabourCharge: UITextField!
    
    @IBOutlet weak var mShippingCharge: UITextField!
    
    @IBOutlet weak var mDiscountPercents: UITextField!
    
    @IBOutlet weak var mDiscountAmounts: UITextField!
    
    
    
    @IBOutlet weak var mPayNowButton: UIButton!
    
    @IBOutlet weak var mCreditCardView: UIView!
    
    @IBOutlet weak var mTaxInfoView: UIView!
    @IBOutlet weak var mKeyBoardView: UIView!
    @IBOutlet weak var mCardView: UIView!
    
    @IBOutlet weak var mCashView: UIView!
    @IBOutlet weak var mBankView: UIView!
    
    @IBOutlet weak var mCreditNoteView: UIView!
    @IBOutlet weak var mTaxView: UIView!
    
    
    
    
    
    @IBOutlet weak var mVisaView: UIView!
    
    @IBOutlet weak var mApplePayView: UIView!
    
    @IBOutlet weak var mAliPayView: UIView!
    @IBOutlet weak var mWeChatPayView: UIView!
    
    @IBOutlet weak var mCreditCardLabel: UILabel!
    
    @IBOutlet weak var mApplePayLabel: UILabel!
    
    @IBOutlet weak var mAliPayLabel: UILabel!
    
    @IBOutlet weak var mWeChatPayLabel: UILabel!
    
    @IBOutlet weak var mPayNowView: UIView!
    
    @IBOutlet weak var mCustomerSearch: UITextField!
    
    @IBOutlet weak var mDropDownImage: UIImageView!
    let mCustomerSearchTableView = UITableView()
    
    @IBOutlet weak var mCustomerSearchView: UIView!
    @IBOutlet weak var mCustomerDetailView: UIView!
    @IBOutlet weak var mCustomerNames: UILabel!
    @IBOutlet weak var mCustomerAddresss: UILabel!
    @IBOutlet weak var mCustomerNumbers: UILabel!
    var mSearchCustomerData = NSArray()
    
    @IBOutlet weak var mBALANCEDUE: UILabel!
    @IBOutlet weak var mTOTALAMOUNT: UILabel!
    
    @IBOutlet weak var mSubmittedCash: UILabel!
    
    @IBOutlet weak var mSubmittedCreditCard: UILabel!
    @IBOutlet weak var mSubmittedCreditNote: UILabel!
    
    @IBOutlet weak var mCreditNotesView: UIView!
    var mTransactionType = "Cash"
    var isExchange = false
    
    var mOrderType = ""
    var mPartialPayment = ""
    var mQuantity = [Int]()
    
    var  mCreditData = NSMutableArray()
    var  mCreditDataMerged = NSMutableArray()
    var mSelectedCustomIndex = [IndexPath]()
    var mAmountData = NSMutableArray()
    
    var mCreditCardMethod = NSMutableArray()
    var mGiftCardMethod = NSMutableArray()
    var mGiftFinalTotalAmount = ""
    
    
    //Top
    @IBOutlet weak var mHCheckoutLABEL: UILabel!
    @IBOutlet weak var mCreditCardLABEL: UILabel!
    @IBOutlet weak var mCashLABEL: UILabel!
    @IBOutlet weak var mBankLABEL: UILabel!
    @IBOutlet weak var mCreditNoteLABEL: UILabel!
    
    
    
    @IBOutlet weak var mClearBUTTON: UIButton!
    @IBOutlet weak var mCNTotalLABEL: UILabel!
    @IBOutlet weak var mSUBLABEL: UILabel!
    @IBOutlet weak var mTLabourLABEL: UILabel!
    @IBOutlet weak var mTShippingLABEL: UILabel!
    @IBOutlet weak var mLoyaltyPointLABEL: UILabel!
    @IBOutlet weak var mTDiscountPLABEL: UILabel!
    @IBOutlet weak var mTDiscountALABEL: UILabel!
    @IBOutlet weak var mTaxPLABEL: UILabel!
    @IBOutlet weak var mTaxALABEL: UILabel!
    @IBOutlet weak var mBCreditCardLABEL: UILabel!
    @IBOutlet weak var mBCashLABEL: UILabel!
    @IBOutlet weak var mBBankLABEL: UILabel!
    @IBOutlet weak var mBCreditNoteLABEL: UILabel!
    @IBOutlet weak var mTxTotalLABEL: UILabel!
    @IBOutlet weak var mTxSubTotalLABEL: UILabel!
    @IBOutlet weak var mTxExchangeLABEL: UILabel!
    @IBOutlet weak var mBTotalLABEL: UILabel!
    @IBOutlet weak var mBBalanceDueLABEL: UILabel!
    @IBOutlet weak var mTxDiscountLABEL: UILabel!
    
    
    
    
    @IBOutlet weak var mChequeDetailsView: UIView!
    @IBOutlet weak var mChequeAmount: UITextField!
    @IBOutlet weak var mCheqDate: UITextField!
    @IBOutlet weak var mCheqAccountNumber: UITextField!
    @IBOutlet weak var mCheqAccountName: UITextField!
    @IBOutlet weak var mCheqBankImage: UIImageView!
    @IBOutlet weak var mCheqBankName: UITextField!
    @IBOutlet weak var mCheqRefNumber: UITextField!
    @IBOutlet weak var mCheqInstNumber: UITextField!
    
    @IBOutlet weak var mSubmittedBankAmount: UILabel!
    
    
    
    @IBOutlet weak var mCheqDateLABEL: UILabel!
    @IBOutlet weak var mCheqAccountNoLABEL: UILabel!
    @IBOutlet weak var mCheqAccountNameLABEL: UILabel!
    @IBOutlet weak var mCheqBankLABEL: UILabel!
    @IBOutlet weak var mCheqRefLABEL: UILabel!
    @IBOutlet weak var mCheqInstLABEL: UILabel!
    @IBOutlet weak var mCheqSubmitBUTTON: UIButton!
    
    
    var mChequePaymentId = ""
    var mCreditCardPaymentId = ""
    var mCreditCardLogo = ""
    var mCreditCardName = ""
    var mClientSecreat = ""
    var mPaymentIntentID = ""
    var mPaymentID = ""
    var mStripPublishKey = ""
    var mPaymentMethod = ""
    var mSelectdPaymentMethod = ""
    let mDatePicker:UIDatePicker = UIDatePicker()
    var mChequeData = NSMutableDictionary()
    var mFinalPaymentMethod = [String:Any]()
    
    var mFTOTAL = ""
    
    
    @IBOutlet weak var mSubmitButtonCredit: UIButton!
    @IBOutlet weak var mCloseButtonCredit: UIButton!
    @IBOutlet weak var mCreditCardPaymentView: UIView!
    @IBOutlet weak var mCreditFillAmount: UITextField!
    
    @IBOutlet weak var mCreditCardBanksView: UIView!
    @IBOutlet weak var mStripeCardView: UIView!
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    var mStripeIndex = 0
    var mPaymentData =  NSArray()
    
    @IBOutlet weak var mGiftCardAmount: UITextField!
    @IBOutlet weak var mApplyGiftBUTTON: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        self.mCreditCardPaymentView.isHidden = true
        mVisaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.backgroundColor = .clear
        mAliPayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mVisaView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mCreditCardLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mApplePayLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mAliPayLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mWeChatPayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        self.mCheqBankName.text = "Choose Bank"
        self.mCheqBankImage.downlaodImageFromUrl(urlString:  "https://art.gis247.net/assets/images/icon/camera_profile.png")
        
        
        mApplyGiftBUTTON .setTitle("APPLY".localizedString, for: .normal)
        mGiftCardAmount.placeholder = "Gift Card number".localizedString
        mHCheckoutLABEL.text = "CHECK OUT".localizedString
        mCreditCardLABEL.text = "Credit Card".localizedString
        mCashLABEL.text = "Cash".localizedString
        mBankLABEL.text = "Bank".localizedString
        mCreditNoteLABEL.text = "Credit note".localizedString
        
        mCNTotalLABEL.text = "Total".localizedString
        mSUBLABEL.text = "SUB".localizedString
        
        mBCreditCardLABEL.text = "Credit Card".localizedString
        mBCashLABEL.text = "Cash".localizedString
        mBBankLABEL.text = "Bank".localizedString
        mBCreditNoteLABEL.text = "Credit Note".localizedString
        
        mBTotalLABEL.text = "Grand Total".localizedString
        mBBalanceDueLABEL.text = "Balance Due".localizedString
        mCreditCardLabel.text = "Credit Card".localizedString
        
        mExchangeRateLabel.text = "Exchange Rate".localizedString
        mItemsSelected.text = "0 " + "Item Selected".localizedString
        mPayNowButton.setTitle("PAY NOW".localizedString, for: .normal)
        mClearBUTTON.setTitle("Clear".localizedString, for: .normal)
        mCheqSubmitBUTTON .setTitle("SUBMIT".localizedString, for: .normal)
        mSubmitButtonCredit .setTitle("SUBMIT".localizedString, for: .normal)
        mCardNumber.placeholder = "Card number".localizedString
        mCardName.placeholder = "Card name".localizedString
        mCheqAccountNoLABEL.text = "Account No.".localizedString
        mCheqAccountNameLABEL.text = "Account Name".localizedString
        mCheqRefLABEL.text = "Ref No.".localizedString
        mCheqInstLABEL.text = "Inst No.".localizedString
        
    }
    
    @IBOutlet weak var mCardNumber: UITextField!
    @IBOutlet weak var mCardName: UITextField!
    
    @IBOutlet weak var mCreditBankName: UITextField!
    @IBOutlet weak var mCreditBankImage: UIImageView!
    
    @IBOutlet weak var mTotalItemsInCart: UILabel!
    
    
    
    
    
    var mCreditCardPayment = NSMutableArray()
    var mBankPayment = NSMutableArray()
    var mCashPayment = NSMutableDictionary()
    var mCartTotalAmount = ""
    var mDepositPercents = "100"
    var mTotalOutstandingAm = "0.00"
    var mCurrencySymbol = "$"
    
    
    
    var mLabourPoints = 0
    var mShippingPoints = 0
    var mLoyaltyPoints = 0
    var mTaxAmount = 0
    var mTaxAmountInt = 0
    var mTaxInPercent = 0
    var mTaxDiscountAmount:Double = 0
    var mTaxDiscountPercent:Double = 0
    var mTaxTypeIE = ""
    var mOrderId = ""
    
    @IBOutlet weak var mGCurrency: UILabel!
    
    @IBOutlet weak var mBCurrency: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mGCurrency.text = UserDefaults.standard.string(forKey: "currencySymbol") ?? "$"
        mBCurrency.text = UserDefaults.standard.string(forKey: "currencySymbol") ?? "$"
        
        if let mStoreCurr = UserDefaults.standard.string(forKey: "storeCurrency") as? String {
            mStoreCurrency = mStoreCurr
        }
        
        mCreditNoteTable.separatorStyle = .none
        
        if mCartTableData.count > 1 {
            mTotalItemsInCart.text = "\(mCartTableData.count) Items"
        }else{
            mTotalItemsInCart.text = "\(mCartTableData.count) Item"
            
        }
        
        if mOrderType == "Sales Order" {
            mTotalAm = mTotalP.replacingOccurrences(of: ",", with: "")
            mTotalTx.text = mTotalP
            mSubTotalTx.text = mSubTotalP
            mTaxAmountTx.text = mTaxAm
            mTaxValueTx.text = "Tax(\(mTaxP)%)"
            mTaxVal.text = mTaxP
            mFinalTaxAmount.text = mTaxAm
            self.mLabourCharge.text = "0"
            self.mShippingCharge.text = "0"
            self.mDiscountAmounts.text = "0"
            self.mDiscountPercents.text = "0"
            
            
        }else{
            mCreditNoteView.isHidden = false
            mCreditNotesView.isHidden = false
        }
        
        if let mData = UserDefaults.standard.object(forKey: "CREDITCARDDATA") as? NSArray {
            if mData.count > 0 {
                self.mPaymentData = mData
                self.mCollectionView.delegate = self
                self.mCollectionView.dataSource = self
                self.mCollectionView.reloadData()
            }
        }
        
        
        
        mFetchCreditNoteData(value: "")
        
        mCardNumber.keyboardType = .numberPad
        self.mCashLABEL.textColor = UIColor(named:"themeColor")
        self.mCreditCardLABEL.textColor = UIColor(named:"theme6A")
        self.mBankLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditNoteLABEL.textColor = UIColor(named:"theme6A")
        self.mCashIcon.image = UIImage(named: "cashGreen")
        self.mCreditNoteIcon.image = UIImage(named: "creditnotegrey_ic")
        self.mCreditCardIcon.image = UIImage(named: "card_grey_ic")
        self.mBankIcon.image = UIImage(named: "bankgrey_ic")
        mTransactionType = "Cash"
        mChequeDetailsView.isHidden = true
        mTaxInfoView.isHidden = true
        mKeyBoardView.isHidden = false
        mCreditCardView.isHidden = true
        mEditCashView.isHidden = false
        mCreditNoteDetailsView.isHidden = true
        mCashView.backgroundColor = .clear
        mCardView.backgroundColor = UIColor(named: "themeShades")
        mBankView.backgroundColor = UIColor(named: "themeShades")
        mCreditNoteView.backgroundColor = UIColor(named: "themeShades")
        
        mShowDatePicker()
        mGetCurrency()
        
        mPartialPayment = UserDefaults.standard.string( forKey: "isPartialPayment") ?? "0"
        
        mFetchStore(key: "")
        getCustomerAddressList()
        mTabBarContainer.isHidden = true
        mIBSelect.isSelected = true
        
        mSelectPaymentOptionContainer.isHidden = true
        mIBLabel.text = "Internet Banking".localizedString
        mBankLABEL.text = "Cheque".localizedString
        
        
    }
    
    
    @IBAction func mDeleteIBAmount(_ sender: Any) {
        var text = mEnterAmountText.text ?? ""
        if text != "" {
            text.removeLast()
            mEnterAmountText.text = text
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    @IBAction func mIBButton(_ sender: Any) {
        
        mSelectPaymentOptionContainer.isHidden =  false
        mChequeDetailsView.isHidden = true
        mChequeDetailsView.isHidden = true
        mIBSelect.isSelected = true
        mChequeSelect.isSelected = false
        
        // Update background colors
        mSelectedTabIB.backgroundColor = UIColor(named: "themeColor")
        mSelectedTabCheque.backgroundColor = UIColor(named: "themeExtraLightText")
        
        
    }
    
    @IBAction func mChequeButton(_ sender: Any) {
        mSelectPaymentOptionContainer.isHidden = true
        mChequeDetailsView.isHidden = false
        mChequeSelect.isSelected = true
        mIBSelect.isSelected = false
        
        // Update background colors
        mSelectedTabCheque.backgroundColor = UIColor(named: "themeColor")
        mSelectedTabIB.backgroundColor = UIColor(named: "themeExtraLightText")
    }
    
    
    @IBAction func mTakePhoto(_ sender: Any) {
        
        
    }
    
    
    @IBAction func mScanQRCode(_ sender: Any) {
        if mEnterAmountText.text?.isEmpty == true || (Double(mEnterAmountText.text ?? "") ?? 0.0) == 0 {
            CommonClass.showSnackBar(message: "Please fill amount!")
            return
        }
        if let balanceDue = mBALANCEDUE.text {
            let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
            let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
            let inputAmount = Double(mEnterAmountText.text ?? "") ?? 0.0
            
            if (balanceDueInDouble - inputAmount) < 0 {
                CommonClass.showSnackBar(message: "Please fill valid amount!")
                return
            }
        } else {
            CommonClass.showSnackBar(message: "Balance due is not available!")
            return
        }
        if mSelectIBBank.text == "Choose Bank" || mSelectIBBank.text?.isEmpty == true {
            CommonClass.showSnackBar(message: "Please choose a bank name!")
            return
        }
        mGenerateQRCode()
        
        
    }
    
    
    
    
    @IBAction func mSubmitIBAmount(_ sender: Any) {
        
        if mEnterAmountText.text == "" || (Double(mEnterAmountText.text ?? "") ?? 0.0) == 0 {
            CommonClass.showSnackBar(message: "Please fill amount!")
        }else{
            
            if let balanceDue = mBALANCEDUE.text {
                let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
                let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
                let inputAmount = Double(mEnterAmountText.text ?? "") ?? 0.0
                if (balanceDueInDouble - inputAmount) < 0 {
                    CommonClass.showSnackBar(message: "Please fill valid amount!")
                    return
                }
            }
            
            
            
        }
        
    }
    
    
    @IBAction func mApplyGiftCard(_ sender: UIButton) {
        sender.showAnimation{}
        if mGiftCardAmount.text != "" {
            mApplyGiftCards(cardNumber: mGiftCardAmount.text ?? "")
        }else{
            CommonClass.showSnackBar(message: "Please fill valid details!")
        }
        
    }
    func mApplyGiftCards(cardNumber:String){
        
        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        
        let urlPath =  mApplyForGiftCard
        
        let params = ["Giftcard_code": cardNumber, "location_id":mLocation]
        
        if Reachability.isConnectedToNetwork() == true {
            CommonClass.showFullLoader(view: self.view)
            AF.request(urlPath, method:.post, parameters:params, headers: sGisHeaders2).responseJSON
            { [self] response in
                
                CommonClass.stopLoader()
                
                guard response.error == nil else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
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
                    
                    if let mCreditRow = jsonResult.value(forKey: "creditNote_row") as? NSDictionary {
                        
                        var isExist = false
                        for item in mCreditNoteData {
                            if let value = item as? NSDictionary,
                               let id = value.value(forKey: "id") {
                                if "\(id)" == "\(mCreditRow.value(forKey: "id") ?? "")"{
                                    isExist = true
                                }
                            }
                        }
                        
                        if !isExist {
                            CommonClass.showSnackBar(message: "Gift Card Added Successfully")
                            self.mSelectedIndex = [IndexPath]()
                            let mNewData = NSMutableDictionary()
                            
                            mNewData.setValue("\(mCreditRow.value(forKey: "amount") ?? "0.0")", forKey: "amount")
                            
                            mNewData.setValue("\(mCreditRow.value(forKey: "type") ?? "")", forKey: "type")
                            mNewData.setValue("\(mCreditRow.value(forKey: "date") ?? "")", forKey: "date")
                            mNewData.setValue("\(mCreditRow.value(forKey: "Ref_No") ?? "")", forKey: "Ref_No")
                            mNewData.setValue("\(mCreditRow.value(forKey: "id") ?? "")", forKey: "id")
                            self.mCreditNoteData.add(mNewData)
                            
                            
                            var mAmount = [Double]()
                            self.mAmountData = NSMutableArray()
                            for item in mCreditNoteData {
                                if let value = item as? NSDictionary,
                                   let amount = value.value(forKey: "amount") {
                                    let mCData = NSMutableDictionary()
                                    
                                    mAmount.append(Double("\(amount)") ?? 0)
                                    
                                    mCData.setValue("\(amount)", forKey: "amount")
                                    self.mTotalCreditAmount.text = String(format:"%.02f",locale:Locale.current,mAmount.reduce(0, {$0 + $1}))
                                    
                                    self.mAmountData.add(mCData)
                                }
                            }
                            self.mCreditNoteTable.delegate = self
                            self.mCreditNoteTable.dataSource = self
                            self.mCreditNoteTable.reloadData()
                            self.mGetTotalAmount()
                            
                        }else{
                            CommonClass.showSnackBar(message: "Already Added!")
                            
                        }
                    }
                } else {
                    
                    CommonClass.showSnackBar(message: "Invalid Card!")
                    if let error = jsonResult.value(forKey: "error") as? String {
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        }
                    }
                }
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
    @IBAction func mDeleteCreditFillAmount(_ sender: Any) {
        var text = mCreditFillAmount.text ?? ""
        if text != "" {
            text.removeLast()
            mCreditFillAmount.text = text
        }
    }
    
    @IBAction func mCloseCreditView(_ sender: Any) {
        
        
        self.mCreditCardPaymentView.isHidden = true
    }
    
    @IBAction func mSubmitCreditAmount(_ sender: UIButton) {
        
        if let balanceDue = self.mBALANCEDUE.text {
            let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
            let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
            let inputAmount = Double(self.mCreditFillAmount.text ?? "") ?? 0.0
            
            if inputAmount <= balanceDueInDouble {
                self.mGetStripeDataBackEnd()
            } else {
                CommonClass.showSnackBar(message: "Please fill a valid amount!")
                return
            }
        }
        
        
    }
    
    func mAddCredit(cardNumber:String, cardExp:String, cardCvc:String, amount:String){
        
        CommonClass.showFullLoader(view: self.view)
        
        _ = UserDefaults.standard.string(forKey: "location")
        
        let urlPath =  mCreditCardAdd
        
        let params = ["card_no": cardNumber, "card_cvc":cardCvc,"exp_month":cardExp,"card_holderName":UserDefaults.standard.string(forKey: "CUSTOMERID") ?? "" ,"method_id":mCreditCardPaymentId,"salesPerson_val": UserDefaults.standard.string(forKey: "SALESPERSONID") ?? "" ,"amount":amount]
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:params, headers: sGisHeaders2).responseJSON
            { [self] response in
                
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
                        if let mData = jsonResult.value(forKey: "data") as? NSDictionary {
                            
                            let mId = mData.value(forKey: "insert_id") as? String ?? ""
                            let mCreditCardOptions = NSMutableDictionary()
                            mCreditCardOptions.setValue(self.mCreditCardPaymentId, forKey: "cardPaymentId")
                            mCreditCardOptions.setValue(amount, forKey: "amount")
                            mCreditCardOptions.setValue(mId, forKey: "id")
                            self.mCreditCardMethod.add(mCreditCardOptions)
                            var mAmount = [Double]()
                            
                            for i in self.mCreditCardMethod {
                                if let mAM = i as? NSDictionary,
                                   let amount = mAM.value(forKey: "amount") {
                                    mAmount.append(Double("\(amount)") ?? 0)
                                }
                            }
                            self.mSubmittedCreditCard.text = "\( mAmount.reduce(0, {$0 + $1}))"
                            
                            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
                            let submittedCash = Double(mSubmittedCash.text ?? "") ?? 0.0
                            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.0
                            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.0
                            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.0
                            
                            let mTotalValue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
                            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                        }
                    }else {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mPaymentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "Collect",for:indexPath) as? Collect else {
            return UICollectionViewCell()
        }
        
        if let mData = mPaymentData[indexPath.row] as? NSDictionary {
            cells.mImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "PayMethod_logo") ?? "")")
            cells.mName.text = mData.value(forKey: "name") as? String
            if mStripeIndex == indexPath.row {
                
                mCreditCardPaymentId = mData.value(forKey: "id") as? String ?? ""
                mCreditCardName = "\(mData.value(forKey: "name") ?? "")"
                mCreditCardLogo = "\(mData.value(forKey: "PayMethod_logo") ?? "")"
                cells.mView.borderColor = UIColor(named: "themeColor")
                cells.mView.borderWidth = 1
                cells.mView.layer.cornerRadius = 10
                
            }else {
                cells.mView.borderWidth = 0
                cells.mView.layer.cornerRadius = 10
            }
        }
        return cells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "Collect",for:indexPath) as? Collect
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = collectionView.frame.width / 2
        layout?.minimumLineSpacing = 16
        
        
        return CGSize(width: (collectionView.frame.width / 2) - 16 , height: (collectionView.frame.height / 2) - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mStripeIndex = indexPath.row
        
        if let mData = mPaymentData[indexPath.row] as? NSDictionary {
            print(mData,"check payment data")
            mCreditCardPaymentId = mData.value(forKey: "id") as? String ?? ""
            mCreditCardName = "\(mData.value(forKey: "name") ?? "")"
            mCreditCardLogo = "\(mData.value(forKey: "PayMethod_logo") ?? "")"
            mPaymentID = "\(mData.value(forKey: "id") ?? "")"
            mPaymentMethod = "\(mData.value(forKey: "PaymentMethod") ?? "")"
            mStripPublishKey = "\(mData.value(forKey: "key") ?? "")"
            mSelectdPaymentMethod = "\(mData.value(forKey: "payment_slag") ?? "")"
            self.mCreditBankImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "PayMethod_logo") ?? "")")
            self.mCreditBankName.text = mData.value(forKey: "name") as? String
            mCardNumber.text = ""
            mCardName.text = ""
            mCreditFillAmount.text = ""
            self.mStripeCardView.isHidden = false
            self.mCreditCardBanksView.isHidden = true
            self.mStripeCardView.isHidden = false
            if mSelectdPaymentMethod == "stripe-payment" {
                
                self.mCardNumberContainer.isHidden = true
                self.mCardNameContainer.isHidden = true
            }else {
                self.mCardNumberContainer.isHidden = false
                self.mCardNameContainer.isHidden = false
            }
            self.mCollectionView.reloadData()
        }
    }
    
    
    func mFetchStore(key: String){
        
        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        
        let urlPath =  mFetchPaymentMethod
        _ = ["login_token": mUserLoginToken ?? "", "location_id": mLocation ]
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:["secretKeysshow":"true"], headers: sGisHeaders2).responseJSON
            { response in
                print(response,"check bank")
                if response.error != nil {
                    
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
                        
                        if let mPaymentMethod = jsonResult.value(forKey: "data") as? NSDictionary {
                            
                            if let mData = mPaymentMethod.value(forKey: "Credit_Card") as? NSArray, mData.count > 0 {
                                self.mPaymentData = mData
                                self.mCollectionView.delegate = self
                                self.mCollectionView.dataSource = self
                                self.mCollectionView.reloadData()
                            }
                        }
                    }else {
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
    
    @IBAction func mDeleteChequeAmount(_ sender: Any) {
        
        var text = mChequeAmount.text ?? ""
        if text != "" {
            text.removeLast()
            mChequeAmount.text = text
            
            if text == "" {
                self.mSubmittedBankAmount.text = "0.0"
                mChequePaymentId = ""
                mChequeData = NSMutableDictionary()
                mChequeData.setValue("", forKey: "cheque_date")
                mChequeData.setValue("", forKey: "cheque_ac_no")
                mChequeData.setValue("", forKey: "cheque_ac_name")
                mChequeData.setValue("", forKey: "cheque_bank")
                mChequeData.setValue("", forKey: "cheque_ref_no")
                mChequeData.setValue("", forKey: "cheque_date")
                
                let totalAmount = (self.mTOTALAMOUNT.text ?? "").replacingOccurrences(of: ",", with: "")
                let totalAmountDouble = Double(totalAmount) ?? 0
                let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0
                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0
                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0
                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0
                
                self.mBALANCEDUE.text = "\(totalAmountDouble - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard)".formatPrice()
                
            }
        }else{
            
        }
    }
    
    @IBAction func mChooseCheqDate(_ sender: Any) {
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
        
        mCheqDate.inputAccessoryView = mToolBar
        mCheqDate.inputView = mDatePicker
        
    }
    @objc func doneDatePick(){
        let mDayd = DateFormatter()
        mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        
        mCheqDate.text  = "\(mYeard.string(from: mDatePicker.date))/" +  "\(mMonthm.string(from: mDatePicker.date))/"+"\(mDayd.string(from: mDatePicker.date))"
        
        self.view.endEditing(true)
        
    }
    @objc func mCancelDatePick(){
        self.view.endEditing(true)
    }
    
    @IBAction func mChooseBanks(_ sender: Any) {
        
        var mBankNames = ["Choose Bank"]
        var mBankImage = ["https://art.gis247.net/assets/images/icon/camera_profile.png"]
        var mPMId = [""]
        let mBankTypeFilter = "Cheque"
        
        if let mBankData = UserDefaults.standard.object(forKey: "BANKDATA") as? NSArray {
            if mBankData.count > 0 {
                for i in mBankData {
                    if let data = i as? NSDictionary {
                        // Add condition to check for BankPaymenttype
                        if "\(data.value(forKey: "BankPaymenttype") ?? "")" == mBankTypeFilter {
                            mBankNames.append("\(data.value(forKey: "name") ?? "")")
                            mBankImage.append("\(data.value(forKey: "PayMethod_logo") ?? "")")
                            mPMId.append("\(data.value(forKey: "id") ?? "")")
                        }
                    }
                }
                
                let dropdown = DropDown()
                dropdown.anchorView = self.mCheqBankName
                dropdown.direction = .bottom
                dropdown.layer.cornerRadius = 15
                dropdown.backgroundColor = .white
                dropdown.bottomOffset = CGPoint(x: 0, y: 50)
                dropdown.width = self.view.frame.width - 32
                dropdown.dataSource = mBankNames
                dropdown.cellNib = UINib(nibName: "Currency", bundle: nil)
                dropdown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
                    guard let cell = cell as? CurrencyCell else { return }
                    cell.mCurrencyImage.downlaodImageFromUrl(urlString: "\(mBankImage[index])")
                }
                
                dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                    self.mChequePaymentId = mPMId[index]
                    self.mCheqBankName.text = item
                    self.mCheqBankImage.downlaodImageFromUrl(urlString: mBankImage[index])
                }
                
                dropdown.show()
            } else {
                CommonClass.showSnackBar(message: "Please add authorised bank!")
            }
        }
        
        
    }
    
    
    @IBAction func mChooseIBBank(_ sender: Any) {
        
        var mBankNames = ["Choose Bank"]
        let mBankTypeFilter = "IB" // Define the filter type
        var mBankImage = ["https://art.gis247.net/assets/images/icon/camera_profile.png"]
        var mPMId = [""]
        
        if let mBankData = UserDefaults.standard.object(forKey: "BANKDATA") as? NSArray {
            if mBankData.count > 0 {
                for i in mBankData {
                    if let data = i as? NSDictionary {
                        // Check if the BankPaymenttype matches "IB"
                        if "\(data.value(forKey: "BankPaymenttype") ?? "")" == mBankTypeFilter {
                            mBankNames.append("\(data.value(forKey: "name") ?? "")")
                            mBankImage.append("\(data.value(forKey: "PayMethod_logo") ?? "")")
                            mPMId.append("\(data.value(forKey: "PaymentMethod") ?? "")")
                            
                            
                        }
                    }
                }
                
                let dropdown = DropDown()
                dropdown.anchorView = self.mCheqBankName
                dropdown.direction = .bottom
                dropdown.layer.cornerRadius = 15
                dropdown.backgroundColor = .white
                dropdown.bottomOffset = CGPoint(x: 0, y: 50)
                dropdown.width = self.view.frame.width - 32
                dropdown.dataSource = mBankNames
                dropdown.cellNib = UINib(nibName: "Currency", bundle: nil)
                dropdown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
                    guard let cell = cell as? CurrencyCell else { return }
                    cell.mCurrencyImage.downlaodImageFromUrl(urlString: "\(mBankImage[index])")
                }
                
                dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                    self.mChequePaymentId = mPMId[index]
                    self.mSelectIBBank.text = item
                    self.mSelectIBBankImage.downlaodImageFromUrl(urlString: mBankImage[index])
                }
                
                dropdown.show()
            } else {
                CommonClass.showSnackBar(message: "Please add authorised bank!")
            }
        }
        
        
    }
    
    
    
    
    @IBAction func mSubmitCheque(_ sender: UIButton) {
        sender.showAnimation{}
        
        if mChequeAmount.text == "" || (Double(mChequeAmount.text ?? "") ?? 0.0) == 0 {
            CommonClass.showSnackBar(message: "Please fill amount!")
        }
        else if mCheqDate.text == "" {
            CommonClass.showSnackBar(message: "Please choose date!")
            
        }else if mCheqAccountNumber.text == "" {
            CommonClass.showSnackBar(message: "Please fill account number!")
            
        }else if mCheqAccountName.text == "" {
            CommonClass.showSnackBar(message: "Please fill acoount holder name!")
            
        }else if mCheqBankName.text == "Choose Bank" {
            CommonClass.showSnackBar(message: "Please choose bank name!")
            
        }else if mCheqRefNumber.text == "" {
            CommonClass.showSnackBar(message: "Please fill reference number!")
            
        }else if mCheqInstNumber.text == "" {
            CommonClass.showSnackBar(message: "Please fill Inst number!")
            
        }else{
            
            if let balanceDue = mBALANCEDUE.text {
                let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
                let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
                let inputAmount = Double(mChequeAmount.text ?? "") ?? 0.0
                if (balanceDueInDouble - inputAmount) < 0 {
                    CommonClass.showSnackBar(message: "Please fill valid amount!")
                    return
                }
            }
            
            //PAYMENTMETHODID
            mChequeData = NSMutableDictionary()
            mChequeData.setValue(mCheqDate.text ?? "", forKey: "transaction_date")
            mChequeData.setValue(mCheqAccountNumber.text ?? "", forKey: "ac_no")
            mChequeData.setValue(mCheqAccountName.text ?? "", forKey: "ac_name")
            mChequeData.setValue(mChequePaymentId, forKey: "payment_method_id")
            mChequeData.setValue(mCheqRefNumber.text ?? "", forKey: "ref_no")
            mChequeData.setValue(mCheqInstNumber.text ?? "", forKey: "inst_no")
            mChequeData.setValue(mChequeAmount.text ?? "", forKey: "amount")
            mChequeData.setValue(mClientReferenceID, forKey: "client_reference_id")
            mChequeData.setValue("Bank", forKey: "Paymentmethod_type")
            
            self.mBankPayment.add(mChequeData)
            
            
            
            var mAmounts = [Double]()
            for i in mBankPayment {
                let mData = i as? NSDictionary
                mAmounts.append(Double("\(mData?.value(forKey: "amount") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00)
            }
            
            mSubmittedBankAmount.text = "\(mAmounts.reduce(0, {$0 + $1}))"
            
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.00
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.00
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.00
            let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.00
            
            let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            
            self.mCheqDate.text = ""
            self.mCheqAccountNumber.text = ""
            self.mCheqAccountName.text = ""
            self.mChequePaymentId = ""
            mCheqBankName.text = "Choose Bank"
            self.mCheqRefNumber.text = ""
            
            self.mChequeAmount.text = ""
            self.mCheqInstNumber.text = ""
            CommonClass.showSnackBar(message: "Amount added successfully")
            
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return mCreditNoteData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        guard let cells = tableView.dequeueReusableCell(withIdentifier: "CreditNoteList") as? CreditNoteList else {
            return UITableViewCell()
        }
        
        if let mData =  mCreditNoteData[indexPath.row] as? NSDictionary {
            
            cells.mType.text = mData.value(forKey: "type") as? String
            cells.mRefNo.text = mData.value(forKey: "Ref_No") as? String
            cells.mDate.text = mData.value(forKey: "date") as? String
            
            cells.mAmount.tag = indexPath.row
            
            if indexPath.row % 2 == 0 {
                cells.mView.backgroundColor = UIColor(named: "themeBackground")
            }else{
                cells.mView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
            }
            
            if mSelectedCustomIndex.contains(indexPath) {
                if let mDataSet = mAmountData[indexPath.row] as? NSDictionary {
                    cells.mAmount.text = "\(mDataSet.value(forKey: "amount") ?? "0.0")"
                }
            }else{
                cells.mAmount.text = "\(mData.value(forKey: "amount") ?? "0.0")"
            }
            
            if mSelectedIndex.contains(indexPath) {
                cells.mCheckImage.image = UIImage(named: "check_item" )
            }else{
                cells.mCheckImage.image = UIImage(named: "uncheck_item" )
            }
            
            cells.layoutSubviews()
        }
        
        return cells
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.dequeueReusableCell(withIdentifier: "CreditNoteList") as? CreditNoteList
        if mOrderType == "pos_order" {
            let mData = mCreditNoteData[indexPath.row] as? NSDictionary
            if mSelectedIndex.contains(indexPath) {
                mSelectedIndex = mSelectedIndex.filter {$0 != indexPath }
            }else{
                mSelectedIndex.append(indexPath)
            }
            
            self.mGetTotalAmount()
            self.mCreditNoteTable.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    @IBAction func mAmountEdit(_ sender: UITextField) {
        
        if let mMaxData = mCreditNoteData[sender.tag] as? NSDictionary {
            let mMaxAmount = Double("\(mMaxData.value(forKey: "amount") ?? "0.0")") ?? 0
            if sender.text == ""  {
                mAddCreditAmount(text: "0", index: sender.tag)
                return
            }
            
            if (Double("\(sender.text ?? "")") ?? 0) > mMaxAmount   {
                sender.text = "\(mMaxData.value(forKey: "amount") ?? "0.0")"
                mAddCreditAmount(text: sender.text ?? "", index: sender.tag)
            }else{
                mAddCreditAmount(text: sender.text ?? "", index: sender.tag)
            }
        }
    }
    
    func mAddCreditAmount(text : String , index : Int ){
        
        let mIndexPath = IndexPath(row:index,section: 0)
        
        let mData = NSMutableDictionary()
        mData.setValue(text, forKey: "amount")
        mAmountData.removeObject(at: index)
        mAmountData.insert(mData, at:  index)
        
        if self.mSelectedCustomIndex.contains(mIndexPath) {
            self.mSelectedCustomIndex = mSelectedCustomIndex.filter {$0 != mIndexPath }
            self.mSelectedCustomIndex.append(mIndexPath)
            
        }else{
            
            self.mSelectedCustomIndex.append(mIndexPath)
            
        }
        
        mGetTotalAmount()
    }
    
    func mGetTotalAmount(){
        var mAmount = [Double]()
        var indexPath = IndexPath()
        mCreditData = NSMutableArray()
        mCreditDataMerged = NSMutableArray()
        mGiftCardMethod =  NSMutableArray()
        for index in 0...mAmountData.count - 1 {
            indexPath = IndexPath(row:index,section: 0)
            if mSelectedIndex.contains(indexPath){
                if let mData = mAmountData[index] as? NSDictionary {
                    
                    mAmount.append(Double("\(mData.value(forKey: "amount") ?? "0.0")") ?? 0)
                    let mMaxData = mCreditNoteData[index] as? NSDictionary
                    
                    let mCData = NSMutableDictionary()
                    mCData.setValue("\(mData.value(forKey: "amount") ?? "0.0")", forKey: "amount")
                    mCData.setValue("\(mMaxData?.value(forKey: "id") ?? "")", forKey: "payment_method_id")
                    
                    
                    mCreditData.add(mCData)
                    mCreditDataMerged.add(mCData)
                }
            }
            
            
        }
        
        if mSelectedIndex.count == 1 {
            mItemsSelected.text = "\(mSelectedIndex.count) " + "Item Selected".localizedString
            
        }else if mSelectedIndex.count == 0 {
            mItemsSelected.text = "0 " + "Item Selected".localizedString
        }else {
            mItemsSelected.text = "\(mSelectedIndex.count) " +  "Items Selected".localizedString
        }
        
        mTotalSelectedAmount.text = String(format:"%.02f",locale:Locale.current,mAmount.reduce(0, {$0 + $1}))
        
        self.mSubmittedCreditNote.text = mTotalSelectedAmount.text?.replacingOccurrences(of: ",", with: "")
        
        
        let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
        let submittedCash = Double(mSubmittedCash.text ?? "") ?? 0.0
        let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.0
        let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.0
        let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.0
        
        let mTotalValue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
        
        self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        
    }
    
    
    
    
    @IBAction func mSubmitCredit(_ sender: Any) {
        
        mGetTotalAmount()
    }
    
    
    
    @IBAction func mBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func mAddCustomer(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "RegisterCustomer") as? RegisterCustomer {
            self.navigationController?.pushViewController(home, animated:true)
        }
    }
    
    
    @IBAction func mBackCreditCardForm(_ sender: Any) {
        self.mCreditCardBanksView.isHidden = false
        self.mStripeCardView.isHidden = true
        
    }
    @IBAction func mCreditCard(_ sender: Any) {
        
        mTabBarContainer.isHidden = true
        mSelectPaymentOptionContainer.isHidden = true
        guard mOrderType != "refund_order" else {
            return
        }
        mTransactionType = "CreditCard"
        mTaxInfoView.isHidden = true
        mKeyBoardView.isHidden = true
        mChequeDetailsView.isHidden = true
        mCreditCardView.isHidden = true
        mCreditNoteDetailsView.isHidden = true
        mEditCashView.isHidden = true
        self.mCreditCardPaymentView.isHidden = false
        self.mCreditCardBanksView.isHidden = false
        self.mStripeCardView.isHidden = true
        
        mCardView.backgroundColor = .clear
        mCashView.backgroundColor = UIColor(named: "themeShades")
        mBankView.backgroundColor = UIColor(named: "themeShades")
        mCreditNoteView.backgroundColor = UIColor(named: "themeShades")
        
        self.mCashLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditCardLABEL.textColor = UIColor(named:"themeColor")
        self.mBankLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditNoteLABEL.textColor = UIColor(named:"theme6A")
        self.mCashIcon.image = UIImage(named: "cashgrey_ic")
        self.mCreditNoteIcon.image = UIImage(named: "creditnotegrey_ic")
        self.mCreditCardIcon.image = UIImage(named: "cardGreen")
        self.mBankIcon.image = UIImage(named: "bankgrey_ic")
        self.mCreditCardIcon.showAnimation {}
        self.mCreditCardLABEL.showAnimation {}
    }
    @IBAction func mCash(_ sender: Any) {
        mTabBarContainer.isHidden = true
        mSelectPaymentOptionContainer.isHidden = true
        mTransactionType = "Cash"
        mChequeDetailsView.isHidden = true
        mTaxInfoView.isHidden = true
        mKeyBoardView.isHidden = false
        mCreditCardView.isHidden = true
        mEditCashView.isHidden = false
        mCreditNoteDetailsView.isHidden = true
        self.mCreditCardPaymentView.isHidden = true
        
        mCashView.backgroundColor = .clear
        mCardView.backgroundColor = UIColor(named: "themeShades")
        mBankView.backgroundColor = UIColor(named: "themeShades")
        mCreditNoteView.backgroundColor = UIColor(named: "themeShades")
        self.mCashLABEL.textColor = UIColor(named:"themeColor")
        self.mCreditCardLABEL.textColor = UIColor(named:"theme6A")
        self.mBankLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditNoteLABEL.textColor = UIColor(named:"theme6A")
        self.mCashIcon.image = UIImage(named: "cashGreen")
        self.mCreditNoteIcon.image = UIImage(named: "creditnotegrey_ic")
        self.mCreditCardIcon.image = UIImage(named: "card_grey_ic")
        self.mBankIcon.image = UIImage(named: "bankgrey_ic")
        self.mCashIcon.showAnimation {}
        self.mCashLABEL.showAnimation {}
    }
    
    @IBAction func mBank(_ sender: Any) {
        
        mChequeDetailsView.isHidden = true
        mIBSelect.isSelected = true
        mChequeSelect.isSelected = false
        mTabBarContainer.isHidden = false
        mSelectPaymentOptionContainer.isHidden = false
        mSelectedTabIB.backgroundColor = UIColor(named: "themeColor")
        mSelectedTabCheque.backgroundColor = UIColor(named: "themeExtraLightText")
        
        
        mTransactionType = "Bank"
        mCreditNoteDetailsView.isHidden = true
        mTaxInfoView.isHidden = true
        mKeyBoardView.isHidden = true
        mCreditCardView.isHidden = true
        mEditCashView.isHidden = true
        self.mCreditCardPaymentView.isHidden = true
        mBankView.backgroundColor = .clear
        mCardView.backgroundColor = UIColor(named: "themeShades")
        mCashView.backgroundColor = UIColor(named: "themeShades")
        mCreditNoteView.backgroundColor = UIColor(named: "themeShades")
        self.mCashLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditCardLABEL.textColor = UIColor(named:"theme6A")
        self.mBankLABEL.textColor = UIColor(named:"themeColor")
        self.mCreditNoteLABEL.textColor = UIColor(named:"theme6A")
        self.mCashIcon.image = UIImage(named: "cashgrey_ic")
        self.mCreditNoteIcon.image = UIImage(named: "creditnotegrey_ic")
        self.mCreditCardIcon.image = UIImage(named: "card_grey_ic")
        self.mBankIcon.image = UIImage(named: "bankGreen")
        self.mBankIcon.showAnimation {}
        self.mBankLABEL.showAnimation {}
    }
    
    @IBAction func mCreditNot(_ sender: Any) {
        mTabBarContainer.isHidden = true
        mSelectPaymentOptionContainer.isHidden = true
        guard mOrderType != "refund_order" else {
            return
        }
        mTransactionType = "CreditNote"
        mCreditNoteDetailsView.isHidden = false
        mTaxInfoView.isHidden = true
        mChequeDetailsView.isHidden = true
        mKeyBoardView.isHidden = true
        mCreditCardView.isHidden = true
        mEditCashView.isHidden = true
        self.mCreditCardPaymentView.isHidden = true
        mCreditNoteView.backgroundColor = .clear
        mCardView.backgroundColor = UIColor(named: "themeShades")
        mCashView.backgroundColor = UIColor(named: "themeShades")
        mBankView.backgroundColor = UIColor(named: "themeShades")
        self.mCashLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditCardLABEL.textColor = UIColor(named:"theme6A")
        self.mBankLABEL.textColor = UIColor(named:"theme6A")
        self.mCreditNoteLABEL.textColor = UIColor(named:"themeColor")
        self.mCashIcon.image = UIImage(named: "cashgrey_ic")
        self.mCreditNoteIcon.image = UIImage(named: "creditNoteGreen")
        self.mCreditCardIcon.image = UIImage(named: "card_grey_ic")
        self.mBankIcon.image = UIImage(named: "bankgrey_ic")
        self.mCreditNoteIcon.showAnimation {}
        self.mCreditNoteLABEL.showAnimation {}
    }
    
    @IBAction func mTax(_ sender: Any) {
        mTaxInfoView.isHidden = false
        mKeyBoardView.isHidden = true
        mCreditCardView.isHidden = true
        mEditCashView.isHidden = true
        mChequeDetailsView.isHidden = true
        mCreditNoteDetailsView.isHidden = true
        mCardView.layer.sublayers?.remove(at: 0)
        mCashView.layer.sublayers?.remove(at: 0)
        mBankView.layer.sublayers?.remove(at: 0)
        mCreditNoteView.layer.sublayers?.remove(at: 0)
        
    }
    
    
    
    
    
    @IBAction func mVisa(_ sender: Any) {
        mVisaView.backgroundColor = .clear
        mApplePayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mVisaView.borderColor = #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        mApplePayView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        mCreditCardLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        mApplePayLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mAliPayLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mWeChatPayLabel.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        self.mCreditCardPaymentView.isHidden = false
        
        
        
    }
    
    
    
    @IBAction func mApplePay(_ sender: Any) {
        
        mVisaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.backgroundColor = .clear
        mAliPayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mVisaView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.borderColor = #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        mAliPayView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        mCreditCardLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mApplePayLabel.textColor =  #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        mAliPayLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mWeChatPayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    @IBAction func mAliPay(_ sender: Any) {
        
        mVisaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.backgroundColor = .clear
        mWeChatPayView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mVisaView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.borderColor =  #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        mWeChatPayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        mCreditCardLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mApplePayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mAliPayLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        mWeChatPayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func mWeChatPay(_ sender: Any) {
        
        mVisaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.backgroundColor = .clear
        
        mVisaView.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mApplePayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mAliPayView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mWeChatPayView.borderColor = #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
        
        mCreditCardLabel.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mApplePayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mAliPayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mWeChatPayLabel.textColor =  #colorLiteral(red: 0.1333333333, green: 0.5764705882, blue: 0.862745098, alpha: 1)
    }
    
    
    
    
    
    
    @IBAction func mPressOne(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"1")
        
    }
    
    @IBAction func mPressTwo(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"2")
    }
    
    
    @IBAction func mPressThree(_ sender: UIButton) {
        sender.showAnimation{}
        
        mInsertAmount(num:"3")
    }
    
    @IBAction func mPressFour(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"4")
    }
    
    @IBAction func mPressFive(_ sender:UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"5")
    }
    
    @IBAction func mPressSix(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"6")
    }
    @IBAction func mPressSeven(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"7")
    }
    @IBAction func mPressEight(_ sender: UIButton) {
        sender.showAnimation{}
        
        mInsertAmount(num:"8")
    }
    
    @IBAction func mPressNine(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"9")
    }
    
    
    
    @IBAction func mPressSingleZero(_ sender: UIButton) {
        sender.showAnimation{}
        
        mInsertAmount(num:"0")
    }
    
    @IBAction func mPressDoubleZero(_ sender: UIButton) {
        sender.showAnimation{}
        mInsertAmount(num:"00")
    }
    
    @IBAction func mPressDot(_ sender:UIButton) {
        sender.showAnimation{}
        if mCashAmounts != "" {
            mInsertAmount(num:".")
        }
    }
    @IBAction func mSub(_ sender: Any) {
        mSUBLABEL.showAnimation{}
        if mTransactionType == "Cash" {
            
            if let balanceDue = mBALANCEDUE.text {
                let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
                let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
                let inputAmount = Double(mCashAmount.text ?? "0.0") ?? 0.0
                if (balanceDueInDouble - inputAmount) < 0 {
                    CommonClass.showSnackBar(message: "Please fill valid amount!")
                    mConvertedAmounts = "0"
                    return
                }
            }
            
            if (Double(mConvertedAmounts) ?? 0.00) == 0 {
                
                CommonClass.showSnackBar(message: "Please fill valid amount!")
                return
            }
            self.mSubmittedCash.text = "\(mCashAmounts)"
            
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.0
            
            let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            
            CommonClass.showSnackBar(message: "Amount Added Successfully!")
            
        }
        
    }
    
    
    @IBAction func mShowTaxView(_ sender: Any) {
        mTaxCalView.isHidden = !mTaxCalView.isHidden
        
        if mTaxCalView.isHidden {
            mDropDownImage.image = UIImage(systemName: "chevron.right")
        }else{
            mDropDownImage.image = UIImage(systemName: "chevron.up")
            
        }
    }
    @IBAction func mCashAmountField(_ sender: Any) {
        
        
    }
    
    
    @IBAction func mChooseCurrency(_ sender: Any) {
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
            
            self.mCashCurrencyImage.downlaodImageFromUrl(urlString: self.mCurrencyImageData[index])
            if item == self.mStoreCurrency {
                
                self.mExchangeRateLabel.isHidden = true
                self.mExchangeRateValue.isHidden = true
                self.mExchangeRateValue.text = ""
                if mCashAmount.text != "" && mCashAmount.text != "."  {
                    mConvertedAmounts = "\(Double(mCashAmounts) ?? 0)"
                    let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                    mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                }
                
            }else{
                
                self.mExchangeRateValue.text = ""
                self.mExchangeRateValue.isHidden = false
                self.mExchangeRateLabel.isHidden = false
            }
            
            self.mCurrencyName.text = item
            self.mSelectedStoreCurrency = item
            self.mCashCurrencyImage.downlaodImageFromUrl(urlString: self.mCurrencyImageData[index])
            
            self.mExchangeRateValue.text = (index >= 0 && index < mExchangeRateData.count ? mExchangeRateData[index] : "N/A")
            
            mInsertAmount(num: "")
            
        }
        dropdown.show()
        
    }
    
    @IBAction func mExchangeRate(_ sender: UITextField!) {
        
        if sender.text == "" {
            mConvertedAmounts = "0"
            if mCashAmount.text != "" && mCashAmount.text != "."  {
                mConvertedAmounts = "\(Double(mCashAmounts) ?? 0)"
                let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"            }
        }else{
            if mTransactionType == "Cash" {
                if mExchangeRateLabel.isHidden == false {
                    if mExchangeRateValue.text != "" {
                        let mVal = Double(mExchangeRateValue.text ?? "") ?? 0
                        if mCashAmount.text != "" && mCashAmount.text != "."  {
                            mConvertedAmounts = "\((Double(mCashAmounts) ?? 0) * mVal)"
                            let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                            mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                        }
                    }
                }else{
                    if mCashAmount.text != "" && mCashAmount.text != "."  {
                        mConvertedAmounts = "\(Double(mCashAmounts) ?? 0)"
                        let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                        mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func mClear(_ sender: UIButton) {
        sender.showAnimation{}
        
        mCashAmount.text = ""
        mConvertedAmount.text = ""
        mConvertedAmounts = "0"
        mCashAmounts = ""
    }
    
    @IBAction func mDeleteCashAmount(_ sender: Any) {
        if mCashAmounts != "" {
            mCashAmounts.removeLast()
            mCashAmount.text = mCashAmounts
            if mCashAmounts == "" {
                mConvertedAmounts = "0"
                mSubmittedCash.text = "0.0"
                let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
                let convertedAmounts = Double(mConvertedAmounts) ?? 0.0
                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.0
                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.0
                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.0
                
                let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                
                self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            }
            
        }else{
            
            
        }
        if mCashAmounts == "" {
            mConvertedAmounts = "0"
            mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") 00.00"
        }
        if mTransactionType == "Cash" {
            if mExchangeRateLabel.isHidden == false {
                if mExchangeRateValue.text != "" {
                    let mVal = Double(mExchangeRateValue.text ?? "") ?? 0
                    if mCashAmount.text != "" {
                        mConvertedAmounts = "\((Double(mCashAmounts) ?? 0) * mVal)"
                        mConvertedAmount.text = "=  \(self.mCurrencyName.text ?? "") \(mCashAmounts)"
                    }
                }
            }else{
                
                
                if mCashAmounts != "" {
                    mConvertedAmounts = "\(Double(mCashAmounts) ?? 0)"
                    mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mCashAmounts)"
                }
            }
        }
        
        
    }
    func mInsertAmount(num : String){
        
        
        mCashAmounts.insert(contentsOf: num, at: mCashAmounts.endIndex)
        if mCashAmounts.filter({$0 == "."}).count > 1 {
            mCashAmounts.removeLast()
            return
        }
        mCashAmount.text = mCashAmounts
        
        
        
        
        if mTransactionType == "Cash" {
            if mExchangeRateLabel.isHidden == false {
                if mExchangeRateValue.text != "" {
                    let mVal = Double(mExchangeRateValue.text ?? "") ?? 0
                    if mCashAmount.text != "" && mCashAmount.text != "."  {
                        mConvertedAmounts = "\((Double(mCashAmounts) ?? 0) * mVal)"
                        let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                        mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                    }
                }
            }else{
                if mCashAmount.text != "" && mCashAmount.text != "."  {
                    mConvertedAmounts = "\(Double(mCashAmounts) ?? 0)"
                    let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                    mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                }
            }
        }
    }
    
    
    
    
    
    func isProceed(status: Bool) {
        
        if status {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
            if let mVerifyPin = storyBoard.instantiateViewController(withIdentifier: "VerifyPin") as? VerifyPin {
                mVerifyPin.delegate = self
                
                mVerifyPin.modalPresentationStyle = .overFullScreen
                mVerifyPin.transitioningDelegate = self
                self.present(mVerifyPin,animated: false)
            }
        }
    }
    func isVerified(status: Bool) {
        if status {
            
            let mGiftCardMethods = NSMutableDictionary()
            let mBankMethod = NSMutableArray()
            let mChequeMethod = NSMutableDictionary()
            
            mFinalPaymentMethod = [String: Any]()
            let mCashMethod = NSMutableDictionary()
            let mCreditNoteMethod = NSMutableDictionary()
            let mDebitedAmount = NSMutableDictionary()
            let mPayData = NSMutableDictionary()
            let mPaymentInfo = NSMutableDictionary()
            let mSummaryOrder = NSMutableDictionary()
            let mSellInfo = NSMutableDictionary()
            
            
            if let mCashData = UserDefaults.standard.object(forKey: "CASHDATA") as? NSDictionary {
                mCashMethod.setValue("\(mCashData.value(forKey: "id") ?? "")", forKey: "payment_method_id")
                mCashMethod.setValue("cash", forKey: "Paymentmethod_type")
                mCashMethod.setValue(Double(self.mSubmittedCash.text ?? "") ?? 0.00, forKey: "amount")
            }
            
            mDebitedAmount.setValue(Double(self.mSubmittedCash.text ?? "") ?? 0.00, forKey: "cash")
            mDebitedAmount.setValue(Double(self.mSubmittedBankAmount.text ?? "") ?? 0.00, forKey: "bank")
            mDebitedAmount.setValue(Double(self.mSubmittedCreditCard.text ?? "") ?? 0.00, forKey: "credit_card")
            mDebitedAmount.setValue(Double(self.mSubmittedCreditNote.text ?? "") ?? 0.00, forKey: "credit_notes")
            
            mSummaryOrder.setValue(mLabourPoints, forKey: "labour")
            mSummaryOrder.setValue(mShippingPoints, forKey: "shipping")
            mSummaryOrder.setValue(mLoyaltyPoints, forKey: "loyalty_points")
            mSummaryOrder.setValue(mTaxAmount, forKey: "tax_amount")
            mSummaryOrder.setValue(mTaxAmountInt, forKey: "tax_amount_int")
            mSummaryOrder.setValue(mTaxInPercent, forKey: "tax_prect")
            mSummaryOrder.setValue(mTaxTypeIE, forKey: "tax_type")
            mSummaryOrder.setValue(mTaxDiscountAmount, forKey: "discount")
            mSummaryOrder.setValue(mTaxDiscountPercent, forKey: "discount_percent")
            
            mSummaryOrder.setValue(mCustomerId, forKey: "customer_id")
            mSummaryOrder.setValue("", forKey: "sales_person_id")
            
            mSummaryOrder.setValue(Int(mDepositPercents), forKey: "deposit")
            mSummaryOrder.setValue(Double(mTotalP), forKey: "deposit_amount")
            
            var mCreditFinalTotalAmountObj = "0"
            var mAmount = [Double]()
            for item in mCreditData {
                let value = item as? NSDictionary
                mAmount.append(Double("\(value?.value(forKey: "amount") ?? 0.00)") ?? 0.00)
            }
            mCreditFinalTotalAmountObj = "\(mAmount.reduce(0, {$0 + $1}))"
            mCreditNoteMethod.setValue(mCreditData, forKey: "ids")
            mCreditNoteMethod.setValue(Double(mCreditFinalTotalAmountObj) ?? 0.00, forKey: "amount")
            mCreditNoteMethod.setValue("CreditNote", forKey: "Paymentmethod_type")
            
            mPayData.setValue(mCashMethod, forKey: "cash")
            mPayData.setValue(mBankPayment, forKey: "bank")
            mPayData.setValue([], forKey: "IB")
            mPayData.setValue(mCreditCardMethod, forKey: "credit_card")
            mPayData.setValue(mCreditNoteMethod, forKey: "credit_note")
            mPayData.setValue("", forKey: "gift_card")
            
            mSellInfo.setValue(mCartTableData, forKey: "cart")
            mSellInfo.setValue(mSummaryOrder, forKey: "summary_order")
            mSellInfo.setValue(mOrderType, forKey: "status_type")
            mSellInfo.setValue(Double(mCartTotalAmount) ?? 0.00, forKey: "totalamount")
            
            mPaymentInfo.setValue(mDebitedAmount, forKey: "debited_amount")
            mPaymentInfo.setValue(mPayData, forKey: "pay_data")
            mPaymentInfo.setValue(mPayData, forKey: "pay_data")
            mPaymentInfo.setValue("", forKey: "balance_due")
            mPaymentInfo.setValue("", forKey: "balance_deposit")
            
            mFinalPaymentMethod = ["sell_info": mSellInfo, "payment_info":mPaymentInfo,"transaction_date": "","customer_id":self.mCustomerId,"sales_person_id":"","order_type":self.mOrderType , "order_id":self.mOrderId]
            
            if mOrderType == "custom_order" ||  mOrderType == "mix_and_match" || mOrderType == "pos_order" ||  mOrderType == "repair_order" || mOrderType == "gift_card_order" {
                mFinalPaymentMethod["shippingInfo"] = ["billing_address": mSelectedBillingAddress,
                                                       "shipping_address": mSelectedShippingAddress]
            }
            
            if mOrderType == "custom_order" ||  mOrderType == "mix_and_match" || mOrderType == "pos_order" ||  mOrderType == "repair_order" ||  mOrderType == "exchange_order" || mOrderType == "gift_card_order" ||  mOrderType == "refund_order" || mOrderType == "reserve" {
                
                CommonClass.showFullLoader(view: self.view)
                print(mFinalPaymentMethod,"check final response1")
                
                mGetData(url: mFinalCheckoutCustomOrder, headers:sGisHeaders, params: mFinalPaymentMethod) { response , status in
                    
                    CommonClass.stopLoader()
                    if status {
                        if let mCode =  response.value(forKey: "code") as? Int {
                            
                            if mCode == 400 {
                                CommonClass.showSnackBar(message: "\(response.value(forKey: "message") ?? "OOP's something went wrong!")")
                                return
                            }
                        }
                        if let mData = response.value(forKey: "data") as? NSDictionary {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "posBoard", bundle: nil)
                            if let mCompletePayment = storyBoard.instantiateViewController(withIdentifier: "CompletePayment") as? CompletePayment {
                                
                                if self.mOrderType == "refund_order" {
                                    mCompletePayment.mType = self.mOrderType
                                }
                                mCompletePayment.mOrderId = "\(mData.value(forKey: "id") ?? "")"
                                mCompletePayment.mEmailId = "\(mData.value(forKey: "email") ?? "")"
                                mCompletePayment.mTotalQuantity = "\(self.mCartTableData.count)"
                                mCompletePayment.mTotalOutstandingBal = self.mTotalOutstandingAm
                                mCompletePayment.mCurrency = self.mCurrencySymbol
                                mCompletePayment.mDepositPercents = self.mDepositPercents
                                mCompletePayment.mDepositAmount = self.mTotalP
                                mCompletePayment.mGrandTotalAmount = self.mCartTotalAmount
                                mCompletePayment.mUrl = "\(mData.value(forKey: "url") ?? "")"
                                self.navigationController?.pushViewController(mCompletePayment, animated:true)
                            }
                        }
                        
                        
                    }
                }
                
                
                
            }
            
            
            
        }
    }
    @IBAction func mPayNow(_ sender: UIButton) {
        sender.showAnimation{}
        if mOrderType == "refund_order" {
            mPayNowAlert()
            return
        }
        if (Double(mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00) == 0 {
            mPayNowAlert()
        }else{
            CommonClass.showSnackBar(message: "Please enter valid amount!")
        }
        
        
        
    }
    func mPayNowAlert(){
        mConfirmationPopUp.frame = self.view.bounds
        mConfirmationPopUp.delegate = self
        mConfirmationPopUp.mMessage.text = "Are you sure want to proceed ?".localizedString
        
        mConfirmationPopUp.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
        mConfirmationPopUp.mConfirmButton.setTitle("CONFIRM".localizedString, for: .normal)
        
        
        self.view.addSubview(mConfirmationPopUp)
    }
    
    @IBAction func mStartSearch(_ sender: Any) {
        
    }
    @IBAction func mEndSearch(_ sender: Any) {
        
    }
    @IBAction func mEditChanged(_ sender: Any) {
        
        let value = mCustomerSearch.text?.count ?? 0
        if value != 0 {
            
        }else {
            
            if mCustomerSearch.text  == "" {
                mCustomerSearchTableView.removeFromSuperview()
            }
            self.view.endEditing(true)
            
        }
        
        
    }
    @IBAction func mValueChanged(_ sender: UITextField!) {
        
        
    }
    @IBAction func mEditCustSearch(_ sender: Any) {
        
    }
    
    
    @IBAction func mLabourAmount(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "0"
            calculateTax()
        }else{
            calculateTax()
            
        }
    }
    
    
    @IBAction func mShippingAmount(_ sender: UITextField) {
        
        if sender.text == "" {
            sender.text = "0"
            calculateTax()
        }else{
            calculateTax()
            
            
        }
    }
    
    @IBAction func mDiscountPercent(_ sender: UITextField) {
        var mCount = Int()
        if sender.text == "" {
            mCount = 0
        }else{
            mCount = Int(Double(sender.text ?? "") ?? 0)
        }
        if sender.text == "" || sender.text == "0"  || mCount > 100 {
            sender.text = "0"
            self.mDiscountAmounts.text = "0"
            calculateTax()
        }else {
            self.mDiscountAmounts.text = "\(calculatePercentage(value: Double(mTotalAm) ?? 0, percent: Double(sender.text ?? "") ?? 0 ))"
            calculateTax()
        }
    }
    
    @IBAction func mDiscountAmount(_ sender: UITextField) {
        if sender.text == "" {
            
            sender.text = "0"
            self.mDiscountPercents.text = "0"
            
            calculateTax()
        }else{
            
            let mPercent = (Double(sender.text ?? "") ?? 0) / (Double(mTotalAm) ?? 0) * 100
            self.mDiscountPercents.text = String(format: "%.2f", mPercent)
            calculateTax()
            
        }
    }
    
    
    func calculatePercentage(value:Double,percent: Double) -> Double {
        let val = value * percent
        return val/100.00
    }
    func calculateInclusiveTax(value:Double,percent: Double) -> Double {
        
        let val = value * percent
        return val/(100.00 + (Double(mTaxP) ?? 0))
    }
    func calculateExclusiveTax(value:Double,percent: Double) -> Double {
        let val = value * percent
        return val/100.00
    }
    
    func calculateTax(){
        var mAmount =  Double()
        
        var mDiscountA = Double(self.mDiscountAmounts.text ?? "") ?? 0
        var mLabour = Double(self.mLabourCharge.text ?? "") ?? 0
        var mShipping = Double(self.mShippingCharge.text ?? "") ?? 0
        mAmount = mLabour + mShipping
        
        if mTaxType.lowercased() == "inclusive" {
            mTotalDiscountTx.text = mDiscountAmounts.text
            mTotalTx.text = "\((mAmount + (Double(mTotalAm) ?? 0)) )"
            let totalTax = Double(mTotalTx.text ?? "") ?? 0
            let totalDiscount = Double(mDiscountAmounts.text ?? "") ?? 0
            let taxAmountTx = Double(mTaxAmountTx.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0
            mTaxAmountTx.text = String(format:"%.02f",locale:Locale.current,calculateInclusiveTax(value: totalTax - totalDiscount, percent: Double(mTaxP) ?? 0))
            mSubTotalTx.text = String(format:"%.02f",locale:Locale.current,totalTax - totalDiscount - taxAmountTx )
            
            mFinalTaxAmount.text = mTaxAmountTx.text
            mTOTALAMOUNT.text = "\((mAmount + (Double(mTotalAm) ?? 0) - mDiscountA))"
            
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            let submittedCash = Double(mSubmittedCash.text ?? "") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.0
            
            let mTotalValue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }else{
            mTotalDiscountTx.text = mDiscountAmounts.text
            mTotalTx.text = "\((mAmount + (Double(mTotalAm) ?? 0)) )"
            
            let totalTx = Double(mTotalTx.text ?? "") ?? 0.0
            let discountAmounts = Double(mDiscountAmounts.text ?? "") ?? 0.0
            let taxPercent = Double(mTaxP) ?? 0.0
            
            mTaxAmountTx.text = String(format: "%.02f", locale: Locale.current, calculateExclusiveTax(value: totalTx - discountAmounts, percent: taxPercent))
            
            mSubTotalTx.text = String(format:"%.02f",locale:Locale.current, totalTx - discountAmounts)
            mFinalTaxAmount.text = mTaxAmountTx.text
            
            let subTotal = Double(mSubTotalTx.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            let taxAmount = Double(mTaxAmountTx.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            
            mTOTALAMOUNT.text = "\(subTotal + taxAmount)".formatPrice()
            
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
            let submittedCash = Double(mSubmittedCash.text ?? "") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "") ?? 0.0
            
            let balanceDue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
            mBALANCEDUE.text = "\(balanceDue)".formatPrice()
            
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = textField.text
    }
    
    func mFetchCreditNoteData(value: String){
        
        let mLocation = UserDefaults.standard.string(forKey: "location")
        
        let urlPath =  mPOSCreditNote
        let params:[String:Any] = ["customer_id":mCustomerId]
        
        
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:params, encoding: JSONEncoding.default, headers: sGisHeaders).responseJSON
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
                    if jsonResult.value(forKey: "code") as? Int == 200 {
                        self.mCreditNoteData = NSMutableArray()
                        
                        if let mData = jsonResult.value(forKey: "data") as? NSArray {
                            
                            self.mCreditNoteData = NSMutableArray(array: mData)
                            self.mCreditNoteTable.delegate = self
                            self.mCreditNoteTable.dataSource = self
                            self.mCreditNoteTable.reloadData()
                            var mAmount = [Double]()
                            for item in mData {
                                let value = item as? NSDictionary
                                let mCData = NSMutableDictionary()
                                
                                mAmount.append(Double("\(value?.value(forKey: "amount") ?? "0")") ?? 0)
                                
                                mCData.setValue("\(value?.value(forKey: "amount") ?? "0")", forKey: "amount")
                                self.mTotalCreditAmount.text = String(format:"%.02f",locale:Locale.current,mAmount.reduce(0, {$0 + $1}))
                                
                                self.mAmountData.add(mCData)
                            }
                            
                        }
                    }else{
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
    
    func PayNow(){
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        var urlPath =  ""
        let mSalesPersonId =  UserDefaults.standard.string(forKey: "SALESPERSONID")
        let mCustomerId =  UserDefaults.standard.string(forKey: "CUSTOMERID")
        let mCustomerName =  UserDefaults.standard.string(forKey: "CUSTOMERNAME")
        let mLocation = UserDefaults.standard.string(forKey: "location")
        
        var params = [String:Any]()
        if mOrderType == "Sales Order" {
            
            urlPath =  mPOSpay
            params = ["Customer_name":mCustomerName ?? "",
                      "tax_rate":self.mTaxVal.text ?? "",
                      "tax_type":self.mTaxType,
                      "tax_label":self.mTaxLabel,
                      "taxAmount":self.mTaxAmountTx.text ?? "",
                      "tableToptotalRowAmount":self.mTotalWithDiscount,
                      "location_id":mLocation ?? "",
                      "totalAmountsat_data":self.mTotalTx.text ?? "",
                      "totalDiscountsata":self.mTotalDiscountTx.text ?? "",
                      "SubtotalAmountsat_data":self.mSubTotalTx.text ?? "",
                      "taxAmount_value":self.mTaxAmountTx.text ?? "",
                      "finaltotalAmountsat_data":self.mTOTALAMOUNT.text ?? "",
                      "pos_Labourdata":self.mLabourCharge.text ?? "",
                      "pos_Shippingdata":self.mShippingCharge.text ?? "",
                      
                      "POS_Final_Cash_Amount_value":self.mSubmittedCash.text ?? "",
                      "POS_Final_CreditCardAmount_value":self.mSubmittedCreditCard.text ?? "",
                      "POS_Final_Bank_Amount_value":self.mSubmittedBankAmount.text ?? "" ,
                      "POS_Final_bank_Payment_cheque_information_json": self.mChequeData,
                      
                      "paymentMethodId":self.mFinalPaymentMethod,
                      "couponAmount":self.mGiftFinalTotalAmount,
                      
                      "POS_Final_CreditNote_Amount_value":"",
                      "POS_Final_CreditNote_Amount_arr": self.mCreditDataMerged,
                      "POS_Final_CreditNote_Amount":"\(self.mSubmittedCreditNote.text ?? "")",
                      
                      "finalAmountsat_side_DueAmount":self.mBALANCEDUE.text ?? "",
                      "salesPersonId":mSalesPersonId ?? "",
                      "Customer_id":mCustomerId ?? "",
                      "Order_type":"Sales Order",
                      "Remark":"",
                      "cartTableData":self.mCartTableData ]
            
            
        }else if mOrderType == "custom_oreder" {
            urlPath =  mPOSpay
            params = ["Customer_name":mCustomerName,
                      "tax_rate":"",
                      "tax_type":"",
                      "tax_label":"",
                      "taxAmount":"",
                      "tableToptotalRowAmount":self.mTotalWithDiscount,
                      "location_id":mLocation ?? "",
                      "totalAmountsat_data":"",
                      "totalDiscountsata":"",
                      "SubtotalAmountsat_data":"",
                      "taxAmount_value":"",
                      "finaltotalAmountsat_data":self.mTOTALAMOUNT.text ?? "",
                      "pos_Labourdata":"",
                      "pos_Shippingdata":"",
                      "POS_Final_Cash_Amount_value":self.mSubmittedCash.text ?? "",
                      "POS_Final_CreditCardAmount_value":self.mSubmittedCreditCard.text  ?? "",
                      
                      "POS_Final_Bank_Amount_value":self.mSubmittedBankAmount.text ?? "",
                      
                      "POS_Final_bank_Payment_cheque_information_json": self.mChequeData,
                      "paymentMethodId":self.mFinalPaymentMethod,
                      
                      "POS_Final_CreditNote_Amount_value":"",
                      
                      "finalAmountsat_side_DueAmount":self.mBALANCEDUE.text ?? "",
                      "salesPersonId":mSalesPersonId ?? "",
                      "Customer_id":mCustomerId ?? "",
                      "Order_type":"Custom Order",
                      "Remark":self.mRemark,
                      "cartTableData":self.mCartTableData]
            
        }else if self.mOrderType == "Repair Order" {
            urlPath =  mSubmitRepairDesign
            
            params = [
                "POS_Location_id":mLocation ?? "",
                "totalAmount":self.mTOTALAMOUNT.text ?? "",
                "cash_amount":self.mSubmittedCash.text ?? "",
                "creditCard_amount":"",
                "bank_amount":"",
                "dueAmount":self.mBALANCEDUE.text ?? "",
                "salesPerson_id":mSalesPersonId ?? "",
                "CustomerID":mCustomerId ?? "",
                "POS_Final_CreditCardAmount_value":self.mSubmittedCreditCard.text ?? "",
                "POS_Final_Bank_Amount_value":self.mSubmittedBankAmount.text ?? "",
                "POS_Final_bank_Payment_cheque_information_json": self.mChequeData,
                "paymentMethodId":self.mFinalPaymentMethod,
                "Remark":self.mRemark,
                "repair_cart_data":self.mCartTableData ]
            
        }
        
        if "\(UserDefaults.standard.string(forKey: "isPinEnable") ?? "")" == "1" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let mPin = storyBoard.instantiateViewController(withIdentifier: "LoginWithPin") as? LoginWithPin {
                mPin.mKey = "1"
                mPin.mParams = params
                mPin.mUrl = urlPath
                if self.mOrderType == "Sales Order" {
                    mPin.mType = "pos"
                }
                if self.mOrderType == "Custom Order" {
                    mPin.mType = "custom"
                }
                if self.mOrderType == "Repair Order" {
                    mPin.mType = "repair"
                }
                self.navigationController?.pushViewController( mPin, animated:true)
            }
        }else{
            mFinalPay(urlPath: urlPath, params: params)
        }
        
    }
    
    func mFinalPay(urlPath : String , params: [String:Any]){
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:params, encoding :JSONEncoding.default, headers: sGisHeaders).responseJSON
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
                    if jsonResult.value(forKey: "code") as? Int == 200 {
                        let pdfURl = "\(jsonResult.value(forKey: "pdf_url") ?? "")"
                        UserDefaults.standard.setValue(pdfURl, forKey: "reportAPI")
                        self.mGenerateReport(id:pdfURl , jsonResult : jsonResult)
                        
                    }else{
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
    
    func mGenerateReport(id : String, jsonResult : NSDictionary){
        
        CommonClass.showFullLoader(view: self.view)
        
        let urlPath =  id
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:nil, headers: sGisHeaders2).responseJSON
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
                    
                    guard let jsonVal = json as? NSDictionary else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    UserDefaults.standard.set("", forKey: "CUSTOMERID")
                    UserDefaults.standard.set("", forKey: "SALESPERSONID")
                    CommonClass.showSnackBar(message: "Payment Successful")
                    
                    if let email = jsonVal.value(forKey: "email") {
                        UserDefaults.standard.setValue("\(email)", forKey: "mailInvoice")
                    }
                    
                    UserDefaults.standard.setValue(jsonVal.value(forKey: "pdf_url") as? String, forKey: "report")
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    if let mCompletePayment = storyBoard.instantiateViewController(withIdentifier: "CompletePayment") as? CompletePayment {
                        
                        //Sales Order Custom Order Repair Order
                        if self.mOrderType == "Sales Order" {
                            mCompletePayment.mType = "pos"
                        }
                        if self.mOrderType == "Custom Order" {
                            mCompletePayment.mType = "custom"
                        }
                        if self.mOrderType == "Repair Order" {
                            mCompletePayment.mType = "repair"
                        }
                        
                        mCompletePayment.mDue = "\(jsonResult.value(forKey: "DueAmt") ?? "")"
                        mCompletePayment.mTotal = "\(jsonResult.value(forKey: "totalAmt") ?? "")"
                        self.navigationController?.pushViewController(mCompletePayment, animated:true)
                    }
                }
                
                
            }
        }else{
        }
        
        
    }
    
    func mSetupTableView(frame: CGRect) {
        if mCustomerSearch.text != "" {
            let nib = UINib(nibName: "CustomerSearchList", bundle: nil)
            let tableView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
            let mBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height
            let mDisplayWidth: CGFloat = self.view.frame.width
            let mDisplayHeight: CGFloat = self.view.frame.height
            
            mCustomerSearchTableView.frame = CGRect(x: 16, y:frame.origin.y + 200 ,width:self.view.frame.width - 32, height:400)
            mCustomerSearchTableView.cornerRadius = 10
            mCustomerSearchTableView.register(nib, forCellReuseIdentifier: "CustomerSearchItem")
            mCustomerSearchTableView.isHidden = false
            mCustomerSearchTableView.keyboardDismissMode = .onDrag
            self.mCustomerSearchTableView.delegate = self
            self.mCustomerSearchTableView.dataSource = self
            mCustomerSearchTableView.reloadData()
            
            self.view.addSubview(mCustomerSearchTableView)
            mCustomerSearchTableView.tag = 100
            
            mCustomerSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        }else{
            mCustomerSearchTableView.removeFromSuperview()
        }
        
        var constraints: [NSLayoutConstraint] = []
        
    }
    
    func mGetCurrency(){
        
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
                        for i in data {
                            if let currency = i as? NSDictionary {
                                self.mCurrencyNameData.append("\(currency.value(forKey:"currency") ?? "")")
                                self.mCurrencyImageData.append("\(currency.value(forKey:"url") ?? "")")
                                self.mExchangeRateData.append("\(currency.value(forKey:"rate") ?? "")")
                                
                                if "\(currency.value(forKey:"currency") ?? "")" == self.mStoreCurrency {
                                    self.mCashCurrencyImage.downlaodImageFromUrl(urlString: "\(currency.value(forKey:"url") ?? "")")
                                    self.mCurrencyName.text = self.mStoreCurrency
                                    self.mSelectedStoreCurrency = self.mStoreCurrency
                                    
                                    
                                    if self.mOrderType == "Sales Order" {
                                        self.mTOTALAMOUNT.text = self.mFTOTAL.formatPrice()
                                        self.mBALANCEDUE.text = self.mFTOTAL.formatPrice()
                                    }else{
                                        self.mTOTALAMOUNT.text = self.mTotalP.formatPrice()
                                        self.mBALANCEDUE.text = self.mTotalP.formatPrice()
                                    }
                                }
                            }
                            self.mTOTALAMOUNT.text = self.mTotalP.formatPrice()
                            self.mBALANCEDUE.text = self.mTotalP.formatPrice()
                        }
                    }
                }
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
    
    // MARK: Generate QR Code -:
    
    func mGenerateQRCode() {
        let urlPath = mGetQRCode
        let mParams: [String: Any] = [
            "payment_id": mChequePaymentId,
            "amount": mEnterAmountText.text ?? "0",
            "customerId": mCustomerId
        ]
        
        print(mParams, "check data")
        
        if Reachability.isConnectedToNetwork() {
            AF.request(urlPath, method: .post, parameters: mParams, headers: sGisHeaders2).responseJSON { response in
                print(response, "check response")
                
                switch response.result {
                case .success(let value):
                    // Ensure the response is a dictionary
                    guard let json = value as? [String: Any] else {
                        CommonClass.showSnackBar(message: "Failed to parse response.")
                        return
                    }
                    
                    if let code = json["code"] as? Int, code == 200,
                       let data = json["data"] as? [String: Any] {
                        
                        // Extract client reference ID from `data`
                        self.mClientReferenceID = data["client_reference_id"] as? String ?? ""
                        print(self.mClientReferenceID, "client reference ID")
                        
                        // Decode Base64-encoded QR code string
                        if let qrCodeString = data["qrCode"] as? String,
                           let base64String = qrCodeString.components(separatedBy: ",").last,
                           let qrCodeData = Data(base64Encoded: base64String),
                           let qrCodeImage = UIImage(data: qrCodeData) {
                            
                            print("Successfully decoded QR Code image.")
                            
                            DispatchQueue.main.async {
                                self.qrCodeView.removeFromSuperview()
                                self.qrCodeView.delegate = self
                                self.qrCodeView.mQRImage.image = qrCodeImage
                                self.view.addSubview(self.qrCodeView)
                                self.qrCodeView.startTimer()
                                self.mGetPayementStatus()
                            }
                        } else {
                            CommonClass.showSnackBar(message: "Failed to decode QR code.")
                        }
                    } else {
                        let message = json["message"] as? String ?? "Oops, something went wrong!"
                        CommonClass.showSnackBar(message: message)
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    CommonClass.showSnackBar(message: error.localizedDescription)
                }
            }
        } else {
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
    }
    
    
    
    
    
    // Mark:- Stripe Calling Function -:
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    
    func StripePayment() {
        // Configure Stripe with the publishable key
        StripeManager.shared.configureStripe(publishableKey: mStripPublishKey)
        StripeManager.shared.fetchPaymentIntentDetails(clientSecret: self.mClientSecreat)
        
        print("Client Secret: \(mClientSecreat), Publishable Key: \(mStripPublishKey)")
        
        // Configure the PaymentSheet
        var configuration = PaymentSheet.Configuration()
        
        // Create the PaymentSheet instance using the provided client secret
        let paymentSheet = PaymentSheet(paymentIntentClientSecret: mClientSecreat, configuration: configuration)
        
        // Present the PaymentSheet UI
        paymentSheet.present(from: self) { paymentResult in
            DispatchQueue.main.async {
                switch paymentResult {
                case .completed:
                    
                    if let paymentSuccessView = PaymentSuccessView.loadFromNib() {
                        paymentSuccessView.frame = self.view.bounds
                        paymentSuccessView.setAmount("Amount: \(self.mCreditFillAmount.text ?? "")")
                        
                        if let successImage = UIImage(named: "successAmount") {
                            paymentSuccessView.setImage(successImage)
                        }
                        
                        self.view.addSubview(paymentSuccessView)
                    }
                    
                    self.mStripeCardView.isHidden = true
                    self.mCreditCardBanksView.isHidden = false
                    
                    
                    CommonClass.showSnackBar(message: "Amount added successfully")
                    let mCreditCardData = NSMutableDictionary()
                    
                    mCreditCardData.setValue(self.mCreditCardName, forKey: "name")
                    mCreditCardData.setValue(self.mCardNumber.text ?? "", forKey: "card_number")
                    mCreditCardData.setValue(self.mCardName.text ?? "", forKey: "card_name")
                    mCreditCardData.setValue(self.mCreditCardPaymentId, forKey: "payment_method_id")
                    mCreditCardData.setValue(self.mCreditCardLogo, forKey: "logo")
                    mCreditCardData.setValue(self.mCreditFillAmount.text ?? "", forKey: "amount")
                    mCreditCardData.setValue("Credit_Card", forKey: "Paymentmethod_type")
                    mCreditCardData.setValue(self.mClientReferenceID, forKey: "client_reference_id")
                    
                    
                    self.mCreditCardMethod.add(mCreditCardData)
                    
                    var mAmounts = [Double]()
                    for i in self.mCreditCardMethod {
                        if let mData = i as? NSDictionary,
                           let amount = mData.value(forKey: "amount") {
                            let amountUnformatted = "\(amount)".replacingOccurrences(of: ",", with: "")
                            mAmounts.append(Double(amountUnformatted) ?? 0.00)
                        }
                    }
                    
                    self.mSubmittedCreditCard.text = "\(mAmounts.reduce(0, {$0 + $1}))"
                    
                    let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.0
                    let submittedCash = Double(self.mSubmittedCash.text ?? "") ?? 0.0
                    let submittedCreditNote = Double(self.mSubmittedCreditNote.text ?? "") ?? 0.0
                    let submittedBankAmount = Double(self.mSubmittedBankAmount.text ?? "") ?? 0.0
                    let submittedCreditCard = Double(self.mSubmittedCreditCard.text ?? "") ?? 0.0
                    
                    let mTotalValue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
                    
                    self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                    
                    self.mCreditCardLogo = ""
                    self.mCreditCardName = ""
                    self.mCreditCardPaymentId = ""
                    self.mCardNumber.text = ""
                    self.mCardName.text = ""
                    self.mCreditFillAmount.text = ""
                    
                    
                case .failed(let error):
                    
                    if let paymentSuccessView = PaymentSuccessView.loadFromNib() {
                        paymentSuccessView.frame = self.view.bounds
                        
                        paymentSuccessView.mSetAmountStatus("Payment Failed")
                        
                        if let successImage = UIImage(named: "AmountFailed") {
                            paymentSuccessView.setImage(successImage)
                        }
                        
                        self.view.addSubview(paymentSuccessView)
                    }
                    
                    StripeManager.shared.fetchPaymentIntentDetails(clientSecret: self.mClientSecreat)
                case .canceled:
                    
                    if let paymentSuccessView = PaymentSuccessView.loadFromNib() {
                        paymentSuccessView.frame = self.view.bounds
                        
                        paymentSuccessView.mSetAmountStatus("Payment Failed")
                        
                        if let successImage = UIImage(named: "AmountFailed") {
                            paymentSuccessView.setImage(successImage)
                        }
                        
                        self.view.addSubview(paymentSuccessView)
                    }
                }
            }
        }
    }
    
    
    
    //  MARK: Delegate method to handle cancel button action
    func didTapCancelQRCode() {
        mCancelQRCode()
    }
    
    
    // MARK: Cancel  QR Code Api -:
    
    func mCancelQRCode() {
        let urlPath = mCancelQR
        let mParams: [String: Any] = [
            "client_reference_id": mClientReferenceID
        ]
        
        guard Reachability.isConnectedToNetwork() else {
            CommonClass.showSnackBar(message: "No Internet Connection")
            return
        }
        
        AF.request(urlPath, method: .post, parameters: mParams, headers: sGisHeaders2).responseJSON { response in
            print("Response: \(response)")
            
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "Oops, something went wrong!")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        if let code = json["code"] as? Int, code == 200 {
                            let message = json["message"] as? String ?? ""
                            CommonClass.showSnackBar(message: message)
                            
                            self.isQRCodeDeleted = true // Stop polling when QR code is deleted
                        } else {
                            let errorMessage = json["message"] as? String ?? "Invalid response format."
                            CommonClass.showSnackBar(message: errorMessage)
                        }
                    } else {
                        CommonClass.showSnackBar(message: "Invalid response format.")
                    }
                } catch {
                    CommonClass.showSnackBar(message: "Failed to parse response.")
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                CommonClass.showSnackBar(message: "Oops, something went wrong!")
            }
        }
    }
    
    // Mark-: Get Strip data from Back End Api -:
    
    func mGetStripeDataBackEnd() {
        
        guard let creditFillAmountText = self.mCreditFillAmount.text, !creditFillAmountText.isEmpty, let creditFillAmount = Double(creditFillAmountText), creditFillAmount != 0 else {
            CommonClass.showSnackBar(message: "Please fill valid amount")
            return
        }
        
        
        let urlPath = mGetStipData
        let mParams: [String: Any] = [
            "amount":self.mCreditFillAmount.text ?? 0,
            "slug": self.mSelectdPaymentMethod,
            "PaymentMethod": mPaymentMethod,
            "customer_id": mCustomerId
        ]
        print(mParams,"check 1")
        guard Reachability.isConnectedToNetwork() else {
            CommonClass.showSnackBar(message: "No Internet Connection")
            return
        }
        
        AF.request(urlPath, method: .post, parameters: mParams, headers: sGisHeaders2).responseJSON { response in
            print("Response: \(response)")
            
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        if let code = json["code"] as? Int, code == 200 {
                            if let data = json["data"] as? [String: Any],
                               let clientSecret = data["clientSecret"] as? String,
                               let clientRefID = data["client_reference_id"] as? String,
                               let paymentIntentId = data["payment_intent_id"] as? String {
                                self.mClientSecreat = clientSecret
                                print(clientSecret,"check data")
                                self.mPaymentIntentID = paymentIntentId
                                self.mClientReferenceID = clientRefID
                                print("Payment Intent ID: \(paymentIntentId)")
                                print("Client Secret123: \(clientSecret)")
                                print("Client Secret123555: \(self.mClientReferenceID)")
                                
                                // Mark: check Enter Amount  Valid or not According to Due Amount -:
                                
                                if let balanceDue = self.mBALANCEDUE.text {
                                    let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
                                    let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
                                    let inputAmount = Double(self.mCreditFillAmount.text ?? "") ?? 0.0
                                    
                                    if inputAmount <= balanceDueInDouble {
                                        // Call StripePayment if input amount is less than due amount
                                        self.StripePayment()
                                    } else {
                                        CommonClass.showSnackBar(message: "Please fill a valid amount!")
                                        return
                                    }
                                }
                                
                                
                                
                            } else {
                                let errorMessage = json["message"] as? String ?? "Invalid response format."
                                CommonClass.showSnackBar(message: errorMessage)
                            }
                        } else {
                            let errorMessage = json["message"] as? String ?? "Invalid response format."
                            CommonClass.showSnackBar(message: errorMessage)
                        }
                    } else {
                        CommonClass.showSnackBar(message: "Invalid response format.")
                    }
                } catch {
                    CommonClass.showSnackBar(message: "Failed to parse response.")
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                CommonClass.showSnackBar(message: "OOP's something went wrong!")
            }
        }
    }
    
    
    // MARK: Get Payment status Api -:
    
    
    func mGetPayementStatus() {
        
        guard !isQRCodeDeleted else { return }
        
        let urlPath = mGetPaymentStatus
        let mParams: [String: Any] = [
            "transactionId": self.mClientReferenceID
        ]
        
        print(mParams, "check")
        
        guard Reachability.isConnectedToNetwork() else {
            CommonClass.showSnackBar(message: "No Internet Connection")
            return
        }
        
        AF.request(urlPath, method: .post, parameters: mParams, headers: sGisHeaders2).responseJSON { response in
            print("Response: \(response)")
            
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "Oops, something went wrong!")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let code = json["code"] as? Int, code == 200,
                       let data = json["data"] as? [String: Any] {
                        
                        let paymentStatus = data["payment_status"] as? String ?? "pending"
                        let paymentSuccess = data["payment_success"] as? Int ?? 0
                        
                        print("Payment Status: \(paymentStatus), Payment Success: \(paymentSuccess)")
                        
                        let normalizedStatus = paymentStatus.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        
                        if normalizedStatus == "pending" || paymentSuccess == 0 {
                            print("Still pending")
                            CommonClass.showSnackBar(message: "Payment Pending!")
                            
                            // Poll again after 0.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.mGetPayementStatus()
                            }
                        } else if normalizedStatus == "completed" || normalizedStatus == "succeeded" || paymentSuccess == 1 {
                            print("Payment Success: \(normalizedStatus)")
                            
                            if let paymentSuccessView = PaymentSuccessView.loadFromNib() {
                                paymentSuccessView.frame = self.view.bounds
                                paymentSuccessView.setAmount("Amount: \(self.mEnterAmountText.text ?? "")")
                                
                                if let successImage = UIImage(named: "successAmount") {
                                    paymentSuccessView.setImage(successImage)
                                }
                                
                                self.view.addSubview(paymentSuccessView)
                            }
                            
                            self.qrCodeView.isHidden = true
                            if let balanceDue = self.mBALANCEDUE.text {
                                let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
                                let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
                                let inputAmount = Double(self.mEnterAmountText.text ?? "") ?? 0.0
                                if (balanceDueInDouble - inputAmount) < 0 {
                                    CommonClass.showSnackBar(message: "Please fill valid amount!")
                                    return
                                }
                            }
                            
                            //PAYMENTMETHODID
                            self.mChequeData = NSMutableDictionary()
                            self.mChequeData.setValue(self.mCheqDate.text ?? "", forKey: "transaction_date")
                            self.mChequeData.setValue(self.mCheqAccountNumber.text ?? "", forKey: "ac_no")
                            self.mChequeData.setValue(self.mCheqAccountName.text ?? "", forKey: "ac_name")
                            self.mChequeData.setValue(self.mChequePaymentId, forKey: "payment_method_id")
                            self.mChequeData.setValue(self.mCheqRefNumber.text ?? "", forKey: "ref_no")
                            self.mChequeData.setValue(self.mCheqInstNumber.text ?? "", forKey: "inst_no")
                            self.mChequeData.setValue(self.mEnterAmountText.text ?? "", forKey: "amount")
                            self.mChequeData.setValue(self.mClientReferenceID, forKey: "client_reference_id")
                            self.mChequeData.setValue("Bank", forKey: "Paymentmethod_type")
                            
                            self.mBankPayment.add(self.mChequeData)
                            
                            
                            var mAmounts = [Double]()
                            for i in self.mBankPayment {
                                let mData = i as? NSDictionary
                                mAmounts.append(Double("\(mData?.value(forKey: "amount") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00)
                            }
                            
                            self.mSubmittedBankAmount.text = "\(mAmounts.reduce(0, {$0 + $1}))"
                            
                            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00
                            let submittedCreditNote = Double(self.mSubmittedCreditNote.text ?? "") ?? 0.00
                            let submittedBankAmount = Double(self.mSubmittedBankAmount.text ?? "") ?? 0.00
                            let submittedCreditCard = Double(self.mSubmittedCreditCard.text ?? "") ?? 0.00
                            let convertedAmounts = Double(self.mCashAmount.text ?? "0.0") ?? 0.00
                            
                            let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                            
                            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                            
                            self.mCheqDate.text = ""
                            self.mCheqAccountNumber.text = ""
                            self.mCheqAccountName.text = ""
                            self.mChequePaymentId = ""
                            self.mCheqBankName.text = "Choose Bank"
                            self.mCheqRefNumber.text = ""
                            
                            self.mEnterAmountText.text = ""
                            self.mCheqInstNumber.text = ""
                            
                            
                        } else {
                            print("Unexpected status: \(normalizedStatus), retrying...")
                            
                            // Poll again after 0.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                self.mGetPayementStatus()
                            }
                        }
                    } else {
                        CommonClass.showSnackBar(message: "Invalid response format.")
                    }
                } catch {
                    CommonClass.showSnackBar(message: "Failed to parse response.")
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                CommonClass.showSnackBar(message: "Oops, something went wrong!")
            }
        }
    }
    
    
    
    // MARK: Customer Address List
    private var mSelectedBillingAddress: [String : Any] = [:]
    private var mSelectedShippingAddress: [String : Any] = [:]
    private func getCustomerAddressList(){
        
        guard Reachability.isConnectedToNetwork() == true else {
            CommonClass.showSnackBar(message: "Please check your internet connection.")
            return
        }
        
        let params = ["customer_id": mCustomerId] as [String : Any]
        let urlPath =  mGetCustomerAddressList
        
        AF.request(urlPath, method:.post,parameters: params,encoding: JSONEncoding.default, headers: sGisHeaders).responseJSON { response in
            
            guard let jsonData = response.data else {
                CommonClass.showSnackBar(message: "Oops, something went wrong!")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    CommonClass.showSnackBar(message: "Oops, something went wrong!")
                    return
                }
                guard let code = json["code"] as? Int else {
                    CommonClass.showSnackBar(message: "Oops, something went wrong!")
                    return
                }
                
                switch code {
                case 200:
                    if let data = json["data"] as? [String: Any] {
                        if let billingAddressList = data["billing_address"] as? [[String : Any]] {
                            for address in billingAddressList {
                                if let bUDID = UserDefaults.standard.string(forKey: "CustomerBillingAddressUDID"){
                                    if let udid = address["UDID"] as? String, udid == bUDID {
                                        self.mSelectedBillingAddress = address
                                    }
                                } else {
                                    if address["is_default"] as? Int == 1 {
                                        self.mSelectedBillingAddress = address
                                    }
                                }
                            }
                        }
                        if let shippingAddressList = data["shipping_address"] as? [[String : Any]] {
                            for address in shippingAddressList {
                                if let sUDID = UserDefaults.standard.string(forKey: "CustomerShippingAddressUDID") {
                                    if let udid = address["UDID"] as? String, udid == sUDID {
                                        self.mSelectedShippingAddress = address
                                    }
                                } else {
                                    if address["is_default"] as? Int == 1 {
                                        self.mSelectedShippingAddress = address
                                    }
                                }
                            }
                        }
                    }
                case 403:
                    CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                default:
                    let errorMessage = json["message"] as? String ?? "An error occurred."
                    CommonClass.showSnackBar(message: "Error \(code): \(errorMessage)")
                }
            } catch {
                CommonClass.showSnackBar(message: "Oops, something went wrong!")
            }
        }
        
    }
    
}
