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
  File name     : mtc_api.h
  Module        : multimedia talk client
  Author        : Young
  Created on    : 2015-01-14
  Description   :
      Function and notification declare required by mtc api
 
  Modify History:
  1. Date:        Author:         Modification:
*************************************************/

#import <Foundation/Foundation.h>
#import <avatar/zos/zos_type.h>

/**
 * @file mtc_api.h
 * @brief MTC api Interface Functions
 *
 */

/**
 * @defgroup MtcApiNotification Notification of login and logout event.
 * @{
 */

/**
 * @brief Posted when invoke Mtc_Login and login successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcLoginOkNotification "MtcLoginOkNotification"

/**
 * @brief Posted when invoke Mtc_Login but login unsuccessfully.
 *
 * The pcInfo of this notification contains @ref MtcCliStatusCodeKey
 * reflecting failed reason.
 */
#define MtcLoginDidFailNotification "MtcLoginDidFailNotification"

/**
 * @brief Posted when invoke Mtc_Logout and logout successfully. The logout
 * action was requested by user.
 *
 * The pcInfo of this notification contains @ref MtcCliStatusCodeKey
 * reflecting response code from server.
 */
#define MtcDidLogoutNotification "MtcDidLogoutNotification"

/**
 * @brief Posted when client receives the message which indicates
 * the registration was invalid.
 *
 * The pcInfo of this notification contains @ref MtcCliStatusCodeKey
 * reflecting detail information from server.
 */
#define MtcLogoutedNotification "MtcLogoutedNotification"
/** @} */

/**
 * @brief A key whose value is a string of the server address.
 */
#define MtcNetworkAddressKey "MtcNetworkAddressKey"
#define MtcEntryAddressKey "MtcEntryAddressKey"
#define MtcPasswordKey "MtcPasswordKey"
#define MtcDeviceIdKey "MtcDeviceIdKey"
#define MtcIdTypeKey "MtcIdTypeKey"
#define MtcAppKey "MtcAppKey"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Initialize Resource.
 *
 * @retval ZOK Initialize resource successfully.
 * @retval ZFAILED Initialize resource failed.
 *
 * @see @ref Mtc_Destroy
 */
ZINT Mtc_Init(ZFUNC_VOID);

/**
 * @brief Destroy Resource.
 *
 * @see @ref Mtc_Init
 */
ZVOID Mtc_Destroy(ZFUNC_VOID);

/**
 * @brief Start to Login.
 *
 * @param [in] pcAccount The account what you want to login.
 * @param [in] info The configration info such as server address, you can 
 * ceate a dictionary by use MtcEntryAddressKey.
 *
 * If login successfully, Login result is notified by the notification which
 * is MtcLoginOkNotification. Otherwise, login failed and login result is 
 * notified by the notification which is MtcLoginDidFailNotification.
 * You can register these notification and do something in the notification
 * callbacks, such as alert user the login result.
 *
 * @retval ZOK Login successfully.
 * @retval ZFAILED Login failed.
 *
 * @see @ref Mtc_Logout @ref Mtc_LoginPassword
 */
ZINT Mtc_Login(ZCONST ZCHAR *pcAccount, NSDictionary *info);

/**
 * @brief Start to Logout.
 *
 * If the return value returns ZOK, Logout result is notified by the
 * notification which is MtcDidLogoutNotification. You can register the 
 * notification and do something in the notification callbacks,
 * such as alert user already logouted.
 *
 * And also you should register the MtcLogoutedNotification and do something 
 * in the notification callbacks. Such as when your account login another
 * device, the MtcLogoutedNotification will be notified.
 *
 * @retval ZOK Logout successfully.
 * @retval ZFAILED Logout failed.
 *
 * @see @ref Mtc_Login @ref Mtc_LoginPassword
 */
ZINT Mtc_Logout(ZFUNC_VOID);

#ifdef __cplusplus
}
#endif

