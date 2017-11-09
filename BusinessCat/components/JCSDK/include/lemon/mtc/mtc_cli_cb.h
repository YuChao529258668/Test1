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
  File name     : mtc_cli_cb.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
    Macros and structure definitions required by the mtc client callback.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CLI_CB_H__
#define _MTC_CLI_CB_H__

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
 * @file mtc_cli_cb.h
 * @brief MTC Client Callback Interface Functions.
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief Type define of MTC client callback. */
typedef ZINT (*PFN_MTCCLICB)(ZFUNC_VOID);

/** 
 * @brief Type define of MTC client callback for post print message.
 * @param pcStr is the print string.
 */
typedef ZINT (*PFN_MTCCLIPRINT)(ZCHAR *pcStr);

/** 
 * @brief Type define of MTC client callback for notify event to MTC user. 
 * @param pcName Notification name string.
 * @param zCookie Cookie value.
 * @param pcInfo Information string in json format.
 */
typedef ZINT (*PFN_MTCCLINOTIFY)(ZCONST ZCHAR * pcName, ZCOOKIE zCookie,
                ZCONST ZCHAR * pcInfo);

/** 
* @brief Type define of MTC GUI callback for notify network changed.
* @param iNetType is access network type.
*/
typedef ZVOID (*PFN_MTCCLISUBNETCHANGED)(ZINT iNetType);

/**
 * @brief Set the Zos_Printf string print callback.
 * Zos print and log functions will always call it if callback is not ZNULL.
 *
 * @param [in] pfnCb Callback function.
 */
MTCFUNC ZVOID Mtc_CliCbSetPrint(PFN_MTCCLIPRINT pfnCb);

/**
 * @brief Set the service event callback to MTC driver owner.
 * @param [in] pfnCb Callback function.
 */
MTCFUNC ZVOID Mtc_CliCbSetNotify(PFN_MTCCLINOTIFY pfnCb);

/**
 * @brief Set the service event callback to MTC driver owner.
 * @param [in] pfnCb Callback function.
 */
MTCFUNC ZINT Mtc_CliCbSetEvent(PFN_ZUIEVNT pfnCb);

/**
 * @brief Set subscribe network changed indication callback.
 * The callback will be notified if network has changed
 *
 * @param [in] pfnCb Callback function.
 */
MTCFUNC ZVOID Mtc_CliCbSetSubNetChanged(PFN_MTCCLISUBNETCHANGED pfnCb);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CLI_CB_H__ */

