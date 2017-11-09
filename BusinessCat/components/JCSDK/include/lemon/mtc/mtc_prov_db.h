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
  File name     : mtc_prov_db.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
      Data structure and function declare required by MTC provision database.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_PROV_DB_H__
#define _MTC_PROV_DB_H__

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
 * @file mtc_prov_db.h
 * @brief MTC Provision Database Interface Functions.
 *
 * Provision Database contain client global configuration
 * beside account profile. For example, auto run client when PC startup.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Get the automatically start on PC option from database.
 *
 * @return Automatically start on PC option.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetLoginOnPC(ZFUNC_VOID);

/**
 * @brief Get the using manual local IP option from database.
 *
 * @return Automatically start on PC option.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetManualIp(ZFUNC_VOID);

/**
 * @brief Get the GUI show debug window option from database.
 *
 * @return Show debug window option.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetGuiShowDbg(ZFUNC_VOID);

/**
 * @brief Get the MME dump debug option from database.
 *
 * @return MME dump debug option.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetMmeDumpDbg(ZFUNC_VOID);

/**
 * @brief Get the MME log level from database.
 *
 * @return MME log level number.
 */
MTCFUNC ZUCHAR Mtc_ProvDbGetMmeLogLevel(ZFUNC_VOID);

/**
 * @brief Get the mvd sync audio option from database.
 *
 * @return mvc record debug option.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetMvdSyncAudio(ZFUNC_VOID);

/**
 * @brief Get the current profile user from database.
 *
 * @return Current profile user.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetCurProfUser(ZFUNC_VOID);

/**
 * @brief Get emergency server realm.
 *
 * The general emergency call flow is like below:
 * -# No any account has logined
 * -# initialize the client
 * -# Mtc_CliInit(profile director);
 * -# initialize callback functions
 * -# Mtc_CliCbSetPrint(print callback);
 * -# Mtc_CallCbSetAlerted(alerted callback);
 * -# Mtc_CallCbSetTalking(talking callback);
 * -# Mtc_CallCbSetTermed(terminated callback);
 * -# Mtc_CallCbSetError(error callback);
 * -# Open an null account Mtc_CliOpen(ZNULL)
 * -# Start client service Mtc_CliStart()
 * -# Get Emergency server info by @ref Mtc_ProvDbGetEmgAddr
 * -# Set local and server parameters:
 * @code
   Mtc_CliDbSetSipLclTcpPort(5060);
   Mtc_CliDbSetSipLclTcpPort(5060);
   Mtc_CliDbSetSipRegIp(pcProxyAddr);
   Mtc_CliDbSetSipRegPort(5060);
   Mtc_CliDbSetSipRegRealm(pcProxyRealm);
   Mtc_CliDbSetSipRegTpt(EN_MSP_TPT_UDP);
   Mtc_CliDbSetUserReg(ZTRUE);
   Mtc_CliDbSetAuthName("unknown");
   Mtc_CliDbSetAuthPass("unknown");
 * @endcode
 *
 * @return Default emergency server realm.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetEmgRealm(ZFUNC_VOID);

/**
 * @brief Get the emergency server address from database.
 *
 * @return Default emergency server address.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetEmgAddr(ZFUNC_VOID);

/**
 * @brief Get the default register realm from database.
 *
 * @return Default register realm.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetDftRegRealm(ZFUNC_VOID);

/**
 * @brief Get the default proxy address from database.
 *
 * @return Default proxy address.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetDftProxyAddr(ZFUNC_VOID);

/**
 * @brief Get the default authentication name in register realm from database.
 *
 * @return Default authentication name in realm.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetDftAuthNameInRealm(ZFUNC_VOID);

/**
 * @brief Get the default subscribe register event from database.
 *
 * @return Default subscribe register event.
 */
MTCFUNC ZBOOL Mtc_ProvDbGetDftSubRegEvnt(ZFUNC_VOID);

/**
 * @brief Get the default ring directory.
 *
 * @return Default ring directory.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetDftRingDir(ZFUNC_VOID);

/**
 * @brief Get ARC TCP mode option.
 *
 * @retval ZTRUE Use ARC TCP mode.
 * @retval ZFALSE Use default mode.
 *
 * @see Mtc_ProvDbSetArcTcpMode
 */
MTCFUNC ZBOOL Mtc_ProvDbGetArcTcpMode(ZFUNC_VOID);

/**
 * @brief Get commit session statistics option.
 *
 * @retval ZTRUE Commit session statistics.
 * @retval ZFALSE Not ot commit session statistics.
 *
 * @see Mtc_ProvDbSetCommitSessSts
 */
MTCFUNC ZBOOL Mtc_ProvDbGetCommitSessSts(ZFUNC_VOID);

/**
 * @brief Get the default temporary directory.
 *
 * @return Default temporary directory.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetTempDir(ZFUNC_VOID);

/**
 * @brief Set automatically start on PC option.
 *
 * @param [in] bEnable The boolean value.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option failed.
 *
 * @see @ref Mtc_ProvDbGetLoginOnPC
 */
MTCFUNC ZINT Mtc_ProvDbSetLoginOnPC(ZBOOL bEnable);

/**
 * @brief Set using manual local IP option.
 *
 * @param [in] bEnable The boolean value.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option failed.
 *
 * @see @ref Mtc_ProvDbGetManualIp
 */
MTCFUNC ZINT Mtc_ProvDbSetManualIp(ZBOOL bEnable);

/**
 * @brief Set MME dump information to file option.
 *
 * @param [in] bEnable The boolean value.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option failed.
 *
 * @see @ref Mtc_ProvDbGetMmeDumpDbg
 */
MTCFUNC ZINT Mtc_ProvDbSetMmeDumpDbg(ZBOOL bEnable);

/**
 * @brief Set MME log level.
 *
 * @param [in] ucLevel Log level number, 0 is no log, bigger number for more log.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option failed.
 *
 * @see @ref Mtc_ProvDbGetMmeDumpDbg
 */
MTCFUNC ZINT Mtc_ProvDbSetMmeLogLevel(ZUCHAR ucLevel);

/**
 * @brief Set current profile user.
 *
 * @param [in] pcUser The profile user name.
 *
 * @retval ZOK Set the profile user successfully.
 * @retval ZFAILED Set the profile user failed.
 *
 * @see @ref Mtc_ProvDbGetCurProfUser
 */
MTCFUNC ZINT Mtc_ProvDbSetCurProfUser(ZCONST ZCHAR *pcUser);

/**
 * @brief Set default ring directory.
 *
 * @param [in] pcDir The default ring directory.
 *
 * @retval ZOK Set the default ring directory successfully.
 * @retval ZFAILED Set the default ring directory failed.
 *
 * @see @ref Mtc_ProvDbGetDftRingDir
 */
MTCFUNC ZINT Mtc_ProvDbSetDftRingDir(ZCONST ZCHAR *pcDir);

/**
 * @brief Set ARC TCP mode option.
 *
 * @param [in] bEnable ZTRUE to use TCP mode, ZFALSE for default mode.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_ProvDbGetArcTcpMode
 */
MTCFUNC ZINT Mtc_ProvDbSetArcTcpMode(ZBOOL bEnable);

/**
 * @brief Set commit session statistics option.
 *
 * @param [in] bEnable ZTRUE to commit session statistics, ZFALSE for not commit.
 *
 * @retval ZOK Set commit session statistics option successfully.
 * @retval ZFAILED Set commit session statistics option failed.
 *
 * @see @ref Mtc_ProvDbGetCommitSessSts
 */
MTCFUNC ZINT Mtc_ProvDbSetCommitSessSts(ZBOOL bEnable);

/**
 * @brief Set default temporary directory.
 *
 * @param [in] pcDir The default temporary directory.
 *
 * @retval ZOK Set the default temporary directory successfully.
 * @retval ZFAILED Set the default temporary directory failed.
 *
 * @see @ref Mtc_ProvDbGetTempDir
 */
MTCFUNC ZINT Mtc_ProvDbSetTempDir(ZCONST ZCHAR *pcDir);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [out] ppcParm The parameter value.
 *
 * @retval ZOK get extension parameter successfully.
 * @retval ZFAILED get extension parameter failed, 
 *                 the extension parameter is not exist.
 *
 * @see @ref Mtc_ProvDbSetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbGetExtnParm(ZCONST ZCHAR *pcName, ZCONST ZCHAR **ppcParm);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [out] pbParm The parameter value.
 *
 * @retval ZOK get extension parameter successfully.
 * @retval ZFAILED get extension parameter failed, 
 *                 the extension parameter is not exist.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbGetExtnParmBool(ZCONST ZCHAR *pcName, ZBOOL *pbParm);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [out] piParm The parameter value.
 *
 * @retval ZOK get extension parameter successfully.
 * @retval ZFAILED get extension parameter failed, 
 *                 the extension parameter is not exist.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbGetExtnParmInt(ZCONST ZCHAR *pcName, ZINT *piParm);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [out] piParm The parameter value.
 *
 * @retval ZOK get extension parameter successfully.
 * @retval ZFAILED get extension parameter failed, 
 *                 the extension parameter is not exist.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbGetExtnParmUint(ZCONST ZCHAR *pcName, ZUINT *piParm);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] iIndex The parameter index.
 *
 * @return The parameter value when get extension parameter successfully, 
 *              otherwise return empty string.
 *
 * @see @ref Mtc_ProvDbSetExtnParm
 */
MTCFUNC ZCONST ZCHAR * Mtc_ProvDbGetExtnParmX(ZCONST ZCHAR *pcName, ZINT iIndex);

/**
 * @brief Get extension parameter.
 *
 * @param [in] pcName The parameter name.
 *
 * @retval ZOK Get the parameter count successfully.
 * @retval ZFAILED Get the parameter count failed.
 *
 * @see @ref Mtc_ProvDbSetExtnParm
 */
MTCFUNC ZUINT Mtc_ProvDbGetExtnParmCount(ZCONST ZCHAR *pcName);

/**
 * @brief Set extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] pcVal The parameter value.
 *
 * @retval ZOK Set the parameter successfully.
 * @retval ZFAILED Set the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbSetExtnParm(ZCONST ZCHAR *pcName, ZCONST ZCHAR *pcVal);

/**
 * @brief Set extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] bVal The parameter value.
 *
 * @retval ZOK Set the parameter successfully.
 * @retval ZFAILED Set the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbSetExtnParmBool(ZCONST ZCHAR *pcName, ZBOOL bVal);

/**
 * @brief Set extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] iVal The parameter value.
 *
 * @retval ZOK Set the parameter successfully.
 * @retval ZFAILED Set the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbSetExtnParmInt(ZCONST ZCHAR *pcName, ZINT iVal);

/**
 * @brief Set extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] iVal The parameter value.
 *
 * @retval ZOK Set the parameter successfully.
 * @retval ZFAILED Set the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbSetExtnParmUint(ZCONST ZCHAR *pcName, ZUINT iVal);

/**
 * @brief Add extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] pcVal The parameter value.
 *
 * @retval ZOK Add the parameter successfully.
 * @retval ZFAILED Add the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbAddExtnParm(ZCONST ZCHAR *pcName, ZCONST ZCHAR *pcVal);

/**
 * @brief Add extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] wNameLen The parameter name length.
 * @param [in] pcVal The parameter value.
 * @param [in] wValLen The parameter value length.
 *
 * @retval ZOK Add the parameter successfully.
 * @retval ZFAILED Add the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbAddExtnParmN(ZCONST ZCHAR *pcName, ZUSHORT wNameLen,
                ZCONST ZCHAR *pcVal, ZUSHORT wValLen);

/**
 * @brief Remove extension parameter.
 *
 * @param [in] pcName The parameter name.
 *
 * @retval ZOK Remove the parameter successfully.
 * @retval ZFAILED Remove the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbRmvExtnParm(ZCONST ZCHAR *pcName);

/**
 * @brief Remove extension parameter.
 *
 * @param [in] pcName The parameter name.
 * @param [in] wNameLen The parameter name length.
 *
 * @retval ZOK Remove the parameter successfully.
 * @retval ZFAILED Remove the parameter failed.
 *
 * @see @ref Mtc_ProvDbGetExtnParm
 */
MTCFUNC ZINT Mtc_ProvDbRmvExtnParmN(ZCONST ZCHAR *pcName, ZUSHORT wNameLen);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_PROV_DB_H__ */

