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
  File name     : mtc_conf_db.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
      Data structure and function declare required by MTC conference DB

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CONF_DB_H__
#define _MTC_CONF_DB_H__

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
 * @file mtc_conf_db.h
 * @brief MTC Conference Database Interface Functions.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Get the use RUDP option from database.
 *
 * @retval ZTRUE User will use RUDP.
 * @retval ZFALSE User will not use RUDP.
 *
 * @see @ref Mtc_ConfDbSetUseRudp
 */
MTCFUNC ZBOOL Mtc_ConfDbGetUseRudp(ZFUNC_VOID);

/**
 * @brief Set the use RUDP option.
 *
 * @param [in] bEnable User use RUDP option.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option option failed.
 *
 * @see @ref Mtc_ConfDbGetUseRudp
 */
MTCFUNC ZINT Mtc_ConfDbSetUseRudp(ZBOOL bEnable);

/**
 * @brief Get the use User ID option from database.
 *
 * @retval ZTRUE User will use User ID.
 * @retval ZFALSE User will not use User ID.
 *
 * @see @ref Mtc_ConfDbSetUseUid
 */
MTCFUNC ZBOOL Mtc_ConfDbGetUseUid(ZFUNC_VOID);

/**
 * @brief Set the use User ID option.
 *
 * @param [in] bEnable User use User ID option.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option option failed.
 *
 * @see @ref Mtc_ConfDbGetUseUid
 */
MTCFUNC ZINT Mtc_ConfDbSetUseUid(ZBOOL bEnable);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CONF_DB_H__ */

