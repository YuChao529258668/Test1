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
  File name     : mtc_payment.h
  Module        : pyament client
  Author        : xinyu.qian
  Created on    : 2017-06-12
  Description   :
      Data structure and function declare required by MTC payment

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_PAYMENT_H__
#define _MTC_PAYMENT_H__

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
 * @file mtc_payment.h
 * @brief MTC Payment Interface Functions
 *
 * This file includes Payment interface function.
 */
 
 /**
 * @defgroup MtcPaymentKey MTC notification key for Payment.
 * @{
 */
 
 /**
 * @brief A key whose value is a number object reflecting
 * the reason code of the response i.e.the exact error when something went wrong.
 */
#define MtcResponseReasonKey           "MtcResponseReasonKey"

/** @} */

/**
 * @defgroup MtcPaymentNotification MTC notification names for Payment.
 * @{
 */
 
 /**
 * @brief Posted when insert into DB successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcPaymentRecordOkNotification "MtcPaymentRecordOkNotification"

 /**
 * @brief Posted when insert into DB failed.
 *
 * The pcInfo of this notification contains @ref MtcResponseReasonKey, 
 */
#define MtcPaymentRecordDidFailNotification "MtcPaymentRecordDidFailNotification"

 /**
 * @brief Posted when get user credit successfully.
 *
 * The pcInfo of this notification contains "accountId" "userId" "credit".
 */
#define MtcGetCreditOkNotification "MtcGetCreditOkNotification"

 /**
 * @brief Posted when get user credit failed.
 *
 * The pcInfo of this notification contains "reason", 
 */
#define MtcGetCreditDidFailNotification "MtcGetCreditDidFailNotification"

 /**
 * @brief Posted when get user payment history successfully.
 *
 * The pcInfo of this notification contains "accountId" "userId" "orderList".
 */
#define MtcGetPaymentHistoryOkNotification "MtcGetPaymentHistoryOkNotification"

 /**
 * @brief Posted when get user payment history failed.
 *
 * The pcInfo of this notification contains "reason", 
 */
#define MtcGetPaymentHistoryDidFailNotification "MtcGetPaymentHistoryDidFailNotification"

 /**
 * @brief Posted when get user consume history successfully.
 *
 * The pcInfo of this notification contains "accountId" "userId" "orderList".
 */
#define MtcGetConsumeHistoryOkNotification "MtcGetConsumeHistoryOkNotification"

 /**
 * @brief Posted when get user consume history failed.
 *
 * The pcInfo of this notification contains "reason", 
 */
#define MtcGetConsumeHistoryDidFailNotification "MtcGetConsumeHistoryDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif
 
/**
 * @brief Write payment record to DB.
 * 
 * @param  zCookie The UI cookie value.
 * @param  pcInfo Information in JSON, probably contains 
                "accountId" "cost" "orderId" "orderTime" "purchaseToken"
                "appName" "platform" "product" "redundancy"

 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_PaymentRecord(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/**
 * @brief Get user credit.
 * 
 * @param  zCookie The UI cookie value.
 * @param  pcInfo Information in JSON, probably contains "accountId"

 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GetCredit(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/**
 * @brief Get user payment history.
 * 
 * @param  zCookie The UI cookie value.
 * @param  pcInfo Information in JSON, probably contains "accountId"

 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GetPaymentHistory(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/**
 * @brief Get user consume history.
 * 
 * @param  zCookie The UI cookie value.
 * @param  pcInfo Information in JSON, probably contains "accountId"

 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GetConsumeHistory(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);
   
#ifdef __cplusplus
}
#endif

#endif /* _MTC_PAYMENT_H__ */