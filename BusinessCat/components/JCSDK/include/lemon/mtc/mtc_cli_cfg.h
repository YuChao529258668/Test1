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
  File name     : mtc_cli_cfg.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-04
  Description   :
      Data structure and function declare required by MTC client config

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CLI_CFG_H__
#define _MTC_CLI_CFG_H__

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
 * @file mtc_cli_cfg.h
 * @brief MTC Client Config Interface Functions
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief Application context type definition */
typedef ZVOID * ZAPPCONTEXT;

/** @brief MTC log level. */
typedef enum EN_MTC_LOG_LEVEL_TYPE
{
    EN_MTC_LOG_LEVEL_DISABLE = 0,    /** @brief Disable log output. */
    EN_MTC_LOG_LEVEL_ERROR,          /** @brief Only error message. */
    EN_MTC_LOG_LEVEL_INFO,           /** @brief Include error, info message. */
    EN_MTC_LOG_LEVEL_DEBUG,          /** @brief Inlcude error, info 
                                                and debug message. */
    EN_MTC_LOG_LEVEL_FUNCTION,       /** @brief Include error, info,
                                                debug and function message. */
} EN_MTC_LOG_LEVEL_TYPE;

/**
 * @brief Set log level.
 *
 * @param [in] iLevel Log level, 0 for no log, larger value for more log.
 */
MTCFUNC ZVOID Mtc_CliCfgSetLogLevel(ZUINT iLevel);

/**
 * @brief Set log print.
 *
 * @param [in] bPrint log print.
 *
 * @retval ZOK Set operation successfully.
 * @retval ZFAILED Set operation failed.
 */
MTCFUNC ZINT Mtc_CliCfgSetLogPrint(ZBOOL bPrint);

/**
 * @brief Set Log file directory.
 *
 * @param [in] pcDir The log file directory.
 *
 * @retval ZOK Set directory successfully.
 * @retval ZFAILED Set directory failed.
 */
MTCFUNC ZINT Mtc_CliCfgSetLogDir(ZCONST ZCHAR * pcDir);

/**
 * @brief Get Log file directory.
 *
 * @return The log file directory, default "".
 */
MTCFUNC ZCONST ZCHAR * Mtc_CliCfgGetLogDir();

/**
 * @brief Set license context.
 *
 * @param [in] zContext The application context, only avaliable on Android.
 *
 * @retval ZOK Set file name successfully.
 * @retval ZFAILED Set file name failed.
 */
MTCFUNC ZINT Mtc_CliCfgSetContext(ZAPPCONTEXT zContext);

/* mtc config set application version */
MTCFUNC ZINT Mtc_CliCfgSetAppVer(ZCONST ZCHAR *pcVer);

/* mtc config get application version */
MTCFUNC ZCONST ZCHAR * Mtc_CliCfgGetAppVer(ZFUNC_VOID);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CLI_CFG_H__ */

