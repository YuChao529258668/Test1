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
  File name     : mtc_ver.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2006-10-08
  Description   :
      Data structure and function declare required by MTC version

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_VER_H__
#define _MTC_VER_H__

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
 * @file mtc_ver.h
 * @brief MTC Version Interface Functions.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief MTC get client version.
 *
 * @return MTC version.
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetVersion(ZFUNC_VOID);

/**
 * @brief MTC get avatar version.
 *
 * @return Avatar version.
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetAvatarVersion(ZFUNC_VOID);

/**
 * @brief MTC get GIRAFFE version
 *
 * @return GIRAFFE version.
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetGiraffeVersion(ZFUNC_VOID);

/**
 * @brief MTC get lemon version
 *
 * @return Lemon version.
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetLemonVersion(ZFUNC_VOID);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_VER_H__ */

