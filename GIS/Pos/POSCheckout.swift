//
//  POSCheckout.swift
//  GIS
//
//  Created by Macbook Pro on 07/07/23.
//  Copyright © 2023 Hawkscode. All rights reserved.
//



import UIKit
import Alamofire
import DropDown
import StripePaymentSheet


protocol ConfirmLaybyDelegate {
    func mConfirmLayByPayment(date : String, receiveAmount:String,outstanding:String,noOfReceived:String)
    
}
protocol ConfirmationDelegate {
    func mGetDatePicker()
    func mConfirmPayment(date : String,dateInGMT: Date, receiveAmount:String,outstanding:String,noOfReceived:String)
    
}

let mConfirmQuote = UINib(nibName:"confirmquote",bundle:.main).instantiate(withOwner: nil, options: nil).first as? ConfirmQuote ?? ConfirmQuote()

class ConfirmQuote: UIView {
    var mType = ""
    
    var mNewDate = Date()
    var index = Int()
    var delegate:ConfirmationDelegate? = nil
    
    @IBOutlet weak var mDueDateLABEL: UILabel!
    @IBOutlet weak var mNotes: UITextField!
    @IBOutlet weak var mCurrentDate: UILabel!
    @IBOutlet weak var mHeadingLabel: UILabel!
    @IBOutlet weak var mSubHeading: UILabel!
    @IBOutlet weak var mCreateQuote: UIButton!
    @IBOutlet weak var mCancelButton: UIButton!
    @IBOutlet weak var mDueDate: UITextField!
    
    
    static func instantiate(message: String) -> ConfirmQuote {
        let view: ConfirmQuote = initFromNib()
        return view
    }
    @IBAction func mChooseDate(_ sender: Any) {
        self.delegate?.mGetDatePicker()
    }
    
    @IBAction func mCancel(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    @IBAction func mConfirm(_ sender: Any) {
        self.removeFromSuperview()
        self.delegate?.mConfirmPayment(date: mCurrentDate.text ?? "", dateInGMT: mNewDate, receiveAmount: "", outstanding: "", noOfReceived: mNotes.text ?? "")
        
    }
    
}




let mPaymentConfirmation = UINib(nibName:"paymentconfirmation",bundle:.main).instantiate(withOwner: nil, options: nil).first as? PaymentConfirmation ?? PaymentConfirmation()

class PaymentConfirmation: UIView {
    var mType = ""
    
    
    @IBOutlet weak var mGrandTotal: UILabel!
    
    @IBOutlet weak var mDueDateLABEL: UILabel!
    @IBOutlet weak var mOutstandingLABEL: UILabel!
    @IBOutlet weak var mGrandTotalLABEL: UILabel!
    @IBOutlet weak var mOutstanding: UILabel!
    @IBOutlet weak var mTotalReceived: UILabel!
    var index = Int()
    var delegate:ConfirmationDelegate? = nil
    
    @IBOutlet weak var mCurrentDate: UILabel!
    @IBOutlet weak var mHeadingLabel: UILabel!
    @IBOutlet weak var mReceiveLabel: UILabel!
    @IBOutlet weak var mConfirmButton: UIButton!
    @IBOutlet weak var mCancelButton: UIButton!
    @IBOutlet weak var mDueDate: UITextField!
    
    var mGrandTotalBalance = ""
    var mOutstandingBalance = ""
    
    var mTotalReceivedBalance = ""
    var mNavigation = UINavigationController()
    
    static func instantiate(message: String) -> PaymentConfirmation {
        let view: PaymentConfirmation = initFromNib()
        return view
    }
    @IBAction func mChooseDate(_ sender: Any) {
        self.delegate?.mGetDatePicker()
    }
    
    @IBAction func mCancel(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    @IBAction func mConfirm(_ sender: Any) {
        self.removeFromSuperview()
        if mType == "Repayment" {
            self.delegate?.mConfirmPayment(date: mCurrentDate.text ?? "",dateInGMT: Date(), receiveAmount: mTotalReceivedBalance, outstanding: mOutstandingBalance, noOfReceived: mReceiveLabel.text ?? "")
            return
        }
        self.delegate?.mConfirmPayment(date: mCurrentDate.text ?? "",dateInGMT: Date(), receiveAmount: mTotalReceived.text ?? "", outstanding: mOutstanding.text ?? "", noOfReceived: mReceiveLabel.text ?? "")
        
    }
    
}


class POSCheckout: UIViewController, UITextFieldDelegate , UITableViewDelegate ,UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,GetVerification , ProceedToPay, UIViewControllerTransitioningDelegate, ConfirmationDelegate,FinalInstallmentDelegate, ScannerDelegate, QRCodeViewDelegate {
    func isProceedWithStatus(status: Bool, message: String) {
        
    }
    
    
    @IBOutlet weak var mPartialPaymentView: UIView!
    @IBOutlet weak var mReceiveView: UIStackView!
    
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
    var mExchangeRateData = [String]()
    
    var mCashAmounts = ""
    var mSelectedStoreCurrency = ""
    var mStoreCurrency = ""
    @IBOutlet weak var mEditCashView: UIView!
    @IBOutlet weak var mCashCurrencyImage: UIImageView!
    
    @IBOutlet weak var mCurrencyName: UILabel!
    @IBOutlet weak var mChooseCurrencyButt: UIButton!
    
    @IBOutlet weak var mCashAmount: UITextField!
    
    @IBOutlet weak var mExchangeRateLabel: UILabel!
    
    @IBOutlet weak var mExchangeRateValue: UITextField!
    
    @IBOutlet weak var mConvertedAmount: UILabel!
    var mConvertedAmounts = "0"
    
    var isQRCodeDeleted = false
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
    
    
    
    @IBOutlet weak var mHCheckoutLABEL: UILabel!
    @IBOutlet weak var mCreditCardLABEL: UILabel!
    @IBOutlet weak var mCashLABEL: UILabel!
    @IBOutlet weak var mBankLABEL: UILabel!
    @IBOutlet weak var mCreditNoteLABEL: UILabel!
    @IBOutlet weak var mTaxLABEL: UILabel!
    @IBOutlet weak var mCNTypeLABEL: UILabel!
    @IBOutlet weak var mCNDate: UILabel!
    @IBOutlet weak var mCNRefNoLABEL: UILabel!
    @IBOutlet weak var mCNAmountLABEL: UILabel!
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
    
    @IBOutlet weak var mClearBUTTON: UIButton!
    
    
    @IBOutlet weak var mReceiveAmountLABEL: UILabel!
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
        
        mInstallmentDetailsButton .setTitle("DETAIL".localizedString, for: .normal)
        mApplyGiftBUTTON .setTitle("APPLY".localizedString, for: .normal)
        mGiftCardAmount.placeholder = "Gift Card number".localizedString
        mHCheckoutLABEL.text = "CHECK OUT".localizedString
        mCreditCardLABEL.text = "Credit Card".localizedString
        mReceiveAmountLABEL.text = "Receive Amount".localizedString
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
        mLaybyLabel.text = "LayBy".localizedString
        mFullPaymentLabel.text = "Full Payment".localizedString
        mInstallmentLabel.text = "Installment".localizedString
        
        let isPartial = UserDefaults.standard.bool(forKey: "isPartial")
        self.mPartialPaymentView.isHidden = !isPartial
        
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
    
    
    
    var mLabourPoints = 0.0
    var mShippingPoints = 0.0
    var mLoyaltyPoints = 0.0
    var mTaxAmount = 0.0
    var mTaxAmountInt = 0.0
    var mTaxInPercent = 0.0
    var mTaxDiscountAmount = 0.0
    var mTaxDiscountPercent = 0.0
    
    var mTaxTypeIE = ""
    var mOrderId = ""
    
    
    @IBOutlet weak var mPaymentOptionIcon: UIImageView!
    @IBOutlet weak var mPaymentOptionView: UIView!
    
    @IBOutlet weak var mFullPaymentOptionView: UIView!
    @IBOutlet weak var mFullPaymentLabel: UILabel!
    @IBOutlet weak var mLaybyOptionView: UIView!
    @IBOutlet weak var mLaybyLabel: UILabel!
    @IBOutlet weak var mInstallmentDetailsButton: UIButton!
    @IBOutlet weak var mInstallmentOptionView: UIView!
    @IBOutlet weak var mInstallmentLabel: UILabel!
    @IBOutlet weak var mGCurrency: UILabel!
    @IBOutlet weak var mRCurrency: UILabel!
    @IBOutlet weak var mBCurrency: UILabel!
    @IBOutlet weak var mRECEIVEAMOUNT: UILabel!
    
    @IBOutlet weak var mIBTabSelect: UILabel!
    
    @IBOutlet weak var mChequeTabSelect: UILabel!
    
    
    @IBOutlet weak var mEnterQRAmount: UITextField!
    
    @IBOutlet weak var mSelectedBankName: UITextField!
    
    @IBOutlet weak var mSelectedBankImage: UIImageView!
    
    @IBOutlet weak var mCardNameContainer: UIStackView!
    
    @IBOutlet weak var mSelectPaymentOptionContainer: UIView!
    
    @IBOutlet weak var mIBSelect: UIButton!
    
    @IBOutlet weak var mChequeSelect: UIButton!
    
    @IBOutlet weak var mTabBarContainer: UIView!
    
    @IBOutlet weak var mCardNumberContainer: UIView!
    
    var mPaymentType = "Full_Payment"
    var mNoOfInstallments = ""
    var mInstallmentData = NSArray()
    var mInstallmentMasterData = NSArray()
    
    
    var mTotalReceivedLayby = ""
    var mTotalOutStandingLayby = ""
    var mNoOfReceivedLayby = ""
    var mDueDateLayby = ""
    
    var mClientReferenceID = ""
    var mClientSecreat = ""
    var mPaymentIntentID = ""
    var mPaymentID = ""
    var mStripPublishKey = ""
    var mPaymentMethod = ""
    var mSelectdPaymentMethod = ""
    let qrCodeView = QRCodeView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        mRCurrency.text = UserDefaults.standard.string(forKey: "currencySymbol") ?? "$"
        mGCurrency.text = UserDefaults.standard.string(forKey: "currencySymbol") ?? "$"
        mBCurrency.text = UserDefaults.standard.string(forKey: "currencySymbol") ?? "$"
        
        if let mStoreCurr = UserDefaults.standard.string(forKey: "storeCurrency") as? String {
            mStoreCurrency = mStoreCurr
        }
        
        mCreditNoteTable.separatorStyle = .none
        
        if mCartTableData.count > 1 {
            mTotalItemsInCart.text = "\(mCartTableData.count) " + "Items".localizedString
        }else{
            mTotalItemsInCart.text = "\(mCartTableData.count) " + "Item".localizedString
            
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
        
        mPaymentOptionView.layer.cornerRadius = 20
        mPaymentOptionView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner ]
        
        mTabBarContainer.isHidden = true
        mIBSelect.isSelected = true
        mSelectPaymentOptionContainer.isHidden = true
        print("mayankOne")
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func mClearEnterAmount(_ sender: Any) {
        var text = mEnterQRAmount.text ?? ""
        if text != "" {
            text.removeLast()
            mEnterQRAmount.text = text
        }
    }
    
    
    @IBAction func mIBTabButton(_ sender: Any) {
        mSelectPaymentOptionContainer.isHidden =  false
        mChequeDetailsView.isHidden = true
        mChequeDetailsView.isHidden = true
        mIBSelect.isSelected = true
        mChequeSelect.isSelected = false
        
        // Update background colors
        mIBTabSelect.backgroundColor = UIColor(named: "themeColor")
        mChequeTabSelect.backgroundColor = UIColor(named: "themeExtraLightText")
        
    }
    
    
    @IBAction func mChequeTabButton(_ sender: Any) {
        mSelectPaymentOptionContainer.isHidden = true
        mChequeDetailsView.isHidden = false
        mChequeSelect.isSelected = true
        mIBSelect.isSelected = false
        
        // Update background colors
        mChequeTabSelect.backgroundColor = UIColor(named: "themeColor")
        mIBTabSelect.backgroundColor = UIColor(named: "themeExtraLightText")
    }
    
    @IBAction func mBankSelect(_ sender: Any) {
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
                    self.mSelectedBankName.text = item
                    self.mSelectedBankImage.downlaodImageFromUrl(urlString: mBankImage[index])
                }
                
                dropdown.show()
            } else {
                CommonClass.showSnackBar(message: "Please add authorised bank!")
            }
        }
    }
    
    
    @IBAction func mTakePhoto(_ sender: Any) {
    }
    
    
    @IBAction func mScanQRCOde(_ sender: Any) {
        if mEnterQRAmount.text?.isEmpty == true || (Double(mEnterQRAmount.text ?? "") ?? 0.0) == 0 {
            CommonClass.showSnackBar(message: "Please fill amount!")
            return
        }
        if let balanceDue = mBALANCEDUE.text {
            let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
            let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
            let inputAmount = Double(mEnterQRAmount.text ?? "") ?? 0.0
            
            if (balanceDueInDouble - inputAmount) < 0 {
                CommonClass.showSnackBar(message: "Please fill valid amount!")
                return
            }
        } else {
            CommonClass.showSnackBar(message: "Balance due is not available!")
            return
        }
        if mSelectedBankName.text == "Choose Bank" || mSelectedBankName.text?.isEmpty == true {
            CommonClass.showSnackBar(message: "Please choose a bank name!")
            return
        }
        mGenerateQRCode()
    }
    
    
    
    @IBAction func mGiftCardScan(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "transactions", bundle: nil)
        if let mCommonScanner = storyBoard.instantiateViewController(withIdentifier: "CommonScanner") as? CommonScanner {
            mCommonScanner.delegate =  self
            mCommonScanner.mType = "GiftCard"
            mCommonScanner.modalPresentationStyle = .overFullScreen
            mCommonScanner.transitioningDelegate = self
            self.present(mCommonScanner,animated: true)
        }
    }
    
    func mGetScannedData(value: String, type: String) {
        if type == "GiftCard" {
            mGiftCardAmount.text = value
        }
    }
    
    @IBAction func mPaymentOptions(_ sender: UIButton) {
        mPaymentOptionIcon.tintColor = UIColor(named: "themeColor")
        UIView.animate(withDuration: 1.0) {
            self.mPaymentOptionView.isHidden = false
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    
    
    @IBAction func mFullPaymentOption(_ sender: Any) {
        mPaymentOptionIcon.tintColor = UIColor(named: "themeExtraLightText")
        UIView.animate(withDuration: 1.0) {
            self.mPaymentOptionView.isHidden = true
            self.view.layoutIfNeeded()}
        mSetPaymentOptionUI(type: PAYMENT_OPTION.FULL)
        
    }
    
    
    @IBAction func mLaybyOption(_ sender: Any) {
        mPaymentOptionIcon.tintColor = UIColor(named: "themeExtraLightText")
        
        UIView.animate(withDuration: 1.0) {
            self.mPaymentOptionView.isHidden = true
            self.view.layoutIfNeeded()
        }
        mSetPaymentOptionUI(type: PAYMENT_OPTION.LAYBY)
    }
    
    
    @IBAction func mInstallmentOption(_ sender: Any) {
        mPaymentOptionIcon.tintColor = UIColor(named: "themeExtraLightText")
        UIView.animate(withDuration: 1.0) {
            self.mPaymentOptionView.isHidden = true
            self.view.layoutIfNeeded()}
        mSetPaymentOptionUI(type: PAYMENT_OPTION.INSTALLMENT)
    }
    
    enum PAYMENT_OPTION {
        case FULL, LAYBY, INSTALLMENT
    }
    func mSetPaymentOptionUI(type : PAYMENT_OPTION) {
        
        switch type {
        case .FULL:
            self.mInstallmentDetailsButton.isHidden = true
            self.mPayNowButton.setTitle("CHECK OUT".localizedString, for: .normal)
            self.mFullPaymentLabel.textColor = .white
            self.mLaybyLabel.textColor =  UIColor(named: "themeExtraLightText")
            self.mInstallmentLabel.textColor =  UIColor(named: "themeExtraLightText")
            
            self.mFullPaymentOptionView.backgroundColor =  UIColor(named: "themeColor")
            self.mLaybyOptionView.backgroundColor =  .clear
            self.mInstallmentOptionView.backgroundColor =  .clear
            self.mFullPaymentOptionView.borderWidth = 0
            self.mLaybyOptionView.borderWidth = 1
            self.mInstallmentOptionView.borderWidth = 1
            self.mReceiveView.isHidden = true
            self.mPaymentType = "Full_Payment"
            self.mBALANCEDUE.text = mTotalP.formatPrice()
            self.mTOTALAMOUNT.text = mTotalP.formatPrice()
            self.mResetPricings()
            
        case .LAYBY:
            self.mInstallmentDetailsButton.isHidden = true
            self.mPayNowButton.setTitle("LAYBY".localizedString, for: .normal)
            self.mLaybyLabel.textColor = .white
            self.mFullPaymentLabel.textColor =  UIColor(named: "themeExtraLightText")
            self.mInstallmentLabel.textColor =  UIColor(named: "themeExtraLightText")
            self.mLaybyOptionView.backgroundColor =  UIColor(named: "themeColor")
            self.mFullPaymentOptionView.backgroundColor =  .clear
            self.mInstallmentOptionView.backgroundColor =  .clear
            self.mFullPaymentOptionView.borderWidth = 1
            self.mLaybyOptionView.borderWidth = 0
            self.mInstallmentOptionView.borderWidth = 1
            self.mReceiveView.isHidden = true
            self.mPaymentType = "LayBy"
            self.mBALANCEDUE.text = mTotalP.formatPrice()
            self.mTOTALAMOUNT.text = mTotalP.formatPrice()
            self.mResetPricings()
            
        case .INSTALLMENT:
            self.mInstallmentDetailsButton.isHidden = false
            self.mPayNowButton.setTitle("INSTALLMENT".localizedString, for: .normal)
            self.mInstallmentLabel.textColor = .white
            self.mLaybyLabel.textColor =  UIColor(named: "themeExtraLightText")
            self.mFullPaymentLabel.textColor =  UIColor(named: "themeExtraLightText")
            
            self.mInstallmentOptionView.backgroundColor =  UIColor(named: "themeColor")
            self.mLaybyOptionView.backgroundColor =  .clear
            self.mFullPaymentOptionView.backgroundColor =  .clear
            self.mFullPaymentOptionView.borderWidth = 1
            self.mLaybyOptionView.borderWidth = 1
            self.mInstallmentOptionView.borderWidth = 0
            self.mReceiveView.isHidden = false
            self.mPaymentType = "Installment"
            self.mRECEIVEAMOUNT.text = "0.00"
            self.mBALANCEDUE.text = mTotalP.formatPrice()
            self.mResetPricings()
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
            if let mInstallmentPicker = storyBoard.instantiateViewController(withIdentifier: "InstallmentPicker") as? InstallmentPicker {
                mInstallmentPicker.delegate = self
                mInstallmentPicker.mTotalAmount = (Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00)
                
                mInstallmentPicker.modalPresentationStyle = .overFullScreen
                mInstallmentPicker.transitioningDelegate = self
                self.present(mInstallmentPicker,animated: true)
            }
        }
    }
    func mResetPricings() {
        self.mSubmittedCash.text = "0.00"
        self.mSubmittedCreditCard.text = "0.00"
        self.mSubmittedCreditNote.text = "0.00"
        self.mSubmittedBankAmount.text = "0.00"
        self.mConvertedAmounts = "0"
        self.mConvertedAmount.text = ""
        self.mCashAmounts = ""
        self.mCashAmount.text = ""
        mFetchCreditNoteData(value: "")
    }
    func mCancelInstallment() {
        mSetPaymentOptionUI(type: .FULL)
    }
    func mGetReceiveAmount(masterData: NSArray, selectedData: NSMutableArray, totalInstallments: Int, totalMonths: Int, receivedAmount: Double, outstanding: Double, selectedInstallments: [Int]) {
        self.mInstallmentMasterData = masterData
        self.mInstallmentData = NSArray(array: selectedData)
        self.mNoOfInstallments = String(totalInstallments)
        self.mRECEIVEAMOUNT.text = "\(receivedAmount)".formatPrice()
        self.mBALANCEDUE.text = "\(receivedAmount)".formatPrice()
        
    }
    @IBAction func mInstallmentDetails(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
        if let mInstallmentPicker = storyBoard.instantiateViewController(withIdentifier: "InstallmentPicker") as? InstallmentPicker {
            mInstallmentPicker.delegate = self
            mInstallmentPicker.mTotalAmount = Double(self.mTOTALAMOUNT.text ?? "0.00") ?? 0.00
            mInstallmentPicker.modalPresentationStyle = .overFullScreen
            mInstallmentPicker.transitioningDelegate = self
            self.present(mInstallmentPicker,animated: true)
        }
    }
    
    func mConfirmPayment(date: String, dateInGMT:Date, receiveAmount: String, outstanding: String, noOfReceived: String) {
        
        self.mTotalReceivedLayby = receiveAmount
        self.mTotalOutStandingLayby = outstanding
        self.mNoOfReceivedLayby = noOfReceived
        self.mDueDateLayby = date
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let mVerifyPin = storyBoard.instantiateViewController(withIdentifier: "VerifyPin") as? VerifyPin {
            mVerifyPin.delegate = self
            mVerifyPin.modalPresentationStyle = .overFullScreen
            mVerifyPin.transitioningDelegate = self
            self.present(mVerifyPin,animated: false)
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
        
        mPaymentConfirmation.mDueDate.inputAccessoryView = mToolBar
        mPaymentConfirmation.mDueDate.inputView = mDatePicker
        mPaymentConfirmation.mDueDate.becomeFirstResponder()
    }
    
    
    @objc
    func donePick(){
        let mDayd = DateFormatter()
        mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        mPaymentConfirmation.mCurrentDate.text  = "\(mDayd.string(from: mDatePicker.date))/" +  "\(mMonthm.string(from: mDatePicker.date))/"+"\(mYeard.string(from: mDatePicker.date))"
        
        self.view.endEditing(true)
        
        
    }
    @objc func mCancelPick(){
        self.view.endEditing(true)
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
                        
                        guard let mCreditRow = jsonResult.value(forKey: "creditNote_row") as? NSDictionary else {
                            CommonClass.showSnackBar(message: "OOP's something went wrong!")
                            return
                        }
                        
                        var isExist = false
                        for item in mCreditNoteData {
                            if let value = item as? NSDictionary {
                                if let id = value.value(forKey: "id") , "\(id)" == "\(mCreditRow.value(forKey: "id") ?? "")"{
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
                                if let value = item as? NSDictionary {
                                    let mCData = NSMutableDictionary()
                                    
                                    mAmount.append(Double("\(value.value(forKey: "amount") ?? "0.0")") ?? 0.0)
                                    
                                    mCData.setValue("\(value.value(forKey: "amount") ?? "0.0")", forKey: "amount")
                                    self.mTotalCreditAmount.text = String(format:"%.02f",locale:Locale.current,mAmount.reduce(0, {$0 + $1}))
                                    
                                    self.mAmountData.add(mCData)
                                }
                            }
                            self.mCreditNoteTable
                                .delegate = self
                            self.mCreditNoteTable
                                .dataSource = self
                            self.mCreditNoteTable
                                .reloadData()
                            self.mGetTotalAmount()
                            
                        }else{
                            CommonClass.showSnackBar(message: "Already Added!")
                            
                        }
                        
                        
                        
                    }else {
                        
                        CommonClass.showSnackBar(message: "Invalid Card!")
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
        let mLocation = UserDefaults.standard.string(forKey: "location")
        
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
                        if let mData = jsonResult.value(forKey: "data") as? NSDictionary,
                           let mId = mData.value(forKey: "insert_id") as? String {
                            
                            let mCreditCardOptions = NSMutableDictionary()
                            mCreditCardOptions.setValue(self.mCreditCardPaymentId, forKey: "cardPaymentId")
                            mCreditCardOptions.setValue(amount, forKey: "amount")
                            mCreditCardOptions.setValue(mId, forKey: "id")
                            self.mCreditCardMethod.add(mCreditCardOptions)
                            var mAmount = [Double]()
                            
                            for i in self.mCreditCardMethod {
                                if let mAM = i as? NSDictionary, let amount = mAM.value(forKey: "amount"), let doubleAmount = Double("\(amount)") {
                                    mAmount.append(doubleAmount)
                                }
                            }
                            
                            self.mSubmittedCreditCard.text = "\( mAmount.reduce(0, {$0 + $1}))"
                            
                            if self.mPaymentType == "Installment" {
                                let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                                let submittedCash = Double(mSubmittedCash.text ?? "0.0") ?? 0.0
                                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                                
                                let balanceDue = receiveAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
                                self.mBALANCEDUE.text = "\(balanceDue)".formatPrice()
                                
                            }else{
                                let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                                let submittedCash = Double(mSubmittedCash.text ?? "0.0") ?? 0.0
                                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                                
                                let balanceDue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
                                self.mBALANCEDUE.text = "\(balanceDue)".formatPrice()
                            }
                        }else {
                            CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        }
                    }else {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mPaymentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "Collect",for:indexPath) as? Collect,
              let mData = mPaymentData[indexPath.row] as? NSDictionary else {
            return UICollectionViewCell()
        }
        
        cells.mImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "PayMethod_logo") ?? "")")
        cells.mName.text = mData.value(forKey: "name") as? String
        if mStripeIndex == indexPath.row {
            
            if let id = mData.value(forKey: "id") as? String,
               let name = mData.value(forKey: "name"),
               let paymethoLogo = mData.value(forKey: "PayMethod_logo") {
                
                mCreditCardPaymentId = id
                mCreditCardName = "\(name)"
                mCreditCardLogo = "\(paymethoLogo)"
            }
            cells.mView.borderColor = UIColor(named: "themeColor")
            cells.mView.borderWidth = 1
            cells.mView.layer.cornerRadius = 10
            
        }else {
            
            cells.mView.borderWidth = 0
            cells.mView.layer.cornerRadius = 10
        }
        
        return cells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Safely cast the layout to UICollectionViewFlowLayout
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        
        // Set layout properties (ideally, set these once, not dynamically here)
        layout.minimumLineSpacing = 16
        
        // Calculate item size
        let width = (collectionView.frame.width / 2) - 16
        let height = (collectionView.frame.height / 2) - 16
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mStripeIndex = indexPath.row
        if let mData = mPaymentData[indexPath.row] as? NSDictionary {
            if let id = mData.value(forKey: "id") as? String,
               let name = mData.value(forKey: "name"),
               let paymethoLogo = mData.value(forKey: "PayMethod_logo") {
                
                mCreditCardPaymentId = id
                mCreditCardName = "\(name)"
                mCreditCardLogo = "\(paymethoLogo)"
                mPaymentID = "\(mData.value(forKey: "id") ?? "")"
                mPaymentMethod = "\(mData.value(forKey: "PaymentMethod") ?? "")"
                mStripPublishKey = "\(mData.value(forKey: "key") ?? "")"
                mSelectdPaymentMethod = "\(mData.value(forKey: "payment_slag") ?? "")"
                
                self.mCreditBankImage.downlaodImageFromUrl(urlString: "\(paymethoLogo)")
                self.mCreditBankName.text = name as? String
            }
            
            mCardNumber.text = ""
            mCardName.text = ""
            mCreditFillAmount.text = ""
            self.mStripeCardView.isHidden = false
            if mSelectdPaymentMethod == "stripe-payment" {
                
                self.mCardNumberContainer.isHidden = true
                self.mCardNameContainer.isHidden = true
            }else {
                self.mCardNumberContainer.isHidden = false
                self.mCardNameContainer.isHidden = false
            }
            self.mCreditCardBanksView.isHidden = true
            self.mCollectionView.reloadData()
        }
    }
    
    
    func mFetchStore(key: String){
        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        
        let urlPath =  mFetchPaymentMethod
        let params = ["login_token": mUserLoginToken ?? "", "location_id":mLocation]
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:["":""], headers: sGisHeaders2).responseJSON
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
                        
                        guard let mPaymentMethod = jsonResult.value(forKey: "data") as? NSDictionary,
                              let mData = mPaymentMethod.value(forKey: "Credit_Card") as? NSArray else {
                            return
                        }
                        if mData.count > 0 {
                            self.mPaymentData = mData
                            self.mCollectionView.delegate = self
                            self.mCollectionView.dataSource = self
                            self.mCollectionView.reloadData()
                        }
                    }else {
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
                
                if self.mPaymentType == "Installment" {
                    let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    let convertedAmounts = Double(mConvertedAmounts) ?? 0.0
                    let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                    let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                    let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                    
                    let mTotalValue = receiveAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                    
                    self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                }else{
                    let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    let convertedAmounts = Double(mConvertedAmounts) ?? 0.0
                    let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                    let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                    let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                    
                    let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                    
                    self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                }
                
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
    
    
    @IBAction func mSubmitCheque(_ sender: UIButton) {
        sender.showAnimation{}
        
        if mChequeAmount.text == "" || (Double(mChequeAmount.text!) ?? 0.0) == 0 {
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
                    recheckBalanceDue()
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
            mChequeData.setValue("Bank", forKey: "Paymentmethod_type")
            
            self.mBankPayment.add(mChequeData)
            
            
            
            var mAmounts = [Double]()
            for i in mBankPayment {
                if let mData = i as? NSDictionary {
                    mAmounts.append(Double("\(mData.value(forKey: "amount") ?? "0.0")".replacingOccurrences(of: ",", with: "")) ?? 0.00)
                }
            }
            
            mSubmittedBankAmount.text = "\(mAmounts.reduce(0, {$0 + $1}))"
            if self.mPaymentType == "Installment" {
                let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                
                let mTotalValue = receiveAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            }else{
                let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                
                let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            }
            
            
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
            
            cells.mView.backgroundColor = (indexPath.row % 2 == 0) ? UIColor(named: "themeBackground") : #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
            
            if mSelectedCustomIndex.contains(indexPath) {
                if let mDataSet = mAmountData[indexPath.row] as? NSDictionary {
                    cells.mAmount.text = "\(mDataSet.value(forKey: "amount") ?? "0.0")"
                }
            }else{
                cells.mAmount.text = "\(mData.value(forKey: "amount") ?? "0.0")"
            }
            
            cells.mCheckImage.image = UIImage(named: mSelectedIndex.contains(indexPath) ? "check_item" : "uncheck_item" )
            
            cells.layoutSubviews()
        }
        
        return cells
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.dequeueReusableCell(withIdentifier: "CreditNoteList") as? CreditNoteList
        
        _ = mCreditNoteData[indexPath.row] as? NSDictionary
        if mSelectedIndex.contains(indexPath) {
            mSelectedIndex = mSelectedIndex.filter {$0 != indexPath }
        }else{
            mSelectedIndex.append(indexPath)
        }
        
        self.mGetTotalAmount()
        self.mCreditNoteTable.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    
    @IBAction func mAmountEdit(_ sender: UITextField) {
        
        if let mMaxData = mCreditNoteData[sender.tag] as? NSDictionary {
            let mMaxAmount = Double("\(mMaxData.value(forKey: "amount") ?? "0.0")") ?? 0.0
            if sender.text == ""  {
                mAddCreditAmount(text: "0", index: sender.tag)
                return
            }
            
            let amount = Double("\(sender.text ?? "")") ?? 0.0
            if amount > mMaxAmount   {
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
                    
                    mAmount.append(Double("\(mData.value(forKey: "amount") ?? "0.0")") ?? 0.0)
                    
                    var mCData = NSMutableDictionary()
                    mCData.setValue("\(mData.value(forKey: "amount") ?? "0.0")", forKey: "amount")
                    if let mMaxData =  mCreditNoteData[index] as? NSDictionary {
                        mCData.setValue("\(mMaxData.value(forKey: "id") ?? "")", forKey: "payment_method_id")
                    }
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
        
        
        if self.mPaymentType == "Installment" {
            let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let submittedCash = Double(mSubmittedCash.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let mTotalValue = receiveAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }else{
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let submittedCash = Double(mSubmittedCash.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let mTotalValue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }
        
        
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
        mIBTabSelect.backgroundColor = UIColor(named: "themeColor")
        mChequeTabSelect.backgroundColor = UIColor(named: "themeExtraLightText")
        
        mTransactionType = "Bank"
        mChequeDetailsView.isHidden = true
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
                    recheckBalanceDue()
                    return
                }
            }
            
            if (Double(mConvertedAmounts) ?? 0.00) == 0 {
                CommonClass.showSnackBar(message: "Please fill valid amount!")
                return
            }
            
            self.mSubmittedCash.text = (mCashAmount.text ?? "0.0")
            
            if self.mPaymentType == "Installment" {
                let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                
                let mTotalValue = receiveAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                
                self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            }else{
                let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
                let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                
                let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                
                
                
                self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
            }
            CommonClass.showSnackBar(message: "Amount Added Successfully!")
            
        }
        
    }
    
    
    @IBAction func mShowTaxView(_ sender: Any) {
        
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
                    mConvertedAmounts = "\(Double(mCashAmounts) ?? 0.0)"
                    
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
                mConvertedAmounts = "\(Double(mCashAmounts) ?? 0.0)"
                
                let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                
                mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
            }
        }else{
            if mTransactionType == "Cash" {
                if mExchangeRateLabel.isHidden == false {
                    if mExchangeRateValue.text != "" {
                        let mVal = Double(mExchangeRateValue.text ?? "") ?? 0
                        if mCashAmount.text != "" && mCashAmount.text != "."  {
                            let cashAmounts = Double(mCashAmounts) ?? 0.0
                            
                            mConvertedAmounts = "\(cashAmounts * mVal)"
                            let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                            mConvertedAmount.text = "=  \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                        }
                    }
                }else{
                    if mCashAmount.text != "" && mCashAmount.text != "."  {
                        mConvertedAmounts = "\(Double(mCashAmounts) ?? 0.0)"
                        let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                        mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                    }
                }
            }
        }
    }
    
    private func recheckBalanceDue() {
        if self.mPaymentType == "Installment" {
            let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let mTotalValue = receiveAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }else{
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }
    }
    
    @IBAction func mClear(_ sender: UIButton) {
        sender.showAnimation{}
        
        mCashAmount.text = ""
        mConvertedAmount.text = ""
        mConvertedAmounts = "0"
        mCashAmounts = ""
        
        mSubmittedCash.text = "0.00"
        if self.mPaymentType == "Installment" {
            let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let mTotalValue = receiveAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }else{
            let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
        }
    }
    
    @IBAction func mDeleteCashAmount(_ sender: Any) {
        if mCashAmounts != "" {
            mCashAmounts.removeLast()
            mCashAmount.text! = mCashAmounts
            if mCashAmounts == "" {
                mConvertedAmounts = "0"
                mSubmittedCash.text = "0.00"
                if self.mPaymentType == "Installment" {
                    let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
                    let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                    let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                    let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                    
                    let mTotalValue = receiveAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                    
                    self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                }else{
                    let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    let convertedAmounts = Double(mCashAmount.text ?? "0.0") ?? 0.0
                    let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
                    let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
                    let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
                    
                    let mTotalValue = totalAmount - convertedAmounts - submittedCreditNote - submittedBankAmount - submittedCreditCard
                    
                    self.mBALANCEDUE.text = "\(mTotalValue)".formatPrice()
                    
                }
            }
            
        }else{ }
        
        if mCashAmounts == "" {
            mConvertedAmounts = "0"
            mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") 00.00"
        }
        if mTransactionType == "Cash" {
            if mExchangeRateLabel.isHidden == false {
                if mExchangeRateValue.text != "" {
                    let mVal = Double(mExchangeRateValue.text ?? "") ?? 0.0
                    if mCashAmount.text != "" {
                        let cashAmounts = Double(mCashAmounts) ?? 0
                        mConvertedAmounts = "\(cashAmounts * mVal)"
                        
                        // mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mConvertedAmounts)"
                        
                        let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                        
                        mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                        
                        
                    }
                }
            }else{
                if mCashAmounts != "" {
                    mConvertedAmounts = "\(Double(mCashAmounts) ?? 0.0)"
                    // mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mConvertedAmounts)"
                    
                    let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                    
                    mConvertedAmount.text = "= \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                    
                    
                    
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
        
        mCashAmount.text! = mCashAmounts
        
        if mTransactionType == "Cash" {
            if mExchangeRateLabel.isHidden == false {
                if mExchangeRateValue.text != "" {
                    let mVal = Double(mExchangeRateValue.text ?? "") ?? 0.0
                    if mCashAmount.text != "" && mCashAmount.text != "."  {
                        let cashAmount = Double(mCashAmounts) ?? 0
                        mConvertedAmounts = "\(cashAmount * mVal)"
                        let mDecimalAmount = ((Double(mConvertedAmounts) ?? 0) * 100).rounded() / 100
                        mConvertedAmount.text = "=  \(self.mCurrencyName.text ?? "") \(mDecimalAmount)"
                        
                        
                        
                        
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
                if let value = item as? NSDictionary {
                    mAmount.append(Double("\(value.value(forKey: "amount") ?? 0.00)") ?? 0.00)
                }
            }
            mCreditFinalTotalAmountObj = "\(mAmount.reduce(0, {$0 + $1}))"
            mCreditNoteMethod.setValue(mCreditData, forKey: "ids")
            mCreditNoteMethod.setValue(Double(mCreditFinalTotalAmountObj) ?? 0.00, forKey: "amount")
            mCreditNoteMethod.setValue("CreditNote", forKey: "Paymentmethod_type")
            
            //CreditCard/Bank/Cash Addition
            mPayData.setValue(mCashMethod, forKey: "cash")
            mPayData.setValue(mBankPayment, forKey: "bank")
            mPayData.setValue([], forKey: "IB")
            mPayData.setValue(mCreditCardMethod, forKey: "credit_card")
            mPayData.setValue(mCreditNoteMethod, forKey: "credit_note")
            mPayData.setValue("", forKey: "gift_card")
            
            //SellInfo (Cart Data , Summary Order, Status)
            mSellInfo.setValue(mCartTableData, forKey: "cart")
            mSellInfo.setValue(mSummaryOrder, forKey: "summary_order")
            mSellInfo.setValue(mOrderType, forKey: "status_type")
            mSellInfo.setValue(Double(mTotalWithDiscount) ?? 0.00, forKey: "totalamount")
            
            //PaymentInfo (Debited amount, Pay Data(Card/Bank), )
            mPaymentInfo.setValue(mDebitedAmount, forKey: "debited_amount")
            mPaymentInfo.setValue(mPayData, forKey: "pay_data")
            mPaymentInfo.setValue("", forKey: "balance_due")
            mPaymentInfo.setValue("", forKey: "balance_deposit")
            
            
            if mPaymentType == "Installment" {
                mFinalPaymentMethod = ["sell_info": mSellInfo,
                                       "payment_info":mPaymentInfo,
                                       "transaction_date": "",
                                       "customer_id":self.mCustomerId,
                                       "sales_person_id":"",
                                       "order_type":self.mOrderType ,
                                       "order_id":self.mOrderId,
                                       "paymentMathod":self.mPaymentType,
                                       "installment":self.mInstallmentData,
                                       "fullinstallentlist":self.mInstallmentMasterData]
                
            }else {
                
                let mPayLayByData = NSMutableDictionary()
                let mPayLayByArray = NSMutableArray()
                if mPaymentType == "LayBy" {
                    
                    let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    let balanceDue = Double(self.mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    
                    let mLaybyReceivedAmount = "\(totalAmount - balanceDue)"
                    mPayLayByData.setValue(Double(self.mNoOfReceivedLayby) ?? 0.00, forKey: "Received")
                    mPayLayByData.setValue(mLaybyReceivedAmount, forKey: "amount")
                    mPayLayByArray.add(mPayLayByData)
                }
                
                mFinalPaymentMethod = ["sell_info": mSellInfo,
                                       "payment_info":mPaymentInfo,
                                       "transaction_date": "",
                                       "customer_id":self.mCustomerId,
                                       "sales_person_id":"",
                                       "order_type":self.mOrderType ,
                                       "order_id":self.mOrderId,
                                       "paymentMathod":self.mPaymentType,
                                       "installment":[],
                                       "fullinstallentlist":[],
                                       "pay_layby_data":mPayLayByArray,
                                       "layby_due_date":self.mDueDateLayby]
            }
            
            if mOrderType == "custom_order" ||  mOrderType == "mix_and_match" || mOrderType == "pos_order" ||  mOrderType == "repair_order" || mOrderType == "gift_card_order" {
                mFinalPaymentMethod["shippingInfo"] = ["billing_address": mSelectedBillingAddress,
                                                       "shipping_address": mSelectedShippingAddress]
            }
            
            if mOrderType == "custom_order" ||  mOrderType == "mix_and_match" || mOrderType == "pos_order" ||  mOrderType == "repair_order" ||  mOrderType == "exchange_order" || mOrderType == "gift_card_order" ||  mOrderType == "refund_order" || mOrderType == "reserve" {
                
                CommonClass.showFullLoader(view: self.view)
                
                mGetData(url: mFinalCheckoutCustomOrder, headers: sGisHeaders, params: mFinalPaymentMethod) { response , status in
                    CommonClass.stopLoader()
                    
                    if status {
                        
                        if let mCode =  response.value(forKey: "code") as? Int {
                            
                            if mCode == 400 {
                                CommonClass.showSnackBar(message: "\(response.value(forKey: "message") ?? "OOP's something went wrong!")")
                                return
                            }
                        }
                        if let mData = response.value(forKey: "data") as? NSDictionary {
                            
                            
                            if self.mPaymentType == "Installment" || self.mPaymentType == "LayBy" {
                                let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
                                guard let mCompleteInstallmentLayby = storyBoard.instantiateViewController(withIdentifier: "CompleteInstallmentLayby") as? CompleteInstallmentLayby else {
                                    return
                                }
                                mCompleteInstallmentLayby.mGrandTotalAmount = self.mTOTALAMOUNT.text ?? ""
                                mCompleteInstallmentLayby.mNoOfInstallments = self.mNoOfInstallments
                                mCompleteInstallmentLayby.mInstallmentsData = self.mInstallmentData
                                mCompleteInstallmentLayby.mOrderId = "\(mData.value(forKey: "id") ?? "")"
                                mCompleteInstallmentLayby.mEmailId = "\(mData.value(forKey: "email") ?? "")"
                                
                                
                                mCompleteInstallmentLayby.mTotalReceivedAmounts = self.mTotalReceivedLayby
                                mCompleteInstallmentLayby.mDueDates = self.mDueDateLayby
                                mCompleteInstallmentLayby.mNoOfReceivedAmounts = self.mNoOfReceivedLayby
                                mCompleteInstallmentLayby.mPaymentType = self.mPaymentType
                                
                                if self.mPaymentType == "Installment" {
                                    let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                                    let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                                    
                                    let outstandingBalance = totalAmount - receiveAmount
                                    mCompleteInstallmentLayby.mOutstandingBalance = "\(outstandingBalance)"
                                }else{
                                    mCompleteInstallmentLayby.mOutstandingBalance = self.mTotalOutStandingLayby
                                }
                                mCompleteInstallmentLayby.mUrl = "\(mData.value(forKey: "url") ?? "")"
                                self.navigationController?.pushViewController(mCompleteInstallmentLayby, animated:true)
                                
                                return
                            }
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
        
        if self.mPaymentType == "Installment" {
            if (Double(mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00) == 0 {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "laybyInstallment", bundle: nil)
                if let mConfirmInstallment = storyBoard.instantiateViewController(withIdentifier: "ConfirmInstallment") as? ConfirmInstallment {
                    mConfirmInstallment.delegate = self
                    
                    mConfirmInstallment.mGrandTotalAmount = "\((Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00))"
                    
                    mConfirmInstallment.mNoOfInstallments = self.mNoOfInstallments
                    mConfirmInstallment.mInstallmentsData = self.mInstallmentData
                    let totalAmount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    let receiveAmount = Double(self.mRECEIVEAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
                    
                    let outstandingBalance = totalAmount - receiveAmount
                    mConfirmInstallment.mOutstandingBalance = "\(outstandingBalance)"
                    mConfirmInstallment.modalPresentationStyle = .automatic
                    mConfirmInstallment.transitioningDelegate = self
                    self.present(mConfirmInstallment,animated: true)
                }
            }else{
                CommonClass.showSnackBar(message: "Please enter valid amount!")
                
            }
            
        }else if self.mPaymentType == "LayBy" {
            
            if (Double(mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00) < 0 {
                CommonClass.showSnackBar(message: "Please choose valid amount")
                return
            }
            if (Double(mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00) == 0 {
                CommonClass.showSnackBar(message: "Please choose full payment option")
                return
            }
            if (Double(mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00) > (Double(mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00){
                CommonClass.showSnackBar(message: "Please choose valid amount")
                return
            }
            
            
            mPaymentConfirmation.frame = self.view.bounds
            mPaymentConfirmation.delegate = self
            mPaymentConfirmation.mType = ""
            
            
            mPaymentConfirmation.mHeadingLabel.text = "Payment Confirmation".localizedString
            mPaymentConfirmation.mGrandTotalLABEL.text = "Grand Total".localizedString
            mPaymentConfirmation.mOutstandingLABEL.text = "Outstanding Balance".localizedString
            mPaymentConfirmation.mDueDateLABEL.text = "Due Date".localizedString
            mPaymentConfirmation.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
            mPaymentConfirmation.mConfirmButton.setTitle("CONFIRM".localizedString, for: .normal)
            
            mPaymentConfirmation.mReceiveLabel.text = "1st Received"
            mPaymentConfirmation.mGrandTotal.text = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "$" ) " + (self.mTOTALAMOUNT.text ?? "")
            mPaymentConfirmation.mOutstanding.text = "\(UserDefaults.standard.string(forKey: "currencySymbol") ?? "$" ) " + (self.mBALANCEDUE.text ?? "")
            let currency = UserDefaults.standard.string(forKey: "currencySymbol") ?? "$"
            let totalamount = Double(self.mTOTALAMOUNT.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00
            let balanceDue = Double(self.mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00
            mPaymentConfirmation.mTotalReceived.text = "\(currency)" + "\(totalamount - balanceDue)".formatPrice()
            
            mPaymentConfirmation.mCurrentDate.text = Date.getCurrentDate()
            self.view.addSubview(mPaymentConfirmation)
        }else{
            if (Double(mBALANCEDUE.text?.replacingOccurrences(of: ",", with: "") ?? "") ?? 0.00) == 0 {
                mConfirmationPopUp.frame = self.view.bounds
                mConfirmationPopUp.delegate = self
                
                mConfirmationPopUp.mMessage.text = "Are you sure want to proceed ?".localizedString
                
                mConfirmationPopUp.mCancelButton.setTitle("CANCEL".localizedString, for: .normal)
                mConfirmationPopUp.mConfirmButton.setTitle("CONFIRM".localizedString, for: .normal)
                self.view.addSubview(mConfirmationPopUp)
            }else{
                CommonClass.showSnackBar(message: "Please enter valid amount!")
            }
        }
    }
    
    @IBAction func mStartSearch(_ sender: Any) {
        
    }
    @IBAction func mEndSearch(_ sender: Any) {
        
    }
    @IBAction func mEditChanged(_ sender: Any) {
        
        let value  = mCustomerSearch.text?.count
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
        if sender.text! == "" || sender.text == "0"  || mCount > 100 {
            sender.text = "0"
            self.mDiscountAmounts.text = "0"
            calculateTax()
        }else {
            self.mDiscountAmounts.text = "\(calculatePercentage(value: (Double(mTotalAm) ?? 0), percent: Double(sender.text ?? "") ?? 0 ))"
            calculateTax()
        }
    }
    
    @IBAction func mDiscountAmount(_ sender: UITextField) {
        if sender.text == "" {
            
            sender.text = "0"
            self.mDiscountPercents.text = "0"
            
            calculateTax()
        }else{
            
            let mPercent = (Double(sender.text ?? "") ?? 0) / (Double(mTotalAm) ?? 0 * 100)
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
        let mDiscountA = Double(self.mDiscountAmounts.text ?? "") ?? 0
        let mLabour = Double(self.mLabourCharge.text ?? "") ?? 0
        let mShipping = Double(self.mShippingCharge.text ?? "") ?? 0
        mAmount = mLabour + mShipping
        
        if mTaxType.lowercased() == "inclusive" {
            mTotalDiscountTx.text = mDiscountAmounts.text
            mTotalTx.text = "\((mAmount + (Double(mTotalAm) ?? 0) ))"
            let totalTx = Double(mTotalTx.text ?? "0.0") ?? 0.0
            let discountAmounts = Double(mDiscountAmounts.text ?? "0.0") ?? 0.0
            let taxPercent = Double(mTaxP) ?? 0.0
            
            let taxAmount = calculateInclusiveTax(value: totalTx - discountAmounts, percent: taxPercent)
            mTaxAmountTx.text = String(format: "%.02f", locale: Locale.current, taxAmount)
            
            let taxAmountTx = Double(mTaxAmountTx.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            
            let subTotal = totalTx - discountAmounts - taxAmountTx
            
            mSubTotalTx.text = String(format: "%.02f", locale: Locale.current, subTotal)
            
            mFinalTaxAmount.text = mTaxAmountTx.text
            mTOTALAMOUNT.text = "\((mAmount + (Double(mTotalAm) ?? 0) - mDiscountA))"
            
            let totalAmount = Double(mTOTALAMOUNT.text ?? "0.0") ?? 0.0
            let submittedCash = Double(mSubmittedCash.text ?? "0.0") ?? 0.0
            let submittedCreditNote = Double(mSubmittedCreditNote.text ?? "0.0") ?? 0.0
            let submittedBankAmount = Double(mSubmittedBankAmount.text ?? "0.0") ?? 0.0
            let submittedCreditCard = Double(mSubmittedCreditCard.text ?? "0.0") ?? 0.0
            
            let balanceDue = totalAmount - submittedCash - submittedCreditNote - submittedBankAmount - submittedCreditCard
            
            mBALANCEDUE.text = "\(balanceDue)".formatPrice()
        }else{
            mTotalDiscountTx.text = mDiscountAmounts.text
            mTotalTx.text = "\((mAmount + (Double(mTotalAm) ?? 0 )) )"
            
            let totalTx = Double(mTotalTx.text ?? "0.0") ?? 0.0
            let discountAmounts = Double(mDiscountAmounts.text ?? "0.0") ?? 0.0
            let taxPercent = Double(mTaxP) ?? 0.0
            
            mTaxAmountTx.text = String(format: "%.02f", locale: Locale.current, calculateExclusiveTax(value: totalTx - discountAmounts, percent: taxPercent))
            
            mSubTotalTx.text = String(format:"%.02f",locale:Locale.current,totalTx - discountAmounts)
            mFinalTaxAmount.text = mTaxAmountTx.text
            
            let subTotal = Double(mSubTotalTx.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            let taxAmount = Double(mTaxAmountTx.text?.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
            
            mTOTALAMOUNT.text = "\(subTotal + taxAmount)"
            let totalamount = Double(mTOTALAMOUNT.text ?? "") ?? 0
            let submittedcash = Double(mSubmittedCash.text ?? "") ?? 0
            let submittedcreditnote = Double(mSubmittedCreditNote.text ?? "") ?? 0
            let submittedbankamount = Double(mSubmittedBankAmount.text ?? "") ?? 0
            let submittedcreditcard = Double(mSubmittedCreditCard.text ?? "") ?? 0
            mBALANCEDUE.text = "\(totalamount - submittedcash - submittedcreditnote - submittedbankamount - submittedcreditcard)".formatPrice()
            
        }
        
    }
    
    
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = textField.text
        
    }
    func mFetchCreditNoteData(value: String){
        
        _ = UserDefaults.standard.string(forKey: "location")
        
        let urlPath =  mPOSCreditNote
        let params = ["customer_id":mCustomerId]
        
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
                        self.mSelectedCustomIndex = [IndexPath]()
                        self.mSelectedIndex = [IndexPath]()
                        self.mAmountData = NSMutableArray()
                        self.mItemsSelected.text = "0 " + "Item Selected".localizedString
                        self.mTotalCreditAmount.text = ""
                        
                        if let mData = jsonResult.value(forKey: "data") as? NSArray {
                            
                            self.mCreditNoteData = NSMutableArray(array: mData)
                            self.mCreditNoteTable.delegate = self
                            self.mCreditNoteTable.dataSource = self
                            self.mCreditNoteTable.reloadData()
                            var mAmount = [Double]()
                            for item in mData {
                                if let value = item as? NSDictionary {
                                    let mCData = NSMutableDictionary()
                                    
                                    mAmount.append(Double("\(value.value(forKey: "amount") ?? "0")") ?? 0.0)
                                    
                                    mCData.setValue("\(value.value(forKey: "amount") ?? "0")", forKey: "amount")
                                    self.mTotalCreditAmount.text = String(format:"%.02f",locale:Locale.current,mAmount.reduce(0, {$0 + $1}))
                                    
                                    self.mAmountData.add(mCData)
                                }
                            }
                            
                            
                        }
                    }
                    else{
                        if let error = jsonResult.value(forKey: "error") as? String {
                            if error == "Authorization has been expired" {
                                CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                            } else {
                                CommonClass.showSnackBar(message: error)
                            }
                        }
                        
                        if let message = jsonResult.value(forKey: "message") as? String {
                            CommonClass.showSnackBar(message: message)
                        }
                    }
                    
                    
                    
                    
                }
                
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
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
                        
                        UserDefaults.standard.setValue("\(jsonResult.value(forKey: "pdf_url") ?? "")", forKey: "reportAPI")
                        self.mGenerateReport(id:"\(jsonResult.value(forKey: "pdf_url") ?? "")" , jsonResult : jsonResult)
                        
                    }else{
                        if let error = jsonResult.value(forKey: "error"){
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
                        return
                    }
                    
                    UserDefaults.standard.set("", forKey: "CUSTOMERID")
                    UserDefaults.standard.set("", forKey: "SALESPERSONID")
                    CommonClass.showSnackBar(message: "Payment Successful")
                    if let email = jsonVal.value(forKey: "email") {
                        UserDefaults.standard.setValue("\(email)", forKey: "mailInvoice")
                    }
                    
                    UserDefaults.standard.setValue("\(jsonVal.value(forKey: "pdf_url") ?? "")", forKey: "report")
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
        if mCustomerSearch.text  != "" {
            let nib = UINib(nibName: "CustomerSearchList", bundle: nil)
            _ = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
            let _:CGFloat = UIApplication.shared.statusBarFrame.size.height
            let _: CGFloat = self.view.frame.width
            let _: CGFloat = self.view.frame.height
            
            
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
        
        var _: [NSLayoutConstraint] = []
        
    }
    
    func mGetCurrency(){
        print("8")
        let urlPath = mGetCurrencies
        
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, parameters:nil, headers: sGisHeaders2).responseJSON
            { response in
                
                print(response,"check")
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
                        if data.count == 0 {
                            return
                        }
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
                                self.mTOTALAMOUNT.text = self.mTotalP.formatPrice()
                                self.mBALANCEDUE.text = self.mTotalP.formatPrice()
                            }
                        }
                    }
                }
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
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
                guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                      let code = json["code"] as? Int else {
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
    
    // MARK: Generate QR Code -:
    
    func mGenerateQRCode() {
        let urlPath = mGetQRCode
        let mParams: [String: Any] = [
            "payment_id": mChequePaymentId,
            "amount": mEnterQRAmount.text ?? "0",
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
                                paymentSuccessView.setAmount("Amount: \(self.mEnterQRAmount.text ?? "")")
                                
                                if let successImage = UIImage(named: "successAmount") {
                                    paymentSuccessView.setImage(successImage)
                                }
                                
                                self.view.addSubview(paymentSuccessView)
                            }
                            
                            self.qrCodeView.isHidden = true
                            if let balanceDue = self.mBALANCEDUE.text {
                                let formattedBalanceDue = balanceDue.replacingOccurrences(of: ",", with: "")
                                let balanceDueInDouble = Double(formattedBalanceDue) ?? 0.0
                                let inputAmount = Double(self.mEnterQRAmount.text ?? "") ?? 0.0
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
                            self.mChequeData.setValue(self.mEnterQRAmount.text ?? "", forKey: "amount")
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
                            
                            self.mEnterQRAmount.text = ""
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
    
    
}

