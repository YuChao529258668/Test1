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
  File name     : mtc_cc.h
  Module        : multimedia talk client
  Author        : bob.liu
  Created on    : 2016-03-29
  Description   :

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CC_H__
#define _MTC_CC_H__

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

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @file mtc_cc.h
 * @brief MTC Call Center Interface Functions
 *
 * This file includes callcenter interface function.
 */

/** @brief apply type of operationmanager. */
typedef enum EN_MTC_CC_OM_APPLY_TYPE
{
    EN_MTC_CC_OM_APPLY_UNKNOWN = -1,
    EN_MTC_CC_OM_APPLY_RING    = 0,
    EN_MTC_CC_OM_APPLY_REJECT,
    EN_MTC_CC_OM_APPLY_ANSWER,
    EN_MTC_CC_OM_APPLY_TERMINATE,
    EN_MTC_CC_OM_APPLY_BREAK,
    EN_MTC_CC_OM_APPLY_RESUME,
}EN_MTC_CC_OM_APPLY_TYPE;

/** @brief apply type of operationmanager. */
typedef enum EN_MTC_CC_STAFF_ROLE_TYPE
{
    EN_MTC_CC_STAFF_ROLE_UNKNOWN = -1,
    EN_MTC_CC_STAFF_ROLE_JUNIOR  = 0,
    EN_MTC_CC_STAFF_ROLE_SENIOR,
    EN_MTC_CC_STAFF_ROLE_EXPERT,
    EN_MTC_CC_STAFF_ROLE_MONITOR,
    EN_MTC_CC_STAFF_ROLE_ADMINISTRATOR,
}EN_MTC_CC_STAFF_ROLE_TYPE;

/**
 * @defgroup MtcCcKey MTC notification key of call center.
 * @{
 */

/**
 * @brief A key whose value is a string object reflecting
 * the error reason.
 */
#define MtcCcErrorKey                 "MtcCcErrorKey"

/**
 * @brief A key whose value is a number Acd waiting
 */
#define MtcCcWaitCountKey             "MtcCcWaitCountKey"

/** @} */

/**
 * @defgroup MtcCcNotification MTC notification of call center.
 * @{
 */

/**
 * @brief Posted when create successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey,
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 */
#define MtcCcCreateOkNotification       "MtcCcCreateOkNotification"

/**
 * @brief Posted when create failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey,
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcCcErrorKey
 */
#define MtcCcCreateDidFailNotification  "MtcCcCreateDidFailNotification"

/**
 * @brief Posted when checkin successfully.
 *
 */
#define MtcCcCheckInOkNotification      "MtcCcCheckInOkNotification"

/**
 * @brief Posted when checkin failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcCcErrorKey
 */
#define MtcCcCheckInDidFailNotification "MtcCcCheckInDidFailNotification"

/**
 * @brief Posted when checkout successfully.
 *
 */
#define MtcCcCheckOutOkNotification     "MtcCcCheckOutOkNotification"

/**
 * @brief Posted when checkout failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcCcErrorKey
 */
#define MtcCcCheckOutDidFailNotification    "MtcCcCheckOutDidFailNotification"

/**
 * @brief Posted when apply successfully.
 *
 */
#define MtcCcApplyOkNotification        "MtcCcApplyOkNotification"

/**
 * @brief Posted when apply failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcCcErrorKey
 */
#define MtcCcApplyDidFailNotification   "MtcCcApplyDidFailNotification"

/**
 * @brief Posted when keep alive successfully.
 *
 */
#define MtcCcKeepAliveOkNotification    "MtcCcKeepAliveOkNotification"

/**
 * @brief Posted when keep alice failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcCcErrorKey
 */
#define MtcCcKeepAliveDidFailNotification   "MtcCcKeepAliveDidFailNotification"
/** @} */

/**
 * @brief Posted when received data message.
 *
 */
#define MtcCcGetWaitCountOkNotification     "MtcCcGetWaitCountOkNotification"

/**
 * @brief Posted when received data message.
 *
 */
#define MtcCcGetWaitCountDidFailNotification     "MtcCcGetWaitCountDidFailNotification"

/**
 * @brief create call center meeting.
 * 
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] pcServiceTelNum The Service TelNum value.
 * @param [in] bVideo ZTRUE for video conference, ZFALSE for voice conference.
 * @param [in] pcSerialNo serial No.
 * @param [in] pcParm parameters.
 *
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CcCreate(ZCOOKIE zCookie, ZCONST ZCHAR *pcServiceTelNum,
    ZBOOL bVideo, ZCONST ZCHAR *pcSerialNo, ZCONST ZCHAR *pcParm);

/**
 * @brief check in with role.
 * 
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] pcStarffId ID of Operation Manager.
 * @param [in] pcGroupId ID of group.
 * @param [in] iStaffRole Role of Operation Manager.
 *             iStaffRole value @ref EN_MTC_CC_STAFF_ROLE_TYPE
 *
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CcCheckIn(ZCOOKIE zCookie, ZCONST ZCHAR *pcStarffId,
    ZCONST ZCHAR *pcGroupId, ZINT iStaffRole);

/**
 * @brief check out.
 * 
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CcCheckOut(ZCOOKIE zCookie);

/**
 * @brief apply the status of Operation Manager.
 * 
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] iType type of Operation Manager.
 *             iType value @ref EN_MTC_CC_OM_APPLY_TYPE
 *
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CcApply(ZCOOKIE zCookie, ZINT iType);

/**
 * @brief keep alive.
 * 
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CcKeepAlive(ZCOOKIE zCookie);

/**
 * @brief get acd waiting person count.
 * 
 * @retval count on succeed. 
 * @retval ZMAXUINT on failure.
 */
MTCFUNC ZINT Mtc_CcGetWaitCount();

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CC_H__ */

