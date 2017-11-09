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
  File name     : mtc_cli_db.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2010-02-06
  Description   :
      Data structure and function declare required by MTC client database.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CLI_DB_H__
#define _MTC_CLI_DB_H__

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
 * @file mtc_cli_db.h
 * @brief MTC Client Database Interface Functions.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Apply all data change to all components.
 *
 * @retval ZOK Apply data change successfully.
 * @retval ZFAILED Apply data change failed.
 */
MTCFUNC ZINT Mtc_CliDbApplyAll(ZFUNC_VOID);

/**
 * @brief Get data change apply flag.
 *
 * @return Data change apply flag.
 *
 * @see @ref Mtc_CliDbSetApplyChange
 */
MTCFUNC ZBOOL Mtc_CliDbGetApplyChange(ZFUNC_VOID);

/**
 * @brief Set data change apply flag realtime.
 *
 * @retval ZOK Set data change apply flag successfully.
 * @retval ZFAILED Set data change apply flag failed.
 *
 * @see @ref Mtc_CliDbGetApplyChange
 */
MTCFUNC ZINT Mtc_CliDbSetApplyChange(ZBOOL bApply);

/**
 * @brief Get DNS local listen port from database.
 *
 * @return The DNS local listen port.
 *
 * @see @ref Mtc_CliDbSetDnsLclPort
 */
MTCFUNC ZUINT Mtc_CliDbGetDnsLclPort(ZFUNC_VOID);

/**
 * @brief Set DNS local listen port.
 *
 * @param [in] iPort DNS local listen port.
 *
 * @retval ZOK Set DNS local listen port successfully.
 * @retval ZFAILED Set DNS local listen port failed.
 *
 * @see @ref Mtc_CliDbGetDnsLclPort
 */
MTCFUNC ZINT Mtc_CliDbSetDnsLclPort(ZUINT iPort); 

/**
 * @brief Get DNS primary or secondary server IP from database.
 *
 * @param [in] bPrimary DNS primary option.
 *
 * @return The DNS primary or secondary server IP.
 *
 * @see @ref Mtc_CliDbSetDnsServIp
 */
MTCFUNC ZUINT Mtc_CliDbGetDnsServIp(ZBOOL bPrimary);

/**
 * @brief Set DNS primary or secondary server IP.
 *
 * @param [in] bPrimary DNS primary option.
 * @param [in] iServIp DNS primary or secondary server IP.
 *
 * @retval ZOK Set DNS primary or secondary server IP successfully.
 * @retval ZFAILED Set DNS primary or secondary server IP failed.
 *
 * @see @ref Mtc_CliDbGetDnsServIp
 */
MTCFUNC ZINT Mtc_CliDbSetDnsServIp(ZBOOL bPrimary, ZUINT iServIp);

/**
 * @brief Get DNS primary or secondary server port from database.
 *
 * @param [in] bPrimary DNS primary option.
 *
 * @return The DNS primary or secondary server port.
 *
 * @see @ref Mtc_CliDbSetDnsServPort
 */
MTCFUNC ZUINT Mtc_CliDbGetDnsServPort(ZBOOL bPrimary);

/**
 * @brief Set DNS primary or secondary server port.
 *
 * @param [in] bPrimary DNS primary option.
 * @param [in] iPort DNS primary or secondary server port.
 *
 * @retval ZOK Set DNS primary or secondary server port successfully.
 * @retval ZFAILED Set DNS primary or secondary server port failed.
 *
 * @see @ref Mtc_CliDbGetDnsServPort
 */
MTCFUNC ZINT Mtc_CliDbSetDnsServPort(ZBOOL bPrimary, ZUINT iPort);

/**
 * @brief Get DNS use google dns server flag from local database.
 *
 * @return The DNS use google dns server flag.
 *
 * @see @ref Mtc_CliDbSetDnsUseGoogle
 */
MTCFUNC ZBOOL Mtc_CliDbGetDnsUseGoogle();

/**
 * @brief Set DNS use google dns server flag.
 *
 * @param [in] bUse The DNS use google dns server flag. 
 *             ZTRUE for using google public dns server as second DNS server.
 *             ZFALSE for not use.
 *
 * @retval ZOK Set DNS use google dns server flag successfully.
 * @retval ZFAILED Set DNS use google dns server flag failed.
 *
 * @see @ref Mtc_CliDbGetDnsUseGoogle
 */
MTCFUNC ZINT Mtc_CliDbSetDnsUseGoogle(ZBOOL bUse);

#ifdef __cplusplus
}
#endif
    
#endif /* _MTC_CLI_DB_H__ */

