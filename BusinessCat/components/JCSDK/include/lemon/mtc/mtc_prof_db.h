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
  File name     : mtc_prof_db.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
      Data structure and function declare required by MTC profile DB

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_PROF_DB_H__
#define _MTC_PROF_DB_H__

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
 * @file mtc_prof_db.h
 * @brief MTC Profile Database Interface Functions.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Get application version from database.
 *
 * @return Application version.
 *
 * @see @ref Mtc_ProfDbSetAppVer
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProfDbGetAppVer(ZFUNC_VOID);

/**
 * @brief Set application version from database.
 *
 * @param [in] pcAppVer The application version.
 *
 * @retval ZOK Set application version successfully.
 * @retval ZFAILED Set application version failed.
 *
 * @see @ref Mtc_ProfDbGetAppVer
 */
MTCFUNC ZINT Mtc_ProfDbSetAppVer(ZCONST ZCHAR *pcAppVer);

/**
 * @brief Get remember password option from database.
 *
 * @retval ZTRUE Remember password.
 * @retval ZFALSE Do not remember password.
 *
 * @see @ref Mtc_ProfDbSetRemPwd
 */
MTCFUNC ZBOOL Mtc_ProfDbGetRemPwd(ZFUNC_VOID);

/**
 * @brief Set remember password option.
 *
 * @param [in] bRember The option of remembering password.
 *
 * @retval ZOK Set remember password option successfully.
 * @retval ZFAILED Set remember password option failed.
 *
 * @see @ref Mtc_ProfDbGetRemPwd
 */
MTCFUNC ZINT Mtc_ProfDbSetRemPwd(ZBOOL bRember);

/**
 * @brief Get the user automatically login option from database.
 *
 * @retval ZTRUE User will automatically login.
 * @retval ZFALSE User will not automatically login.
 *
 * @see @ref Mtc_ProfDbSetAutoLogin
 */
MTCFUNC ZBOOL Mtc_ProfDbGetAutoLogin(ZFUNC_VOID);

/**
 * @brief Set the user automatically login option.
 *
 * @param [in] bAuto User automatically login option.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option option failed.
 *
 * @see @ref Mtc_ProfDbGetAutoLogin
 */
MTCFUNC ZINT Mtc_ProfDbSetAutoLogin(ZBOOL bAuto);

/**
 * @brief Get avatar file name.
 *
 * @return The string of avatar file name.
 *
 * @see @ref Mtc_ProfDbSetAvatarFile
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProfDbGetAvatarFile(ZFUNC_VOID);

/**
 * @brief Set avatar file name.
 *
 * @param [in] pcFileName Avatar file name.
 *
 * @retval ZOK Set avatar file name successfully.
 * @retval ZFAILED Set avatar file name failed.
 *
 * @see @ref Mtc_ProfDbGetAvatarFile
 */
MTCFUNC ZINT Mtc_ProfDbSetAvatarFile(ZCONST ZCHAR *pcFileName);

/**
 * @brief Get country code.
 *
 * @return The string of country code.
 *
 * @see @ref Mtc_ProfDbSetCountryCode
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProfDbGetCountryCode(ZFUNC_VOID);

/**
 * @brief Set country code.
 *
 * @param [in] pcCountryCode Country code.
 *
 * @retval ZOK Set country code successfully.
 * @retval ZFAILED Set country code failed.
 *
 * @see @ref Mtc_ProfDbGetCountryCode
 */
MTCFUNC ZINT Mtc_ProfDbSetCountryCode(ZCONST ZCHAR *pcCountryCode);

/**
 * @brief Get the client provisioning enable from database.
 *
 * @retval ZTRUE Start client provisioning.
 * @retval ZFALSE Do not start client provisioning.
 *
 * @see @ref Mtc_ProfDbSetCpEnable
 */
MTCFUNC ZBOOL Mtc_ProfDbGetCpEnable();

/**
 * @brief Set client provisioning enable.
 *
 * @param [in] bCpEnable The client provisioning option.
 *
 * @retval ZOK Set the client provisioning option successfully.
 * @retval ZFAILED Set the client provisioning option failed.
 *
 * @see @ref Mtc_ProfDbGetCpEnable
 */
MTCFUNC ZINT Mtc_ProfDbSetCpEnable(ZBOOL bCpEnable);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 *
 * @retval ZNULL if no parameter which do not exist, or the parameter value.
 *
 * @see @ref Mtc_ProfDbSetExtParm
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProfDbGetExtParm(ZCONST ZCHAR *pcName);

/**
 * @brief Set extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] pcValue The parameter value.
 *
 * @retval ZOK Set the parameter successfully.
 * @retval ZFAILED Set the parameter failed.
 *
 * @see @ref Mtc_ProfDbGetExtParm
 */
MTCFUNC ZINT Mtc_ProfDbSetExtParm(ZCONST ZCHAR *pcName, ZCONST ZCHAR *pcValue);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_PROF_DB_H__ */

