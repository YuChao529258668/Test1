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
  File name     : mtc_rdcall.h
  Module        : multimedia talk client
  Author        : xiangbo.hui
  Created on    : 2015-03-27
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_RDCALL_H__
#define _MTC_RDCALL_H__

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
 * @file mtc_rdcall.h
 * @brief MTC Rdcall Interface Functions
 *
 * This file includes rdcall interface function.
 */

/**
 * @defgroup MtcRdcallKey MTC notification key for rdcall.
 * @{
 */

/**
 * @brief A key whose value is a string object reflecting
 * the user's ID.
 */
#define MtcRdcallUserUriKey         "MtcRdcallUserUriKey"

/**
 * @brief A key whose value is a number object reflecting
 * the user's gender.
 */
#define MtcRdcallGenderKey          "MtcRdcallGenderKey"

/**
 * @brief A key whose value is a string object reflecting
 * the nick name.
 */
#define MtcRdcallNickNameKey        "MtcRdcallNickNameKey"

/**
 * @brief A key whose value is a number object reflecting
 * the birthday.
 */
#define MtcRdcallBirthdayKey        "MtcRdcallBirthdayKey"

/**
 * @brief A key whose value is a string object reflecting
 * the avatar.
 */
#define MtcRdcallAvatarKey          "MtcRdcallAvatarKey"

/** @} */

/**
 * @defgroup MtcRdcallNotification MTC notification names for rdcall.
 * @{
 */
/**
 * @brief Posted when set profile successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcRdCallSetProfileOkNotification "MtcRdCallSetProfileOkNotification"

/**
 * @brief Posted when failed to set profile.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcRdCallSetProfileDidFailNotification "MtcRdCallSetProfileDidFailNotification"

/**
 * @brief Posted when get profile successfully.
 *
 * The pcInfo of this notification contains @ref MtcRdcallUserUriKey,
 * @ref MtcRdcallGenderKey, @ref MtcRdcallNickNameKey,
 * @ref MtcRdcallBirthdayKey, @ref MtcRdcallAvatarKey.
 */
#define MtcRdCallGetProfileOkNotification "MtcRdCallGetProfileOkNotification"

/**
 * @brief Posted when failed to get profile.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcRdCallGetProfileDidFailNotification "MtcRdCallGetProfileDidFailNotification"

/**
 * @brief Posted when set participate successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcRdCallSetParticipateOkNotification "MtcRdCallSetParticipateOkNotification"

/**
 * @brief Posted when failed to set participate.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcRdCallSetParticipateDidFailNotification "MtcRdCallSetParticipateDidFailNotification"

/**
 * @brief Posted when get random user successfully.
 *
 * The pcInfo of this notification is @ref MtcRdcallUserUriKey.
 */
#define MtcRdCallGetRandomUserOkNotification "MtcRdCallGetRandomUserOkNotification"

/**
 * @brief Posted when failed to get random user.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcRdCallGetRandomUserDidFailNotification "MtcRdCallGetRandomUserDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Set basic profile
 *
 * @param  zCookie The UI cookie value.
 * @param  pcInfo The profile information.
 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_RdCallSetBasicProfile(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcInfo);

/**
 * @brief Get basic profile
 * 
 * @param  zCookie The UI cookie value.
 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_RdCallGetBasicProfile(ZCOOKIE zCookie);

/**
 * @brief Set participate flag.
 * 
 * @param  zCookie The UI cookie value.
 * @param  bParticipate ZTRUE to participate.
 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_RdCallSetParticipate(ZCOOKIE zCookie,
    ZBOOL bParticipate);

/**
 * @brief Get random user.
 * 
 * @param  zCookie The UI cookie value.
 * 
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_RdCallGetRandomUser(ZCOOKIE zCookie);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_RDCALL_H__ */

