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
  File name     : mtc.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
    Marcos and structure definitions required by the mtc.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_H__
#define _MTC_H__

/**
 * @addtogroup MTC
 * @{
 * @brief Multimedia Talk Client
 *
 * This module is part of Multimedia Talk Client Entity. 
 * It provides interfaces using in GUI.
 * There are 2 main task got be done:
 * -# Wrap interfaces of MTF, to make it more easy to use.
 * -# Conceal the GUI process logic.
 *
 * To start MTC use code like:
 * @code
 //initialize the client
 Mtc_CliInit(profile director);
 
 // open the client
 Mtc_CliOpen(user name);

 // start client
 if (Mtc_CliStart() != ZOK)
 {
     Mtc_CliDestroy();
     return ZFAILED;
 }
 * @endcode
 *
 * To stop MTC use code like:
 * @code
 Mtc_CliStop();
 Mtc_CliClose();
 Mtc_CliDestroy();
 * @endcode
 *
 * Detail description of files in module:
 * -# @ref mtc_acv.h                "Archive and Feedback Interfaces"
 * -# @ref mtc_buddy.h              "Buddy Interfaces"
 * -# @ref mtc_call.h               "Call Interfaces"
 * -# @ref mtc_call_cfg.h           "Call Configuration"
 * -# @ref mtc_call_db.h            "Call Persistent Configuration"
 * -# @ref mtc_call_ext.h           "Call Extension Interfaces"
 * -# @ref mtc_cc.h                 "Call Center Interfaces"
 * -# @ref mtc_cli.h                "Client Interfaces"
 * -# @ref mtc_cli_cb.h             "Client Callback Interfaces"
 * -# @ref mtc_cli_cfg.h            "Client Configuration"
 * -# @ref mtc_cli_db.h             "Client Presistent Configuration"
 * -# @ref mtc_conf.h               "Conference Interfaces"
 * -# @ref mtc_conf_db.h            "Conference Presistent Configuration"
 * -# @ref mtc_d0.h                 "Doodle Interfaces for Compatible Version 0"
 * -# @ref mtc_d2.h                 "Doodle Interfaces for Compatible Version 2"
 * -# @ref mtc_diag.h               "Diagnosis Interfaces"
 * -# @ref mtc_doodle.h             "Doolde Interfaces"
 * -# @ref mtc_dsr.h                "Document Sharing Interfaces"
 * -# @ref mtc_fs.h                 "File Storage Interfaces"
 * -# @ref mtc_game.h               "Game Interfaces"
 * -# @ref mtc_group.h              "Group Interfaces"
 * -# @ref mtc_im.h                 "Instance Message Interfaces"
 * -# @ref mtc_mdm.h                "Multiple Device Management Interfaces"
 * -# @ref mtc_media.h              "Media Interfaces"
 * -# @ref mtc_payment.h            "Payment Interfaces"
 * -# @ref mtc_point.h              "Point Interfaces"
 * -# @ref mtc_prof.h               "Profile Interfaces"
 * -# @ref mtc_prof_cfg.h           "Profile Configuration"
 * -# @ref mtc_prof_db.h            "Profile Presistent Configuration"
 * -# @ref mtc_prov_cfg.h           "Provision Configuration"
 * -# @ref mtc_prov_db.h            "Provision Presistent Configuration"
 * -# @ref mtc_rdcall.h             "Random Call Interfaces"
 * -# @ref mtc_ring.h               "Ring Interfaces"
 * -# @ref mtc_sts.h                "Call Statistics Interfaces"
 * -# @ref mtc_ue.h                 "User Entry Interfaces"
 * -# @ref mtc_ue_contact.h         "User Entry for Contact Interfaces"
 * -# @ref mtc_ue_db.h              "User Entry Presistent Configuration"
 * -# @ref mtc_user.h               "User Helper Interfaces"
 * -# @ref mtc_util.h               "Utilities Interfaces"
 * -# @ref mtc_ver.h                "Version Interfaces"
 * @}
 *
 * @file mtc.h
 * @brief Multimedia Talk Client
 * 
 * To include the definitions of MTC, use the following directive:
 * @code
 * #include "mtc.h"
 * @endcode
 *
 */

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

#include "mtc_util.h"                /* MTC Utility Interfaces */
#include "mtc_cli.h"                 /* MTC Client Interfaces */
#include "mtc_cli_cfg.h"             /* MTC Client Config Interfaces */
#include "mtc_cli_cb.h"              /* MTC Client Callback Interfaces */
#include "mtc_cli_db.h"              /* MTC Client Database Interfaces */
#include "mtc_prof.h"                /* MTC Profile Interfaces */
#include "mtc_prof_cfg.h"            /* MTC Profile Config Interfaces */
#include "mtc_prof_db.h"             /* MTC Profile Database Interfaces */
#include "mtc_prov_cfg.h"            /* MTC Provision Config Interfaces */
#include "mtc_prov_db.h"             /* MTC Provision Database Interfaces */
#include "mtc_ver.h"                 /* MTC Version Interfaces */
#include "mtc_ue.h"                  /* MTC User Entry interfaces */
#include "mtc_ue_db.h"               /* Mtc User Entry Database interfaces */
#include "mtc_ue_contact.h"          /* MTC User Entry interfaces */
#include "mtc_user.h"                /* MTC User interfaces */
#include "mtc_acv.h"                 /* MTC archive Interfaes */

#endif /* _MTC_H__ */

