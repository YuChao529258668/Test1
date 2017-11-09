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
  File name     : mtc_util.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
      Data structure and function declare required by MTC utility

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_UTIL_H__
#define _MTC_UTIL_H__

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
 * @file mtc_util.h
 * @brief MTC Utility Interface Functions.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Print ERROR log with format string information.
 * User can specific log name as the log module prefix
 * Log print level can be set by Mtc_CliDbSetLogLevel.
 *
 * @param [in] pcLogName The log name. Default name is "ZOS" if no log name.
 * @param [in] pcFormat String format.
 * @param [in] ... String vars.
 *
 * @see @ref Mtc_AnyLogInfoStr
 */
MTCFUNC ZVOID Mtc_AnyLogErrStr(ZCHAR *pcLogName, ZCHAR *pcFormat, ...);

/**
 * @brief Print INFO log with format string information.
 * User can specific log name as the log module prefix
 * Log print level can be set by Mtc_CliDbSetLogLevel.
 *
 * @param [in] pcLogName The log name. Default name is "ZOS" if no log name.
 * @param [in] pcFormat String format.
 * @param [in] ... String vars.
 *
 * @see @ref Mtc_AnyLogErrStr
 */
MTCFUNC ZVOID Mtc_AnyLogInfoStr(ZCHAR *pcLogName, ZCHAR *pcFormat, ...);

/**
 * @brief Print DEBUG log with format string information.
 * User can specific log name as the log module prefix
 * Log print level can be set by Mtc_DbSetLogLevel.
 *
 * @param [in] pcLogName The log name. Default name is "ZOS" if no log name.
 * @param [in] pcFormat String format.
 * @param [in] ... String vars.
 *
 * @see @ref Mtc_AnyLogInfoStr
 */
MTCFUNC ZVOID Mtc_AnyLogDbgStr(ZCHAR *pcLogName, ZCHAR *pcFormat, ...);

/**
 * @brief Get local ip count.
 *
 * @return Local ip count successfully, otherwise retrun 0.
 *
 * @see @ref Mtc_GetLclIp
 */
MTCFUNC ZINT Mtc_GetLclIpCnt();

/**
 * @brief Get local ip.
 *
 * @param [in] iIndex Local ip index.
 *
 * @return Local ip successfully, otherwise return loopback address.
 *    the caller must copy it, then use.
 *
 * @see @ref Mtc_GetLclIpCnt
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetLclIp(ZINT iIndex);

/**
 * @brief Get access network type.
 *
 * @return Access network type successfully, 
 * otherwise return MTC_ANET_UNKNOWN.
 *
 * @see @ref group_def_access_net_type
 */
MTCFUNC ZINT Mtc_GetAccessNetType();

/**
 * @defgroup MtcError MTC error string.
 * @{
 */
/** @brief No environment. MTC maynot initilized or already destroied. */
#define MTC_ERROR_NO_ENV                "Mtc.NoEnv"

/** @brief Invalid state. MTC maynot started. */
#define MTC_ERROR_INV_STATE             "Mtc.InvState"

/** @brief During auth. MTC during authorization. */
#define MTC_ERROR_IN_AUTH               "Mtc.InAuth"

/** @brief Invlaid parameter. */
#define MTC_ERROR_INV_PARM              "Mtc.InvParm"

/** @brief Allocate memory. */
#define MTC_ERROR_ALLOC_MEM             "Mtc.AllocMem"

/** @brief New Object. */
#define MTC_ERROR_NEW_OBJ               "Mtc.NewObj"

/** @brief No Agent. */
#define MTC_ERROR_NO_AGENT              "Mtc.NoAgent"

/** @brief Invalid ID */
#define MTC_ERROR_INV_ID                "Mtc.InvId"

/** @brief Invalid URI */
#define MTC_ERROR_INV_URI               "Mtc.InvUri"

/** @brief No password. */
#define MTC_ERROR_NO_PWD                "Mtc.NoPwd"

/** @brief Invalid password */
#define MTC_ERROR_INV_PWD               "Mtc.InvPwd"

/** @brief Subscribe event. */
#define MTC_ERROR_SUB_EVNT              "Mtc.SubEvnt"

/** @brief Provision. */
#define MTC_ERROR_PROVISION             "Mtc.Provision"

/** @brief Authorizaiton failed. */
#define MTC_ERROR_AUTH_FAIL             "Mtc.AuthFail"

/** @brief No account. */
#define MTC_ERROR_NO_ACCOUNT            "Mtc.NoAccount"

/** @brief Expired. */
#define MTC_ERROR_EXPIRED               "Mtc.Expired"

/** @brief No auth code. */
#define MTC_ERROR_NO_AUTH               "Mtc.NoAuth"

/** @brief Internal error. */
#define MTC_ERROR_INTERNAL              "Mtc.Internal"

/** @brief Call initialize connection. */
#define MTC_ERROR_CALL_INIT_CONN        "MtcCall.InitConn"

/** @brief Call initialize session. */
#define MTC_ERROR_CALL_INIT_SESS        "MtcCall.InitSess"

/** @brief Call add audio stream. */
#define MTC_ERROR_CALL_ADD_AUDIO_STRM   "MtcCall.AddAudioStrm"

/** @brief Call add video stream. */
#define MTC_ERROR_CALL_ADD_VIDEO_STRM   "MtcCall.AddVideoStrm"

/** @brief Call no SIP registeration. */
#define MTC_ERROR_CALL_NO_SIP_REG       "MtcCall.NoSipReg"

/** @brief Call exist */
#define MTC_ERROR_CALL_EXIST            "MtcCall.Exist"

/** @brief Call read SDP. */
#define MTC_ERROR_CALL_READ_SDP         "MtcCall.ReadSdp"

/** @brief Call fill SDP. */
#define MTC_ERROR_CALL_FILL_SDP         "MtcCall.FillSdp"

/** @brief Call perform action. */
#define MTC_ERROR_CALL_ACTION           "MtcCall.Action"

/** @brief Call negotiation. */
#define MTC_ERROR_CALL_NEGOTIATION      "MtcCall.Nego"

/** @brief Call timeout. */
#define MTC_ERROR_CALL_TIMEOUT          "MtcCall.Timeout"

/**
 * @}
 */

/** 
 * @brief Get last error.
 *
 * @retval Last error string.
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetLastError(ZFUNC_VOID);

typedef ZINT (*PFN_MTCSHCMD)(ZINT iArgc, ZCHAR *apcArgv[]);

/**
 * @brief Init shell.
 */
MTCFUNC ZINT Mtc_ShInit();

/**
 * @brief Add shell command.
 *
 * @param pcCmd Command name.
 * @param pcDesc Command description.
 * @param pcSynop Synopsis.
 * @param pfnCmd Command process entry.
 */
MTCFUNC ZINT Mtc_ShCmdAdd(ZCONST ZCHAR *pcCmd, ZCONST ZCHAR *pcDesc,
    ZCONST ZCHAR *pcSynop, PFN_MTCSHCMD pfnCmd);

/**
 * @brief Start run shell.
 */
MTCFUNC ZINT Mtc_ShRun();

/**
 * @brief Get option from arguments.
 *
 * @param [in] iArgc Argument count.
 * @param [in] apcArgv Argument string table.
 * @param [in] pcOptStr Option string.
 * @param [out] ppcArg Current argument string.
 *
 * @retval -1 Indicate the end of argument table.
 * @retval '?' Indicate unknown argument.
 * @retval Otherwise The option character
 *
 * The function is used to prase the argument string table.
 * First, you should reset g_iZshOptInd to 0.
 * Then repeat call this function until it returns -1, 
 * which indicate the end of argument string table.
 *
 * If prase successfully, it return the corresponding character in [pcOptStr].
 * If the character in option string is followed by :, then the argument string
 * will assgined to [ppcArg]. \n
 *
 * @section example Example:
 * @code
 * g_iZshOptInd = 0;
 * while ((opt = Zsh_CmdGetOpt(argc, argv, "nt:", &argstr)) != -1)
 * {
 *     switch (opt)
 *     {
 *     case 'n':
 *         flag = 1;
 *         break;
 *     case 't':
 *         val = atoi(argstr);
 *         break;
 *     default:
 *         fprintf(stderr, "Usage: %s [-t nsec] [-n] \r\n", argv[0]);
 *         exit(0);
 *     }
 * }
 * @endcode
 *
 * @note Learn more detail from getopt manpage in linux
 */
MTCFUNC ZINT Mtc_ShGetOpt(ZINT iArgc, ZCONST ZCHAR **apcArgv,
    ZCONST ZCHAR *pcOptStr, ZCONST ZCHAR **ppcArg);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_UTIL_H__ */

