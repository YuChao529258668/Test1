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
  File name     : mtc_ue_contact.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
      Function implement required by MTC contact.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_UE_CONTACT_H__
#define _MTC_UE_CONTACT_H__

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
 * @file mtc_ue_contact.h
 * @brief MTC Ue Contact Interface Functions
 */

/**
 * @defgroup MtcUeContactsKey MTC notification key for user entry.
 * @{
 */

/**
 * @brief A key whose value is a json string reflecting
 * the user's URI.
 */
#define MtcUeContactUserUriKey          "MtcUeContactUserUriKey"

/**
 * @brief A key whose value is a json string reflecting Contact Id .
 *  
 */
#define MtcUeContactIdKey               "MtcUeContactIdKey"
/** @} */

/**
 * @defgroup MtcUeNotification MTC notification names for user entry.
 * @{
 */

/**
 * @brief Posted when specific user is found.
 *
 * The pcInfo of this notification contains @ref MtcUeContactUserUriKey.
 */
#define MtcUeContactQueryOkNotification "MtcUeContactQueryOkNotification"

/**
 * @brief Posted when query for specific user is failed.
 *
 * The pcInfo of this notification contains @ref MtcUeContactUserUriKey and
 * @ref MtcUeReasonKey.
 *
 * @ref MtcUeReasonKey contains the failed reason.
 * @ref EN_MTC_UE_REASON_ACCOUNT_NOT_EXIST indicates query user is not exist.
 * Other indicates query failed.
 */
#define MtcUeContactQueryDidFailNotification "MtcUeContactQueryDidFailNotification"

/**
 * @brief Posted when specific user is found.
 *
 * The pcInfo of this notification contains @ref MtcUeContactIdKey.
 */
#define MtcUeContactQueryByIdOkNotification "MtcUeContactQueryByIdOkNotification"

/**
 * @brief Posted when query for specific user is failed.
 *
 * The pcInfo of this notification contains @ref MtcUeContactIdKey and
 * @ref MtcUeReasonKey.
 *
 * @ref MtcUeReasonKey contains the failed reason.
 * @ref EN_MTC_UE_REASON_ACCOUNT_NOT_EXIST indicates query user is not exist.
 * Other indicates query failed.
 */
#define MtcUeContactQueryByIdDidFailNotification "MtcUeContactQueryByIdDidFailNotification"

 /**
 * @brief Posted when query for contacts is done.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeContactQueryAllOkNotification "MtcUeContactQueryAllOkNotification"

/**
 * @brief Posted when query for contacts is failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeContactQueryAllDidFailNotification "MtcUeContactQueryAllDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/** 
 * @brief MTC user entry find contact.
 *
 * @param [in] zCookie   The cookie which you want to set.
 * @param [in] pcUserUri The user's URI queries for. Using @ref Mtc_UserFormUri
 *                       to format the URI.
 *
 * @retval ZOK ok , refelect this interface have called Success, 
 *                  will have one of Notification:
 *                  see @ref  MtcUeContactQueryOkNotification
 *                  see @ref  MtcUeContactQueryDidFailNotification
 *                                                                                    
 * @retval ZFAILED failed, refelect this interface have called failed , have no any Notification
 */
MTCFUNC ZINT Mtc_UeContactQuery(ZCOOKIE zCookie, ZCONST ZCHAR *pcUserUri);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CONTACT_H__ */

