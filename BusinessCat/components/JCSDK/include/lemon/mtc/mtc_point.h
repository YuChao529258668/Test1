/************************************************************************

        Copyright (c) 2005-2011 by Juphoon System Software, Inc.
                       All rights reserved.

     This software is confidential and proprietary to Juphoon System,
     Inc. No part of this software may be reproduced, stored, transmitted,
     disclosed or used in any form or by any means other than as expressly
     provided by the written license agreement between Juphoon and its
     licensee.

     THIS SOFTWARE IS PROVIDED BY JUPHOON "AS IS" AND ANY EXPRESS OR 
     IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
     ARE DISCLAIMED. IN NO EVENT SHALL JUPHOON BE LIABLE FOR ANY DIRECT, 
     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
     OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
     STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
     IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
     POSSIBILITY OF SUCH DAMAGE. 

                    Juphoon System Software, Inc.
                    Email: support@juphoon.com
                    Web: http://www.juphoon.com

************************************************************************/
/*************************************************
  File name     : mtc_point.h
  Module        : point client
  Author        : junjie.wang
  Created on    : 2015-12-01
  Description   :
      Data structure and function declare required by MTC Point

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_POINT_H__
#define _MTC_POINT_H__

#include <avatar/zos/zos_type.h>

#ifndef MTCFUNC
#if defined(MTC_DLL_EXPORT)
#define MTCFUNC ZFUNC_EXPORT
#elif defined(MTC_DLL_IMPORT)
#define MTCFUNC ZFUNC_IMPORT
#else
#define MTCFUNC
#endif
#endif

/**
 * @file mtc_point.h
 * @brief MTC Point Interface Functions
 *
 * This file includes point interface function.
 */

/**
 * @brief A source key from server to present that the bill
 * is generated by daily sign.
 */
#define MtcPointBillSourceDailySign "daily_sign"

/**
 * @brief A source key from server to present that the bill
 * is generated by buying something in store.
 */
#define MtcPointBillSourceStore "juspoint_store"

/**
 * @brief The direction of a bill to present user earn points
 */
#define MtcPointBillDirectionIn 1

/**
 * @brief The direction of a bill to present user consume points
 */
#define MtcPointBillDirectionOut -1

/**
 * @brief Failed to purchase because point is not enough
 */
#define MtcPointReasonNotEnoughPoint "no_enough_juspoint"

/**
 * @brief Failed to purchase because the item is not available
 */
#define MtcPointReasonNotAvailable "no_such_item"

/**
 * @defgroup MtcPointKey MTC notification key for point.
 * @{
 */

/**
 * @brief A key whose value is a number object reflecting
 * the point.
 */
#define MtcPointPointKey            "MtcPointPointKey"

/**
 * @brief A key whose value is a number object reflecting
 * the point that expires soon.
 */
#define MtcPointExpireSoonPointKey  "MtcPointExpireSoonPointKey"

/**
 * @brief A key whose value is a number object reflecting
 * the direction of a bill.
 */
#define MtcPointBillDirectionKey    "MtcPointBillDirectionKey"

/**
 * @brief A key whose value is a boolean object reflecting
 * whether the bill is refund.
 */
#define MtcPointBillIsRefundKey     "MtcPointBillIsRefundKey"

/**
 * @brief A key whose value is a string object reflecting
 * the source of a bill.
 */
#define MtcPointBillSourceKey       "MtcPointBillSourceKey"

/**
 * @brief A key whose value is a string object reflecting
 * the description of a bill.
 */
#define MtcPointBillCommentKey      "MtcPointBillCommentKey"

/**
 * @brief A key whose value is a number object reflecting
 * the effect time of a bill.
 */
#define MtcPointBillEffectTimeKey   "MtcPointBillEffectTimeKey"

/**
 * @brief A key whose value is a number object reflecting
 * the expire time of a bill.
 */
#define MtcPointBillExpireTimeKey   "MtcPointBillExpireTimeKey"

/**
 * @brief A key whose value is a boolean object reflecting
 * the sign result.
 */
#define MtcPointSignResultKey       "MtcPointSignResultKey"

/**
 * @brief A key whose value is a number object reflecting
 * the next sign time delta.
 */
#define MtcPointNextSignTimeKey     "MtcPointNextSignTimeKey"

/**
 * @brief A key whose value is a string object reflecting
 * the reason of a failed sign.
 */
#define MtcPointSignReasonKey       "MtcPointSignReasonKey"

/**
 * @brief A key whose value is a number object reflecting
 * the number of continuous sign days.
 */
#define MtcPointSignDaysKey         "MtcPointSignDaysKey"

/**
 * @brief A key whose value is a boolean object reflecting
 * whether today user has signed in.
 */
#define MtcPointSignTodayKey        "MtcPointSignTodayKey"

/**
 * @brief A key whose value is a number object reflecting
 * the quantity of the item.
 */
#define MtcPointItemQuantityKey     "MtcPointItemQuantityKey"

/**
 * @brief A key whose value is a date object reflecting
 * when the item is expired.
 */
#define MtcPointItemExpireKey       "MtcPointItemExpireKey"

/**
 * @brief A key whose value is a string object reflecting
 * the reason of a failed purchase.
 */
#define MtcPointPurchaseReasonKey   "MtcPointPurchaseReasonKey"

/**
 * @brief A key whose value is a string object reflecting
 * the id of an item to purchase.
 */
#define MtcPointItemIdKey           "MtcPointItemIdKey"

/**
 * @brief A key whose value is a string object reflecting
 * the name of an item to purchase.
 */
#define MtcPointItemNameKey         "MtcPointItemNameKey"

/**
 * @brief A key whose value is a string object reflecting
 * the type of an item to purchase.
 */
#define MtcPointItemTypeKey         "MtcPointItemTypeKey"

/**
 * @brief A key whose value is a string object reflecting
 * the id of a package to purchase.
 */
#define MtcPointPackageIdKey        "MtcPointPackageIdKey"

/**
 * @brief A key whose value is a string object reflecting
 * the name of a package to purchase.
 */
#define MtcPointPackageNameKey      "MtcPointPackageNameKey"

/**
 * @brief A key whose value is a string object reflecting
 * the duration of an item to purchase.
 */
#define MtcPointItemDurationKey     "MtcPointItemDurationKey"

/**
 * @brief A key whose value is a string object reflecting
 * the purchase type.
 */
#define MtcPointPurchaseTypeKey     "MtcPointPurchaseTypeKey"

/**
 * @brief A key whose value is a string object reflecting
 * the price of a package to purchase.
 */
#define MtcPointPackagePriceKey     "MtcPointPackagePriceKey"

/**
 * @brief A key whose value is a string object reflecting
 * the status of a package to purchase.
 */
#define MtcPointStatusKey           "MtcPointStatusKey"

/**
 * @brief A key whose value is a string object reflecting
 * the update time of a package to purchase.
 */
#define MtcPointUpdateTimeKey       "MtcPointUpdateTimeKey"

/** @} */

/**
 * @defgroup MtcPointNotification MTC notification names for point.
 * @{
 */
/**
 * @brief Posted when get points successfully.
 *
 * The pcInfo of this notification contains @ref MtcPointPointKey.
 */
#define MtcPointGetPointsOkNotification "MtcPointGetPointsOkNotification"

/**
 * @brief Posted when failed to get points.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetPointsDidFailNotification "MtcPointGetPointsDidFailNotification"

/**
 * @brief Posted when get expire soon points successfully.
 *
 * The pcInfo of this notification contains @ref MtcPointExpireSoonPointKey.
 */
#define MtcPointGetPointsExpireSoonOkNotification "MtcPointGetPointsExpireSoonOkNotification"

/**
 * @brief Posted when failed to get expire soon points.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetPointsExpireSoonDidFailNotification "MtcPointGetPointsExpireSoonDidFailNotification"

/**
 * @brief Posted when get bill list successfully.
 *
 * The pcInfo of this notification contains a list of structure of
 * @ref MtcPointPointKey,
 * @ref MtcPointBillDirectionKey,
 * @ref MtcPointBillIsRefundKey,
 * @ref MtcPointBillSourceKey,
 * @ref MtcPointBillCommentKey,
 * @ref MtcPointBillEffectTimeKey,
 * @ref MtcPointBillExpireTimeKey.
 */
#define MtcPointGetBillListOkNotification "MtcPointGetBillListOkNotification"

/**
 * @brief Posted when failed to get bill list.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetBillListDidFailNotification "MtcPointGetBillListDidFailNotification"

/**
 * @brief Posted when get bill list by page successfully.
 *
 * The pcInfo of this notification contains a list of structure of
 * @ref MtcPointPointKey,
 * @ref MtcPointBillDirectionKey,
 * @ref MtcPointBillIsRefundKey,
 * @ref MtcPointBillSourceKey,
 * @ref MtcPointBillCommentKey,
 * @ref MtcPointBillEffectTimeKey,
 * @ref MtcPointBillExpireTimeKey.
 */
#define MtcPointGetBillListByCountOkNotification "MtcPointGetBillListByCountOkNotification"

/**
 * @brief Posted when failed to get bill list by page.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetBillListByCountDidFailNotification "MtcPointGetBillListByCountDidFailNotification"

/**
 * @brief Posted when daily sign successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcPointPointKey,
 * @ref MtcPointSignResultKey,
 * @ref MtcPointNextSignTimeKey,
 * @ref MtcPointSignReasonKey.
 */
#define MtcPointDailySignOkNotification "MtcPointDailySignOkNotification"

/**
 * @brief Posted when failed to daily sign.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointDailySignDidFailNotification "MtcPointDailySignDidFailNotification"

/**
 * @brief Posted when get sign days successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcPointSignDaysKey
 */
#define MtcPointGetSignDaysOkNotification "MtcPointGetSignDaysOkNotification"

/**
 * @brief Posted when failed to get sign days.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetSignDaysDidFailNotification "MtcPointGetSignDaysDidFailNotification"

/**
 * @brief Posted when get today sign successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcPointSignTodayKey,
 * @ref MtcPointNextSignTimeKey.
 */
#define MtcPointGetTodaySignOkNotification "MtcPointGetTodaySignOkNotification"

/**
 * @brief Posted when failed to get today sign.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetTodaySignDidFailNotification "MtcPointGetTodaySignDidFailNotification"

/**
 * @brief Posted when get purchased item successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcPointItemQuantityKey,
 * @ref MtcPointItemExpireKey.
 */
#define MtcPointGetPurchasedItemOkNotification "MtcPointGetPurchasedItemOkNotification"

/**
 * @brief Posted when failed to get purchased item.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetPurchasedItemDidFailNotification "MtcPointGetPurchasedItemDidFailNotification"

/**
 * @brief Posted when get purchased items successfully.
 *
 * The pcInfo of this notification is an array, the element contains
 * @ref MtcPointItemIdKey,
 * @ref MtcPointItemQuantityKey,
 * @ref MtcPointItemExpireKey.
 */
#define MtcPointGetPurchasedItemsOkNotification "MtcPointGetPurchasedItemsOkNotification"

/**
 * @brief Posted when failed to get purchased items.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetPurchasedItemsDidFailNotification "MtcPointGetPurchasedItemsDidFailNotification"

/**
 * @brief Posted when purchase package successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointPurchasePackageOkNotification "MtcPointPurchasePackageOkNotification"

/**
 * @brief Posted when failed to purchase package.
 *
 * The pcInfo of this notification contains
 * @ref MtcPointPurchaseReasonKey.
 */
#define MtcPointPurchasePackageDidFailNotification "MtcPointPurchasePackageDidFailNotification"

/**
 * @brief Posted when get available items successfully.
 *
 * The pcInfo of this notification contains a list of structure of
 * @ref MtcPointItemIdKey,
 * @ref MtcPointItemNameKey,
 * @ref MtcPointItemTypeKey,
 * @ref MtcPointPackageIdKey,
 * @ref MtcPointPackageNameKey,
 * @ref MtcPointItemQuantityKey,
 * @ref MtcPointItemDurationKey,
 * @ref MtcPointPurchaseTypeKey,
 * @ref MtcPointPackagePriceKey,
 * @ref MtcPointStatusKey,
 * @ref MtcPointUpdateTimeKey.
 */
#define MtcPointGetAvailablePackagesOkNotification "MtcPointGetAvailablePackagesOkNotification"

/**
 * @brief Posted when failed to get available items.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetAvailablePackagesDidFailNotification "MtcPointGetAvailablePackagesDidFailNotification"

/**
 * @brief Posted when get own items successfully.
 *
 * The pcInfo of this notification contains a list of structure of
 * @ref MtcPointItemIdKey,
 * @ref MtcPointItemNameKey,
 * @ref MtcPointItemTypeKey,
 * @ref MtcPointItemQuantityKey,
 * @ref MtcPointItemExpireKey,
 * @ref MtcPointStatusKey,
 * @ref MtcPointUpdateTimeKey.
 */
#define MtcPointGetOwnItemsOkNotification "MtcPointGetOwnItemsOkNotification"

/**
 * @brief Posted when failed to get own items.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPointGetOwnItemsDidFailNotification "MtcPointGetOwnItemsDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Get points.
 * @param  zCookie The cookie value.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetPoints(ZCOOKIE zCookie);

/**
 * @brief Get points that expires soon in some days.
 * @param  zCookie The cookie value.
 * @param  iDays The days to collect the result.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetPointsExpireSoon(ZCOOKIE zCookie, ZINT iDays);

/**
 * @brief Get bill list.
 * @param  zCookie The cookie value.
 * @param  dwStartTime The start time to collect data.
 * @param  dwEndTime The end time to collect data.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetBillList(ZCOOKIE zCookie,
    ZINT64 dwStartTime, ZINT64 dwEndTime);

/**
 * @brief Get bill list by page.
 * @param  zCookie The cookie value.
 * @param  dwEndTime The end time to collect data.
 * @param  iCount The count of items to query.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetBillListByCount(ZCOOKIE zCookie,
    ZINT64 dwEndTime, ZUINT iCount);

/**
 * @brief Daily sign.
 * @param  zCookie The cookie value.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointDailySign(ZCOOKIE zCookie);

/**
 * @brief Get continuous signed days.
 * @param  zCookie The cookie value.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetSignDays(ZCOOKIE zCookie);

/**
 * @brief Get whether today is signed.
 * @param  zCookie The cookie value.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetTodaySign(ZCOOKIE zCookie);

/**
 * @brief Get purchased item data.
 * @param  zCookie The cookie value.
 * @param  pcItemId The id of the item.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetPurchasedItem(ZCOOKIE zCookie, ZCONST ZCHAR *pcItemId);

/**
 * @brief Get purchased data of items.
 * @param  zCookie The cookie value.
 * @param  pcItemIdArray The array of the item ids.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetPurchasedItems(ZCOOKIE zCookie, ZCONST ZCHAR *pcItemIdArray);

/**
 * @brief Puchase package.
 * @param  zCookie The cookie value.
 * @param  pcItemId The id of the item.
 * @param  pcPackageId The package id of the package.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointPurchasePackage(ZCOOKIE zCookie, ZCONST ZCHAR *pcItemId, ZCONST ZCHAR *pcPackageId);

/**
 * @brief Get available packages to purchase.
 * @param  zCookie The cookie value.
 * @param  iStartId The id before the first package, should be 0 for first page of packages.
 * @param  iCount The count of packages to query.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetAvailablePackages(ZCOOKIE zCookie, ZUINT iStartId, ZUINT iCount);

/**
 * @brief Get own items of the user.
 * @param  zCookie The cookie value.
 * @param  iStartId The id before the first item, should be 0 for first page of items.
 * @param  iCount The count of items to query.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PointGetOwnItems(ZCOOKIE zCookie, ZUINT iStartId, ZUINT iCount);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_POINT_H__ */

