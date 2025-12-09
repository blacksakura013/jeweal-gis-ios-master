//
//  ProductStoneEdit.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 09/01/23.
//  Copyright © 2023 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import SwiftUI

protocol EditProductDelegate {
    func mOnUpdated(data:NSDictionary)
}

class EditStoneItems:UITableViewCell {
    @IBOutlet weak var mChooseStoneButton: UIButton!
    @IBOutlet weak var mStoneName: UITextField!
    @IBOutlet weak var mShapeName: UITextField!
    @IBOutlet weak var mChooseShapeButton: UIButton!
    @IBOutlet weak var mCutName: UITextField!
    @IBOutlet weak var mChooseCutButton: UIButton!
    @IBOutlet weak var mClarityName: UITextField!
    @IBOutlet weak var mChooseClarityButton: UIButton!
    @IBOutlet weak var mColorName: UITextField!
    @IBOutlet weak var mChooseColorButton: UIButton!
    @IBOutlet weak var mSizeName: UITextField!
    @IBOutlet weak var mChooseSizeButton: UIButton!
    @IBOutlet weak var mPieces: UITextField!
    @IBOutlet weak var mWeightName: UITextField!
    @IBOutlet weak var mChooseWeightButton: UIButton!
    @IBOutlet weak var mWeightValue: UITextField!
    @IBOutlet weak var mSettingName: UITextField!
    @IBOutlet weak var mChooseSettingButton: UIButton!
    @IBOutlet weak var mChooseCertificateButton: UIButton!
    @IBOutlet weak var mCertificateName: UITextField!
    @IBOutlet weak var mRemoveButton: UIButton!
    
    @IBOutlet weak var mStoneLABEL: UILabel!
    @IBOutlet weak var mShapeLABEL: UILabel!
    @IBOutlet weak var mCutLABEL: UILabel!
    @IBOutlet weak var mClarityLABEL: UILabel!
    @IBOutlet weak var mColorLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mPcsLABEL: UILabel!
    
    @IBOutlet weak var mWeightLABEL: UILabel!
    @IBOutlet weak var mSettingLABEL: UILabel!
    @IBOutlet weak var mCertificateLABEL: UILabel!
    
}

class ProductStoneItems:UITableViewCell {
    @IBOutlet weak var mChooseStoneButton: UIButton!
    @IBOutlet weak var mStoneName: UITextField!
    @IBOutlet weak var mShapeName: UITextField!
    @IBOutlet weak var mChooseShapeButton: UIButton!
    @IBOutlet weak var mCutName: UITextField!
    @IBOutlet weak var mChooseCutButton: UIButton!
    @IBOutlet weak var mClarityName: UITextField!
    @IBOutlet weak var mChooseClarityButton: UIButton!
    @IBOutlet weak var mColorName: UITextField!
    @IBOutlet weak var mChooseColorButton: UIButton!
    @IBOutlet weak var mSizeName: UITextField!
    @IBOutlet weak var mChooseSizeButton: UIButton!
    @IBOutlet weak var mPieces: UITextField!
    @IBOutlet weak var mWeightName: UITextField!
    @IBOutlet weak var mChooseWeightButton: UIButton!
    @IBOutlet weak var mWeightValue: UITextField!
    @IBOutlet weak var mSettingName: UITextField!
    @IBOutlet weak var mChooseSettingButton: UIButton!
    @IBOutlet weak var mChooseCertificateButton: UIButton!
    @IBOutlet weak var mCertificateName: UITextField!
    @IBOutlet weak var mRemoveButton: UIButton!

    @IBOutlet weak var mStoneLABEL: UILabel!
    @IBOutlet weak var mShapeLABEL: UILabel!
    @IBOutlet weak var mCutLABEL: UILabel!
    @IBOutlet weak var mClarityLABEL: UILabel!
    @IBOutlet weak var mColorLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mPcsLABEL: UILabel!
    
    @IBOutlet weak var mWeightLABEL: UILabel!
    @IBOutlet weak var mSettingLABEL: UILabel!
    @IBOutlet weak var mCertificateLABEL: UILabel!
    
    
    
}
    enum StoneItems : String {
        
        case stone
        case metal
        case size
        case shapeSize
        case color
        case stoneColor
        case shape
        case clarity
        case setting
        case certificateType
        case weight
        case cut

        
    }

enum DropDownItems : String {
    
    case stone
    case metal
    case size
    case shape
    case shapeSize
    case color
    case stoneColor
    case clarity
    case setting
    case certificateType
    case weight
    case cut

    
}
class ProductStoneEdit: UIViewController  , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var mEditTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mProductImage: UIImageView!
    @IBOutlet weak var mMetatag: UILabel!
    @IBOutlet weak var mProductInfo: UILabel!
    @IBOutlet weak var mProductId: UILabel!
    @IBOutlet weak var mSKUName: UILabel!
    @IBOutlet weak var mStockId: UILabel!
    @IBOutlet weak var mVariantStatus: UIImageView!
    @IBOutlet weak var mCurrencyFlag: UIImageView!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mLocation: UILabel!
    @IBOutlet weak var mMetal: UITextField!
    @IBOutlet weak var mChooseMetalButton: UIButton!
    
    @IBOutlet weak var mChooseSizeButton: UIButton!
    
    @IBOutlet weak var mChooseColorButton: UIButton!
    @IBOutlet weak var mColor: UITextField!
    @IBOutlet weak var mSize: UITextField!
    @IBOutlet weak var mGrossWeight: UITextField!
    @IBOutlet weak var mNetWeight: UITextField!
     
    @IBOutlet weak var mEditStoneTable: UITableView!
    @IBOutlet weak var mStoneTable: UITableView!
     
    
    private var mProductData = NSMutableArray()
    var mOriginalData = NSArray()
    var mStoneData = NSMutableArray()
    var mStoneDataMaster = NSArray()
    var mNewStoneData = NSMutableArray()
    var mGlobalShapes = NSArray()
    
    var delegate:EditProductDelegate? = nil

    var mCartId = ""
    var mCustomerId = ""
    
    var mMetalArr = [String]()
    var mMetalIdArr = [String]()
    var mMetalId = ""
    
    var mColorArr = [String]()
    var mColorIdArr = [String]()
    var mColorId = ""
    
    var mSizeArr = [String]()
    var mSizeIdArr = [String]()
    var mSizeId = ""
    
    var mStoneArr = [String]()
    var mStoneIdArr = [String]()
    
    var mShapeArr = [String]()
    var mShapeIdArr = [String]()
    
    var mShapeSizeArr = [String]()
    var mShapeSizeIdArr = [String]()

    var mCutArr = [String]()
    var mCutIdArr = [String]()
    
    var mClarityArr = [String]()
    var mClarityIdArr = [String]()
    
    var mStoneColorArr = [String]()
    var mStoneColorIdArr = [String]()
    
    var mStoneSizeArr = [String]()
    var mStoneSizeIdArr = [String]()
    
    var mCertificateArray = ["GIA","AGS","GEMSCAN","HRD","EGL","UGL","EFCO"]
    var mWeightArray = ["Cts", "Gr"]
    
    var mSettingArr = [String]()
    var mSettingIdArr = [String]()
    var mTableType = ""
    var mProductType = ""
    var isDesign = false
    var isVariant = false
    var isProduct = false

    var mOrderType = ""
    var mProductIds = ""
   
    @IBOutlet weak var mProductIdLABEL: UILabel!
    @IBOutlet weak var mSKULABEL: UILabel!
    @IBOutlet weak var mStockIdLABEL: UILabel!
  
    @IBOutlet weak var mMetalLABEL: UILabel!
    @IBOutlet weak var mColorLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mGrossWeightLABEL: UILabel!
    @IBOutlet weak var mNetWeightLABEL: UILabel!
    @IBOutlet weak var mAddStoneLABEL: UILabel!
    @IBOutlet weak var mApplyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mProductIdLABEL.text = "Product ID".localizedString
        mSKULABEL.text = "SKU".localizedString
        mStockIdLABEL.text = "Stock ID".localizedString
        mMetalLABEL.text = "Metal".localizedString
        mColorLABEL.text = "Color".localizedString
        mSizeLABEL.text = "Size".localizedString
        mGrossWeightLABEL.text = "Gross Wt".localizedString
        mNetWeightLABEL.text = "Net Wt".localizedString
        mAddStoneLABEL.text = "ADD STONE".localizedString
        mApplyButton.setTitle("APPLY".localizedString, for: .normal)
        
        let mParams = [ "order_type":mOrderType,"customer_id":mCustomerId , "custom_cart_id":mCartId] as [String : Any]
        
        mGetData(url: mFetchProductStoneDetails,headers: sGisHeaders,  params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {
                    if let mData = response.value(forKey: "data") as? NSDictionary,
                       let mProductDetails = mData.value(forKey: "product_details") as? NSDictionary {
                        
                        if let isDesign = mProductDetails.value(forKey: "is_design") as? Bool {
                            self.isDesign = isDesign
                        }else {
                            self.isDesign = false
                        }
                        if let isVariant = mProductDetails.value(forKey: "is_variant") as? Bool {
                            self.isVariant = isVariant
                        } else {
                            self.isVariant = false
                        }
                        if let isProduct = mProductDetails.value(forKey: "is_product") as? Bool {
                            self.isProduct = isProduct
                        } else {
                            self.isProduct = false
                        }
                        
                        self.mProductType = "\(mProductDetails.value(forKey: "product_type") ?? "product")"
                        if self.mProductType == "product" {
                            self.mVariantStatus.image = UIImage(named: "diamond_ic")
                            self.mChooseMetalButton.isUserInteractionEnabled = true
                            self.mChooseSizeButton.isUserInteractionEnabled = true
                            self.mMetal.isEnabled = true
                            self.mSize.isEnabled = true
                            self.mColor.isEnabled = true
                            
                            self.mChooseColorButton.isUserInteractionEnabled = true
                            self.mGrossWeight.isUserInteractionEnabled = true
                            self.mNetWeight.isUserInteractionEnabled = true
                            self.mMetal.textColor = UIColor(named: "themeColor")
                            self.mSize.textColor = UIColor(named: "themeColor")
                        }else{
                            self.mMetal.isEnabled = false
                            self.mSize.isEnabled = false
                            self.mColor.isEnabled = false
                            
                            self.mChooseColorButton.isUserInteractionEnabled = false
                            self.mGrossWeight.isUserInteractionEnabled = false
                            self.mNetWeight.isUserInteractionEnabled = false
                            self.mChooseMetalButton.isUserInteractionEnabled = false
                            self.mChooseSizeButton.isUserInteractionEnabled = false
                            self.mMetal.textColor = UIColor(named: "themeLightText")
                            self.mSize.textColor = UIColor(named: "themeLightText")
                            self.mVariantStatus.image = UIImage(named: "variantic")
                        }
                        self.mMetatag.text = "\(mProductDetails.value(forKey: "Matatag") ?? "--")"
                        self.mSKUName.text = "\(mProductDetails.value(forKey: "SKU") ?? "--")"
                        self.mProductInfo.text = "\(mProductDetails.value(forKey: "name") ?? "--")"
                        
                        self.mColor.text = "\(mProductDetails.value(forKey: "color_name") ?? "--")"
                        self.mColorId = "\(mProductDetails.value(forKey: "Color") ?? "")"
                        self.mMetalId = "\(mProductDetails.value(forKey: "Metal") ?? "")"
                        self.mSizeId = "\(mProductDetails.value(forKey: "Size") ?? "")"
                        
                        self.mMetal.text = "\(mProductDetails.value(forKey: "metal_name") ?? "--")"
                        self.mSize.text = "\(mProductDetails.value(forKey: "size_name") ?? "--")"
                        self.mNetWeight.text = "\(mProductDetails.value(forKey: "NetWt") ?? "--")"
                        self.mGrossWeight.text = "\(mProductDetails.value(forKey: "GrossWt") ?? "--")"
                        self.mProductId.text = "\(mProductDetails.value(forKey: "ID") ?? "--")"
                        self.mStockId.text = "\(mProductDetails.value(forKey: "stock_id") ?? "--")"
                        self.mSKUName.text = "\(mProductDetails.value(forKey: "SKU") ?? "--")"
                        
                        if let mStonesData = mProductDetails.value(forKey: "Stones") as? NSArray, mStonesData.count > 0 {
                            self.mStoneData = NSMutableArray(array: mStonesData)
                            self.mStoneTable.delegate = self
                            self.mStoneTable.dataSource = self
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }
                        
                    }
                    
                }else{
                    
                }
            }
        }
        
        self.mEditStoneTable.delegate = self
        self.mEditStoneTable.dataSource = self
        self.mEditStoneTable.reloadData()
        
        mGetDropDownData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mEditStoneTable {
            
            if mNewStoneData.count > 0 {
                self.mEditStoneTable.isHidden = false
                self.mEditTableHeight.constant = CGFloat(mNewStoneData.count * 450)
            }else{
                
                self.mEditStoneTable.isHidden = true
                self.mEditTableHeight.constant = 0
            }
            return mNewStoneData.count
        }
        
        if mStoneData.count > 0 {
            self.mStoneTable.isHidden = false
            self.mTableHeight.constant = CGFloat(mStoneData.count * 450)
        }else{
            
            self.mStoneTable.isHidden = true
            self.mTableHeight.constant = 0
        }
        
        return  mStoneData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        var cell = UITableViewCell()
        if tableView == mStoneTable {
            
            guard let cells = tableView.dequeueReusableCell(withIdentifier: "ProductStoneItems") as? ProductStoneItems else {
                return cell
            }
             
            guard let mData = mStoneData[indexPath.row] as? NSDictionary else {
                return cell
            }

            cells.mChooseCutButton.tag = indexPath.row
            cells.mChooseShapeButton.tag = indexPath.row
            cells.mChooseSizeButton.tag = indexPath.row
            cells.mChooseColorButton.tag = indexPath.row
            cells.mChooseStoneButton.tag = indexPath.row
            cells.mChooseWeightButton.tag = indexPath.row
            cells.mChooseClarityButton.tag = indexPath.row
            cells.mChooseSettingButton.tag = indexPath.row
            cells.mChooseCertificateButton.tag = indexPath.row
            cells.mRemoveButton.tag = indexPath.row
            cells.mWeightValue.tag = indexPath.row
            cells.mPieces.tag = indexPath.row
            cells.mWeightValue.keyboardType = .numberPad
            cells.mPieces.keyboardType = .numberPad
              if mProductType == "variant" {
                cells.mChooseStoneButton.isEnabled = false
                cells.mChooseShapeButton.isEnabled = false
                cells.mChooseCutButton.isEnabled = false
                cells.mChooseClarityButton.isEnabled = false
                cells.mChooseColorButton.isEnabled = false
                  cells.mChooseStoneButton.isUserInteractionEnabled = false
                  cells.mChooseShapeButton.isUserInteractionEnabled = false
                  cells.mChooseCutButton.isUserInteractionEnabled = false
                  cells.mChooseClarityButton.isUserInteractionEnabled = false
                  cells.mChooseColorButton.isUserInteractionEnabled = false
                  cells.mWeightValue.isUserInteractionEnabled = false
                  cells.mStoneName.isUserInteractionEnabled = false
                  cells.mColorName.isUserInteractionEnabled = false
                  cells.mShapeName.isUserInteractionEnabled = false
                  cells.mClarityName.isUserInteractionEnabled = false
                  cells.mCutName.isUserInteractionEnabled = false
                  cells.mSizeName.isUserInteractionEnabled = false
                  cells.mSettingName.isUserInteractionEnabled = false
                  cells.mCertificateName.isUserInteractionEnabled = false
                  cells.mWeightName.isUserInteractionEnabled = false
                  cells.mPieces.isUserInteractionEnabled = false
                  
                cells.mStoneName.textColor = UIColor(named: "themeColor")
                cells.mShapeName.textColor = UIColor(named: "themeColorLight")
                cells.mCutName.textColor = UIColor(named: "themeColorLight")
                cells.mClarityName.textColor = UIColor(named: "themeColorLight")
                cells.mColorName.textColor = UIColor(named: "themeColorLight")
        
              }else if "\(mData.value(forKey: "product_type") ?? "product")" == "product"{
                cells.mChooseStoneButton.isEnabled = true
                 cells.mChooseShapeButton.isEnabled = true
                cells.mChooseCutButton.isEnabled = true
                cells.mChooseClarityButton.isEnabled = true
                cells.mChooseColorButton.isEnabled = true
                  cells.mChooseStoneButton.isUserInteractionEnabled = true
                   cells.mChooseCutButton.isUserInteractionEnabled = true
                  cells.mChooseClarityButton.isUserInteractionEnabled = true
                  cells.mChooseColorButton.isUserInteractionEnabled = true
                  
                  
                  cells.mWeightValue.isUserInteractionEnabled = true
                  cells.mStoneName.isUserInteractionEnabled = true
                  cells.mColorName.isUserInteractionEnabled = true
                  cells.mShapeName.isUserInteractionEnabled = true
                  cells.mClarityName.isUserInteractionEnabled = true
                  cells.mCutName.isUserInteractionEnabled = true
                  cells.mSizeName.isUserInteractionEnabled = true
                  cells.mSettingName.isUserInteractionEnabled = true
                  cells.mCertificateName.isUserInteractionEnabled = true
                  cells.mWeightName.isUserInteractionEnabled = true
                  cells.mPieces.isUserInteractionEnabled = true
                  
                  
                cells.mStoneName.textColor = UIColor(named: "themeColor")
                cells.mShapeName.textColor = UIColor(named: "themeColorLight")
                cells.mCutName.textColor = UIColor(named: "themeColorLight")
                cells.mClarityName.textColor = UIColor(named: "themeColorLight")
                cells.mColorName.textColor = UIColor(named: "themeColorLight")
            }else{
                cells.mWeightValue.isUserInteractionEnabled = true
                cells.mStoneName.isUserInteractionEnabled = true
                cells.mColorName.isUserInteractionEnabled = true
                cells.mShapeName.isUserInteractionEnabled = true
                cells.mClarityName.isUserInteractionEnabled = true
                cells.mCutName.isUserInteractionEnabled = true
                cells.mSizeName.isUserInteractionEnabled = true
                cells.mSettingName.isUserInteractionEnabled = true
                cells.mCertificateName.isUserInteractionEnabled = true
                cells.mWeightName.isUserInteractionEnabled = true
                cells.mPieces.isUserInteractionEnabled = true
                    cells.mChooseStoneButton.isEnabled = true
                    cells.mStoneName.textColor = UIColor(named: "themeLightText")
                    cells.mShapeName.textColor = UIColor(named: "themeLightText")
                    cells.mCutName.textColor = UIColor(named: "themeLightText")
                    cells.mClarityName.textColor = UIColor(named: "themeLightText")
                    cells.mColorName.textColor = UIColor(named: "themeLightText")
                
            }

            
            cells.mWeightValue.text = "\(mData.value(forKey: "Cts") ?? "")"
            cells.mStoneName.text = mGetStoneData(type: .stone, id: "\(mData.value(forKey: "stone") ?? "")")
            cells.mColorName.text = mGetStoneData(type: .stoneColor, id: "\(mData.value(forKey: "color") ?? "")")
            cells.mShapeName.text = mGetStoneData(type: .shape, id: "\(mData.value(forKey: "shape") ?? "")")
            cells.mClarityName.text = mGetStoneData(type: .clarity, id: "\(mData.value(forKey: "clarity") ?? "")")
            cells.mCutName.text = mGetStoneData(type: .cut, id: "\(mData.value(forKey: "Cut") ?? "")")
            cells.mSizeName.text = mGetStoneData(type: .shapeSize, id: "\(mData.value(forKey: "Size") ?? "")")
            cells.mSettingName.text = mGetStoneData(type: .setting, id: "\(mData.value(forKey: "setting_type") ?? "")")
            if let mCertificateData = mData.value(forKey: "certificate") as? NSDictionary {
                cells.mCertificateName.text =  mGetStoneData(type: .certificateType, id: "\(mCertificateData.value(forKey: "type") ?? "")")
            }
            cells.mWeightName.text = mGetStoneData(type: .weight, id: "\(mData.value(forKey: "Unit") ?? "")")
            cells.mPieces.text = "\(mData.value(forKey: "Pcs") ?? "")"
            cells.mStoneName.placeholder = "Select Stone".localizedString
            cells.mCutName.placeholder = "Select Cut".localizedString
            cells.mColorName.placeholder = "Select Color".localizedString
            cells.mClarityName.placeholder = "Select Clarity".localizedString
            cells.mSizeName.placeholder = "Select Size".localizedString
            cells.mSettingName.placeholder = "Select Setting".localizedString
            cells.mCertificateName.placeholder = "Select Certificate".localizedString
            cells.mRemoveButton.setTitle("REMOVE STONE".localizedString, for: .normal)
            cells.mStoneLABEL.text = "Stone".localizedString
            cells.mShapeLABEL.text = "Shape".localizedString
            cells.mCutLABEL.text = "Cut".localizedString
            cells.mClarityLABEL.text = "Clarity".localizedString
            cells.mColorLABEL.text = "Color".localizedString
            cells.mSizeLABEL.text = "Size".localizedString
            cells.mPcsLABEL.text = "Pcs".localizedString
            cells.mWeightLABEL.text = "Weight".localizedString
            cells.mSettingLABEL.text = "Setting".localizedString
            cells.mCertificateLABEL.text = "Certificate".localizedString
            

            return cells
        }else{
            guard let cells = tableView.dequeueReusableCell(withIdentifier: "EditStoneItems") as? EditStoneItems else {
                return cell
            }
       
            guard let mData = mNewStoneData[indexPath.row] as? NSDictionary else {
                return cell
            }

            cells.mChooseCutButton.tag = indexPath.row
            cells.mChooseShapeButton.tag = indexPath.row
            cells.mChooseSizeButton.tag = indexPath.row
            cells.mChooseColorButton.tag = indexPath.row
            cells.mChooseStoneButton.tag = indexPath.row
            cells.mChooseWeightButton.tag = indexPath.row
            cells.mChooseClarityButton.tag = indexPath.row
            cells.mChooseSettingButton.tag = indexPath.row
            cells.mChooseCertificateButton.tag = indexPath.row
            cells.mWeightValue.tag = indexPath.row
            cells.mPieces.tag = indexPath.row
            cells.mWeightValue.keyboardType = .numberPad
            cells.mPieces.keyboardType = .numberPad
            cells.mStoneName.placeholder = "Select Stone".localizedString
            cells.mCutName.placeholder = "Select Cut".localizedString
            cells.mColorName.placeholder = "Select Color".localizedString
            cells.mClarityName.placeholder = "Select Clarity".localizedString
            cells.mSizeName.placeholder = "Select Size".localizedString
            cells.mSettingName.placeholder = "Select Setting".localizedString
            cells.mCertificateName.placeholder = "Select Certificate".localizedString
            cells.mRemoveButton.setTitle("REMOVE STONE".localizedString, for: .normal)
            cells.mStoneLABEL.text = "Stone".localizedString
            cells.mShapeLABEL.text = "Shape".localizedString
            cells.mCutLABEL.text = "Cut".localizedString
            cells.mClarityLABEL.text = "Clarity".localizedString
            cells.mColorLABEL.text = "Color".localizedString
            cells.mSizeLABEL.text = "Size".localizedString
            cells.mPcsLABEL.text = "Pcs".localizedString
            cells.mWeightLABEL.text = "Weight".localizedString
            cells.mSettingLABEL.text = "Setting".localizedString
            cells.mCertificateLABEL.text = "Certificate".localizedString
            
            cells.mWeightValue.text = "\(mData.value(forKey: "Cts") ?? "")"
            cells.mStoneName.text = mGetStoneData(type: .stone, id: "\(mData.value(forKey: "stone") ?? "")")
            cells.mColorName.text = mGetStoneData(type: .stoneColor, id: "\(mData.value(forKey: "color") ?? "")")
            cells.mShapeName.text = mGetStoneData(type: .shape, id: "\(mData.value(forKey: "shape") ?? "")")
            cells.mClarityName.text = mGetStoneData(type: .clarity, id: "\(mData.value(forKey: "clarity") ?? "")")
            cells.mCutName.text = mGetStoneData(type: .cut, id: "\(mData.value(forKey: "Cut") ?? "")")
            cells.mSizeName.text = mGetStoneData(type: .shapeSize, id: "\(mData.value(forKey: "Size") ?? "")")
            cells.mSettingName.text = mGetStoneData(type: .setting, id: "\(mData.value(forKey: "setting_type") ?? "")")
            if let mCertificateData = mData.value(forKey: "certificate") as? NSDictionary {
                cells.mCertificateName.text =  mGetStoneData(type: .certificateType, id: "\(mCertificateData.value(forKey: "type") ?? "")")
            }
            cells.mWeightName.text = mGetStoneData(type: .weight, id: "\(mData.value(forKey: "Unit") ?? "")")
            cells.mPieces.text = "\(mData.value(forKey: "Pcs") ?? "")"
            

            return cells
        }

    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if tableView == mStoneTable {
            return 450
        }
        return 450
    }
    
    
    
    
    @IBAction func mChooseMetal(_ sender: UIButton) {
        if mProductType == "variant" {
             return
        }
        mTableType = "Stone"
        mShowDropDown(type: .metal, view: sender)
    }
    @IBAction func mChooseColor(_ sender: UIButton) {
        if mProductType == "variant" {
             return
        }
        mTableType = "Stone"
        mShowDropDown(type: .color, view: sender)
    }
    
    @IBAction func mChooseSize(_ sender: UIButton) {
        if mProductType == "variant" {
             return
        }
        mTableType = "Stone"
        mShowDropDown(type: .size, view: sender)
    }
    
    
    @IBAction func mChooseStone(_ sender: UIButton) {
        if mProductType == "variant" {
             return
        }
        mTableType = "Stone"
        mShowDropDown(type: .stone, view: sender)
    }
    
    @IBAction func mChooseShape(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .shape, view: sender)
    }
    
    @IBAction func mChooseCut(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .cut, view: sender)
    }
    
    @IBAction func mChooseClarity(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .clarity, view: sender)
    }
    
    @IBAction func mChooseStoneColor(_ sender: UIButton) {
        if mProductType == "variant" {return}

        mTableType = "Stone"
        mShowDropDown(type: .stoneColor, view: sender)
    }
    
    
    @IBAction func mChooseStoneSize(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .shapeSize, view: sender)
    }
    
    @IBAction func mChooseWeight(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .weight, view: sender)
    }
    @IBAction func mChooseSetting(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .setting, view: sender)
    }

    @IBAction func mChooseCertificateType(_ sender: UIButton) {
        if mProductType == "variant" {return}
        mTableType = "Stone"
        mShowDropDown(type: .certificateType, view: sender)
    }
    
    @IBAction func mEditStonePieces(_ sender: UITextField) {
        
        if let mStoneValues = self.mStoneData[sender.tag] as? NSDictionary {
            
            let mData = NSMutableDictionary()
            let mCertificateData = NSMutableDictionary()
            if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
            mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
            mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
            if sender.text != "" {
                mData.setValue(sender.text ?? "", forKey: "Pcs")
            }else{
                mData.setValue("1", forKey: "Pcs")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
            mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
            mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
            mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
            mData.setValue(mCertificateData, forKey: "certificate")
            mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
            mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
            mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
            mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
            mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
            mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
            mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
            mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
            self.mStoneData.removeObject(at: sender.tag)
            self.mStoneData.insert(mData, at: sender.tag)
        }
    }
    
    
    
    @IBAction func mEditStoneWeightValue(_ sender: UITextField) {
        
        if let mStoneValues = self.mStoneData[sender.tag] as? NSDictionary {
            
            let mData = NSMutableDictionary()
            let mCertificateData = NSMutableDictionary()
            if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
            if sender.text != "" {
                mData.setValue(sender.text ?? "", forKey: "Cts")
            }else{
                mData.setValue("0.20", forKey: "Cts")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
            mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
            mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
            mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
            mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
            mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
            mData.setValue(mCertificateData, forKey: "certificate")
            mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
            mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
            mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
            mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
            mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
            mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
            mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
            mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
            self.mStoneData.removeObject(at: sender.tag)
            self.mStoneData.insert(mData, at: sender.tag)
        }
    }
    
    
    @IBAction func mEditNewStonePieces(_ sender: UITextField) {
        
        if let mStoneValues = self.mNewStoneData[sender.tag] as? NSDictionary {
            
            let mData = NSMutableDictionary()
            let mCertificateData = NSMutableDictionary()
            if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
            mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
            mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
            if sender.text != "" {
                mData.setValue(sender.text ?? "", forKey: "Pcs")
            }else{
                mData.setValue("1", forKey: "Pcs")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
            mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
            mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
            mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
            mData.setValue(mCertificateData, forKey: "certificate")
            mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
            mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
            mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
            mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
            mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
            mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
            mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
            mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
            self.mNewStoneData.removeObject(at: sender.tag)
            self.mNewStoneData.insert(mData, at: sender.tag)
        }
    }
    
    
    
    @IBAction func mEditNewWeightValue(_ sender: UITextField) {
        
        if let mStoneValues = self.mNewStoneData[sender.tag] as? NSDictionary {
            
            let mData = NSMutableDictionary()
            let mCertificateData = NSMutableDictionary()
            if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
            if sender.text != "" {
                mData.setValue(sender.text ?? "", forKey: "Cts")
            }else{
                mData.setValue("0.20", forKey: "Cts")
            }
            mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
            mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
            mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
            mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
            mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
            mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
            mData.setValue(mCertificateData, forKey: "certificate")
            mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
            mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
            mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
            mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
            mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
            mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
            mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
            mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
            self.mNewStoneData.removeObject(at: sender.tag)
            self.mNewStoneData.insert(mData, at: sender.tag)
        }
    }
    
    
    @IBAction func mAddStones(_ sender: Any) {
        

        if mProductType == "variant" {
            CommonClass.showSnackBar(message: "Cannot add stones to variant product!")
            return
        }
        
        let mData = NSMutableDictionary()
        let mCertificateData = NSMutableDictionary()
        mCertificateData.setValue("", forKey: "number")
        mCertificateData.setValue("", forKey: "type")
        
        mData.setValue("", forKey: "Align")
        mData.setValue("", forKey: "Cts")
        mData.setValue("", forKey: "Cut")
        mData.setValue("", forKey: "Pcs")
        mData.setValue("", forKey: "Pointer")
        mData.setValue("", forKey: "Price")
        mData.setValue("", forKey: "Size")
        mData.setValue("", forKey: "Variant")
        mData.setValue(mCertificateData, forKey: "certificate")
        mData.setValue("", forKey: "clarity")
        mData.setValue("", forKey: "color")
        mData.setValue("", forKey: "quality")
        mData.setValue("", forKey: "setting_type")
        mData.setValue("", forKey: "shape")
        mData.setValue("", forKey: "stone")
        mData.setValue("", forKey: "Unit")
        mData.setValue("", forKey: "stone_group")
        self.mNewStoneData.add(mData)
        self.mEditStoneTable.isHidden = false
        self.mEditStoneTable.delegate = self
        self.mEditStoneTable.dataSource = self
        self.mEditStoneTable.reloadData()
        self.mEditStoneTable.layoutIfNeeded()
        self.mEditTableHeight.constant = self.mEditStoneTable.contentSize.height + 8
        
    }
    @IBAction func mRemoveStone(_ sender: UIButton) {
        
        let mIndex = sender.tag
        self.mNewStoneData.removeObject(at: mIndex)
        self.mEditStoneTable.delegate = self
        self.mEditStoneTable.dataSource = self
        self.mEditStoneTable.reloadData()
        
        
    }
    @IBAction func mRemoveMainStone(_ sender: UIButton) {
        
        let mIndex = sender.tag
        self.mStoneData.removeObject(at: mIndex)
        self.mStoneTable.delegate = self
        self.mStoneTable.dataSource = self
        self.mStoneTable.reloadData()
        
        
    }
    
    
    
    @IBAction func mChooseNewStone(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .stone, view: sender)
    }
    
    @IBAction func mChooseNewShape(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .shape, view: sender)
    }
    
    @IBAction func mChooseNewCut(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .cut, view: sender)
    }
    
    @IBAction func mChooseNewClarity(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .clarity, view: sender)
    }
    
    @IBAction func mChooseNewStoneColor(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .stoneColor, view: sender)
    }
    
    
    @IBAction func mChooseNewStoneSize(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .shapeSize, view: sender)
    }
    
    @IBAction func mChooseNewWeight(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .weight, view: sender)
    }
    @IBAction func mChooseNewSetting(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .setting, view: sender)
    }

    @IBAction func mChooseNewCertificateType(_ sender: UIButton) {
        mTableType = "NewStone"
        mShowDropDown(type: .certificateType, view: sender)
    }
    

    
    
   
    @IBAction func mApplyNow(_ sender: Any) {
        
    
        let mMetalData = NSMutableDictionary()
        mMetalData.setValue(mColorId, forKey: "Color")
        mMetalData.setValue(mMetalId, forKey: "Metal")
        mMetalData.setValue(mNetWeight.text ?? "", forKey: "NetWt")
        mMetalData.setValue(mNetWeight.text ?? "", forKey: "GrossWt")
        mMetalData.setValue(mSizeId, forKey: "Size")
        mMetalData.setValue(mCustomerId, forKey: "customer_id")
        mMetalData.setValue(mOrderType, forKey: "status_type")
        
        var mMasterStoneData = NSMutableArray()
        for i in mStoneData {
            if let items = i as? NSDictionary {
                mMasterStoneData.add(items)
            }
        }
        for i in mNewStoneData {
            if let items = i as? NSDictionary {
                mMasterStoneData.add(items)
            }
        }

        mMetalData.setValue(mMasterStoneData, forKey: "Stones")


        let mParams = ["productDetails":mMetalData,"cartId":mCartId,]
        as [String : Any]
        CommonClass.showFullLoader(view:self.view)
        
        mGetData(url: mUpdateCustomOrderProduct, headers:sGisHeaders,  params: mParams) { response , status in
            CommonClass.stopLoader()
            if status {
                if let mCode = response.value(forKey: "code")as? Int {
                    if mCode == 200 {
                        self.dismiss(animated: true)
                        self.delegate?.mOnUpdated(data: mMetalData)
                    }else{
                        CommonClass.showSnackBar(message: "Please choose valid combinations!")
                    }
                }
            }else{
 
            }
        }
    }
    
    func mGetDropDownData() {
        if let mGlobalShapeData = UserDefaults.standard.object(forKey: "SHAPES") as? NSDictionary {
            if let mData = mGlobalShapeData.value(forKey: "data") as? NSArray, mData.count > 0 {
                
                self.mGlobalShapes = mData
                self.mShapeArr = [String]()
                self.mShapeIdArr = [String]()
                mGetDropDownData(type: .shape , arr: mData)
                
            }
        }
        
        if let mGraphData = UserDefaults.standard.object(forKey: "GRAPHQL") as? NSDictionary {
            
            if let mData = mGraphData.value(forKey: "data") as? NSDictionary {
                if let mArr = mData.value(forKey: "stones") as? NSArray, mArr.count > 0 {
                    
                    self.mStoneArr = [String]()
                    self.mStoneIdArr = [String]()
                    mGetDropDownData(type: .stone , arr: mArr)
                    
                }
                
                if let mArr = mData.value(forKey: "claritys") as? NSArray, mArr.count > 0 {
                    
                    self.mClarityArr = [String]()
                    self.mClarityIdArr = [String]()
                    mGetDropDownData(type: .clarity , arr: mArr)
                    
                }
                
                if let mArr = mData.value(forKey: "cuts") as? NSArray, mArr.count > 0 {
                    
                    self.mCutArr = [String]()
                    self.mCutIdArr = [String]()
                    mGetDropDownData(type: .cut , arr: mArr)
                    
                }
                
                
                if let mArr = mData.value(forKey: "settingType") as? NSArray, mArr.count > 0 {
                    
                    self.mSettingArr = [String]()
                    self.mSettingIdArr = [String]()
                    mGetDropDownData(type: .setting , arr: mArr)
                    
                }
                
                if let mArr = mData.value(forKey: "stonecolors") as? NSArray, mArr.count > 0 {
                    
                    self.mStoneColorArr = [String]()
                    self.mStoneColorIdArr = [String]()
                    mGetDropDownData(type: .stoneColor , arr: mArr)
                    
                }
                
                if let mArr = mData.value(forKey: "colors") as? NSArray, mArr.count > 0 {
                    
                    self.mColorArr = [String]()
                    self.mColorIdArr = [String]()
                    self.mGetDropDownData(type: .color , arr: mArr)
                    
                }
                
                if let mArr = mData.value(forKey: "metals") as? NSArray, mArr.count > 0 {
                   
                    self.mMetalArr = [String]()
                    self.mMetalIdArr = [String]()
                    self.mGetDropDownData(type: .metal , arr: mArr)
                    
                }
                
                if let mArr = mData.value(forKey: "sizes") as? NSArray, mArr.count > 0 {
                    
                    self.mSizeArr = [String]()
                    self.mSizeIdArr = [String]()
                    self.mGetDropDownData(type: .size , arr: mArr)
                    
                }
            }
            
            
            let mParams = ["id": mProductIds]
            
            mGetData(url: mGetMetalsSizeColor ,headers: sGisHeaders,  params: mParams) { response , status in
                if status {
                    if "\(response.value(forKey: "code") ?? "")" == "200" {
                        if let mData = response.value(forKey: "data") as? NSDictionary {
                            if let mArr = mData.value(forKey: "colors") as? NSArray, mArr.count > 0 {
                                self.mColorArr = [String]()
                                self.mColorIdArr = [String]()
                                self.mGetDropDownData(type: .color , arr: mArr)
                            }
                            
                            if let mArr = mData.value(forKey: "metals") as? NSArray, mArr.count > 0 {
                                self.mMetalArr = [String]()
                                self.mMetalIdArr = [String]()
                                self.mGetDropDownData(type: .metal , arr: mArr)
                            }
                            if let mArr = mData.value(forKey: "sizes") as? NSArray, mArr.count > 0 {
                                self.mSizeArr = [String]()
                                self.mSizeIdArr = [String]()
                                self.mGetDropDownData(type: .size , arr: mArr)
                            }
                        }
                    
                    }else{
                    
                    }
                    
                }
                
            }
            
        }
    
    }
    
    func mGetDropDownData(type:DropDownItems , arr : NSArray){
        for i in arr {
            if let mItems = i as? NSDictionary {
                switch type {
                case .stone:
                    self.mStoneArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mStoneIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .metal:
                    self.mMetalArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mMetalIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .size:
                    self.mSizeArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mSizeIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .color:
                    self.mColorArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mColorIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .stoneColor:
                    self.mStoneColorArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mStoneColorIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .clarity:
                    self.mClarityArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mClarityIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .setting:
                    self.mSettingArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mSettingIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .certificateType:
                    break;
                case .weight:
                    break;
                case .cut:
                    self.mCutArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mCutIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .shape:
                    self.mShapeArr.append("\(mItems.value(forKey: "name") ?? "")")
                    self.mShapeIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                case .shapeSize:
                    self.mShapeSizeArr.append("\(mItems.value(forKey: "stoneSize") ?? "")")
                    self.mShapeSizeIdArr.append("\(mItems.value(forKey: "id") ?? "")")
                }
            }
        }
    }
    
    func mShowDropDown(type:StoneItems , view: UIButton  ){
        let dropdown = DropDown()
        dropdown.anchorView = view
               dropdown.direction = .any
               dropdown.bottomOffset = CGPoint(x: 0, y: view.frame.size.height)
               dropdown.width = view.frame.size.width
                switch type {
                case .stone:
                    dropdown.dataSource = self.mStoneArr
                    dropdown.selectionAction = {
                            [unowned self](index:Int, item: String) in
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(self.mStoneIdArr[index])", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                    }
                case .metal:
                    dropdown.dataSource = self.mMetalArr
                    dropdown.selectionAction = {
                            [unowned self](index:Int, item: String) in
                        self.mMetal.text = item
                        self.mMetalId = self.mMetalIdArr[index]
                        }
                case .size:
                    dropdown.dataSource = self.mSizeArr
                    dropdown.selectionAction = {
                            [unowned self](index:Int, item: String) in
                        self.mSize.text = item
                        self.mSizeId = self.mSizeIdArr[index]
                        }
                case .color:
                    dropdown.dataSource = self.mColorArr
                    dropdown.selectionAction = {
                            [unowned self](index:Int, item: String) in
                        self.mColor.text = item
                        self.mColorId = self.mColorIdArr[index]
                        }
                    dropdown.show()
                case .stoneColor:
                    dropdown.dataSource = self.mStoneColorArr
                    dropdown.selectionAction = {
                            [unowned self](index:Int, item: String) in

                        
                      var mStoneValues = NSDictionary()
                      
                      if self.mTableType == "Stone" {
                          mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                      }else{
                          mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
                        mData.setValue(self.mStoneColorIdArr[index], forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                        
                        
                        }
                case .shape:
                    dropdown.dataSource = self.mShapeArr
                    dropdown.selectionAction = {
                        [unowned self](index:Int, item: String) in
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")" , forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue(self.mShapeIdArr[index], forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            
                            if let mSizeData = self.mGlobalShapes[index] as? NSDictionary {
                                if let mArr = mSizeData.value(forKey: "sizeItems") as? NSArray, mArr.count > 0 {
                                    self.mShapeSizeArr = [String]()
                                    self.mShapeSizeIdArr = [String]()
                                    mGetDropDownData(type: .shapeSize , arr: mArr)
                                }
                            }
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            
                            if let mSizeData = self.mGlobalShapes[index] as? NSDictionary {
                                if let mArr = mSizeData.value(forKey: "sizeItems") as? NSArray , mArr.count > 0 {
                                    self.mShapeSizeArr = [String]()
                                    self.mShapeSizeIdArr = [String]()
                                    mGetDropDownData(type: .shapeSize , arr: mArr)
                                }
                                self.mEditStoneTable.reloadData()
                            }
                        }
                    }
                case .shapeSize:
                    dropdown.dataSource = self.mShapeSizeArr
                    dropdown.selectionAction = {
                        [unowned self](index:Int, item: String) in
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue(self.mShapeSizeIdArr[index], forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")" , forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                    }
                case .clarity:
                    dropdown.dataSource = self.mClarityArr
                    dropdown.selectionAction = {
                        [unowned self](index:Int, item: String) in
                        
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                       
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue(self.mClarityIdArr[index], forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                        
                    }
                case .setting:
                    dropdown.dataSource = self.mSettingArr
                    dropdown.selectionAction = {
                        [unowned self](index:Int, item: String) in
                        
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue(self.mSettingIdArr[index], forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                        
                    }
                case .certificateType:
                    dropdown.dataSource = self.mCertificateArray
                    dropdown.selectionAction = {
                        [unowned self](index:Int, item: String) in
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue(self.mCertificateArray[index], forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                    }
                case .weight:
                    dropdown.dataSource = self.mWeightArray
                    dropdown.selectionAction = {
                            [unowned self](index:Int, item: String) in
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                          }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue("\(mStoneValues.value(forKey: "Cut") ?? "")", forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue(self.mWeightArray[index], forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                        }
                case .cut:
                    dropdown.dataSource = self.mCutArr
                    dropdown.selectionAction = {
                        [unowned self](index:Int, item: String) in
                        var mStoneValues = NSDictionary()
                        
                        if self.mTableType == "Stone" {
                            mStoneValues = self.mStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }else{
                            mStoneValues = self.mNewStoneData[view.tag] as? NSDictionary ?? NSDictionary()
                        }
                        
                        let mData = NSMutableDictionary()
                        let mCertificateData = NSMutableDictionary()
                        if let mCertificateValues = mStoneValues.value(forKey: "certificate") as? NSDictionary {
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "number") ?? "")", forKey: "number")
                            mCertificateData.setValue("\(mCertificateValues.value(forKey: "type") ?? "")", forKey: "type")
                        }
                        mData.setValue("\(mStoneValues.value(forKey: "Align") ?? "")", forKey: "Align")
                        mData.setValue("\(mStoneValues.value(forKey: "Cts") ?? "")", forKey: "Cts")
                        mData.setValue(self.mCutIdArr[index], forKey: "Cut")
                        mData.setValue("\(mStoneValues.value(forKey: "Pcs") ?? "")", forKey: "Pcs")
                        mData.setValue("\(mStoneValues.value(forKey: "Pointer") ?? "")", forKey: "Pointer")
                        mData.setValue("\(mStoneValues.value(forKey: "Price") ?? "")", forKey: "Price")
                        mData.setValue("\(mStoneValues.value(forKey: "Size") ?? "")", forKey: "Size")
                        mData.setValue("\(mStoneValues.value(forKey: "Variant") ?? "")", forKey: "Variant")
                        mData.setValue(mCertificateData, forKey: "certificate")
                        mData.setValue("\(mStoneValues.value(forKey: "clarity") ?? "")", forKey: "clarity")
                        mData.setValue("\(mStoneValues.value(forKey: "color") ?? "")", forKey: "color")
                        mData.setValue("\(mStoneValues.value(forKey: "quality") ?? "")", forKey: "quality")
                        mData.setValue("\(mStoneValues.value(forKey: "setting_type") ?? "")", forKey: "setting_type")
                        mData.setValue("\(mStoneValues.value(forKey: "shape") ?? "")", forKey: "shape")
                        mData.setValue("\(mStoneValues.value(forKey: "stone") ?? "")", forKey: "stone")
                        mData.setValue("\(mStoneValues.value(forKey: "Unit") ?? "")", forKey: "Unit")
                        mData.setValue("\(mStoneValues.value(forKey: "stone_group") ?? "")", forKey: "stone_group")
                        if self.mTableType == "Stone" {
                            self.mStoneData.removeObject(at: view.tag)
                            self.mStoneData.insert(mData, at: view.tag)
                            self.mStoneTable.reloadData()
                            self.mRefreshTable()
                        }else{
                            self.mNewStoneData.removeObject(at: view.tag)
                            self.mNewStoneData.insert(mData, at: view.tag)
                            self.mEditStoneTable.reloadData()
                        }
                        
                        
                    }
                }
        
        dropdown.show()

     }

    func mGetStoneData(type:StoneItems, id:String) -> String {
        var mValue = "--"
        if let mGraphData = UserDefaults.standard.object(forKey: "GRAPHQL") as? NSDictionary {
            if let mData = mGraphData.value(forKey: "data") as? NSDictionary {
                
                switch type {
                case .stone:
                    if let mArr = mData.value(forKey: "stones") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .color:
                    if let mArr = mData.value(forKey: "colors") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .stoneColor:
                    if let mArr = mData.value(forKey: "stonecolors") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .metal:
                    if let mArr = mData.value(forKey: "metals") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .size:
                    if let mArr = mData.value(forKey: "sizes") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .clarity:
                    if let mArr = mData.value(forKey: "claritys") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .cut:
                    if let mArr = mData.value(forKey: "cuts") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .shape:
                    if self.mGlobalShapes.count > 0 {
                        let mArr = self.mGlobalShapes
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .setting:
                    if let mArr = mData.value(forKey: "settingType") as? NSArray {
                        mValue = mCompareIds(arr: mArr, id: id)
                    }
                case .certificateType:
                    for i in self.mCertificateArray {
                        if i == id {
                            mValue = i
                            break
                        }
                    }
                    
                    
                case .weight:
                    for i in self.mWeightArray {
                        if i == id {
                            mValue = i
                            break
                        }
                    }
                    
                case .shapeSize:
                    
                    for i in self.mGlobalShapes {
                        if let items =  i as? NSDictionary {
                            if let mSizeData = items.value(forKey: "sizeItems") as? NSArray, mSizeData.count > 0 {
                                for sizes in mSizeData {
                                    if let mSizeItems = sizes as? NSDictionary {
                                        if id == "\(mSizeItems.value(forKey: "id") ?? "")" {
                                            mValue = "\(mSizeItems.value(forKey: "stoneSize") ?? "")"
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }

            
        }
        
        
        return mValue
        
        
    }
    func mRefreshTable(){
        self.mStoneTable.layoutIfNeeded()
        self.mTableHeight.constant = CGFloat(mStoneData.count * 450)
     }
    func mCompareIds(arr : NSArray , id: String) -> String {
        var mValue = ""
        if arr.count > 0{
             for i in arr {
                 if let mItems = i as? NSDictionary {
                     if "\(mItems.value(forKey: "id") ?? "")" == id {
                         mValue = "\(mItems.value(forKey: "name") ?? "")"
                         break
                     }
                 }
            }
        }
        return mValue
    }
}
