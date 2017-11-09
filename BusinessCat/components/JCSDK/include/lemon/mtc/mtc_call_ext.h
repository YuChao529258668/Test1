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
  File name     : mtc_call.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-03
  Description   :
      Data structure and function declare required by MTC call

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CALL_EXT_H__
#define _MTC_CALL_EXT_H__

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
 * @file mtc_call_ext.h
 * @brief MTC Call Interface Functions
 *
 * This file includes call interface function. Those function is used to manage calls.
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief MTC call record file type */
#define MTC_CALL_REC_FILE_PCM "pcm"  /**< @brief Pcm content. */
#define MTC_CALL_REC_FILE_WAV "wav"  /**< @brief Wav content. */

/** 
 * @brief MTC session get video size.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] piWidth Video width in pixel of specific session.
 * @param [out] piHeight Video height in pixel of specific session.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CallGetVideoSize(ZUINT iCallId, ZUINT *piWidth,
                ZUINT *piHeight);

/** 
 * @brief MTC session get remote video size.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] piWidth Video width in pixel of specific session.
 * @param [out] piHeight Video height in pixel of specific session.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CallGetVideoRemoteSize(ZUINT iCallId, ZUINT *piWidth,
                ZUINT *piHeight);

/** 
 * @brief MTC session get local video size.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] piWidth Video width in pixel of specific session.
 * @param [out] piHeight Video height in pixel of specific session.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CallGetVideoLocalSize(ZUINT iCallId, ZUINT *piWidth,
                ZUINT *piHeight);

/** 
 * @brief MTC session get Call-ID string.
 *
 * @param [in] iCallId The ID of session which you want to get.
 *
 * @return The string of Call-ID.
 *
 * @see
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallGetServerCallId(ZUINT iCallId);

/** 
 * @brief MTC session get peer id, based on polices.
 *
 * @param [in] iCallId The ID of session which you want to get.
 * @param [out] ppcDispName The display name of peer user which you have this session with.
 * @param [out] ppcUri The URI of peer user which you have this session with.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 *
 * Note the result of this function may be different with Mtc_CallGetPeerUri
 * because the apply of polices. For example, OIP, OIR, TIP, TIR, and privacy.
 *
 * @see @ref Mtc_CallGetPeerUri
 */
MTCFUNC ZINT Mtc_CallGetPeerId(ZUINT iCallId, ZCONST ZCHAR **ppcDispName, 
                ZCONST ZCHAR **ppcUri);

/**
 * @brief Reccord mic start.
 *
 * It will reccord from mic to file.
 *
 * @param [in] pcFileName The reccord file name.
 * @param [in] ucFileType The reccord file type, @ref EN_MTC_MFILE_TYPE
 *
 * @retval ZOK Audio Reccord  successfully.
 * @retval ZFAILED Audio Reccord failed.
 *
 * @see @ref Mtc_CallRecMicStop
 */
MTCFUNC ZINT Mtc_CallRecMicStart(ZCONST ZCHAR *pcFileName, 
                ZUCHAR ucFileType);

/**
 * @brief Reccord Audio stop.
 *
 * @see @ref Mtc_CallRecMicStart
 */
MTCFUNC ZINT Mtc_CallRecMicStop(ZFUNC_VOID);

/** 
 * @brief MTC session record playout.
 *
 * @param [in] iCallId The ID of session which you want to record, 
 *                      if pCall is invalid, record the mix playout.
 * @param [in] pcFileName The reccord file name.
 * @param [in] ucFileType The reccord file type, @ref EN_MTC_MFILE_TYPE
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CallRecPlayStart(ZUINT iCallId, ZCONST ZCHAR *pcFileName, 
                ZUCHAR ucFileType);

/** 
 * @brief MTC session stop record playout.
 *
 * @param [in] iCallId The ID of session which you want to stop record, 
 *                      if pCall is invalid, stop record the mix playout.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_CallRecPlayStop(ZUINT iCallId);

/**
 * @brief MTC session set state of receiving-side AGC.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] bEnable ZTRUE to enable Rx-AGC, ZFALSE to disable Rx-AGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetRxAgcEnable
 */
MTCFUNC ZINT Mtc_CallSetRxAgcEnable(ZUINT iCallId, ZBOOL bEnable);

/**
 * @brief MTC session get state of receiving-side AGC.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pbEnable Current state of Rx-AGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetRxAgcEnable
 */
MTCFUNC ZINT Mtc_CallGetRxAgcEnable(ZUINT iCallId, ZBOOL *pbEnable);

/**
 * @brief MTC session set mode of receiving-side AGC.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] ucMode Mode of Rx-AGC, @ref EN_MTC_RX_GC_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetRxAgcMode
 */
MTCFUNC ZINT Mtc_CallSetRxAgcMode(ZUINT iCallId, ZUCHAR ucMode);

/**
 * @brief MTC session get mode of receiving-side AGC.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pucMode Mode of Rx-AGC, @ref EN_MTC_RX_GC_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetRxAgcMode
 */
MTCFUNC ZINT Mtc_CallGetRxAgcMode(ZUINT iCallId, ZUCHAR *pucMode);

/**
 * @brief MTC session set traget dBOV of receiving-side AGC.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] wTargetDb Traget dBOV of Rx-AGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetRxAgcTarget
 */
MTCFUNC ZINT Mtc_CallSetRxAgcTarget(ZUINT iCallId, ZUSHORT wTargetDb);

/**
 * @brief MTC session get traget dBOV of receiving-side AGC.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pwTargetDb Traget dBOV of Rx-AGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetRxAgcTarget
 */
MTCFUNC ZINT Mtc_CallGetRxAgcTarget(ZUINT iCallId, ZUSHORT *pwTargetDb);

/**
 * @brief MTC session set Gain dBOV of receiving-side AGC.
 *
 * @param [in] iStrmId The ID of session.
 * @param [in] wGainDb The Gain dBOV of receiving-side AGC.
 *                     Range from 0-90, Recommend 0-32.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetRxAgcGain
 */
MTCFUNC ZINT Mtc_CallSetRxAgcGain(ZUINT iStrmId, ZUSHORT wGainDb);

/**
 * @brief MTC session get Gain dBOV of receiving-side AGC.
 *
 * @param [in] iStrmId The ID of session.
 * @param [out] *pwGainDb Return the Gain dBOV of receiving-side AGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetRxAgcGain
 */
MTCFUNC ZINT Mtc_CallGetRxAgcGain(ZUINT iStrmId, ZUSHORT *pwGainDb);

/**
 * @brief MTC session set state of receiving-side ANR.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] bEnable ZTRUE to enable Rx-ANR, ZFALSE to disable Rx-ANR.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetRxAnrEnable
 */
MTCFUNC ZINT Mtc_CallSetRxAnrEnable(ZUINT iCallId, ZBOOL bEnable);

/**
 * @brief MTC session get state of receiving-side ANR.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pbEnable Current state of Rx-ANR.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetRxAnrEnable
 */
MTCFUNC ZINT Mtc_CallGetRxAnrEnable(ZUINT iCallId, ZBOOL *pbEnable);

/**
 * @brief MTC session set mode of receiving-side ANR.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] ucMode Mode of Rx-ANR, @ref EN_MTC_NS_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetRxAnrMode
 */
MTCFUNC ZINT Mtc_CallSetRxAnrMode(ZUINT iCallId, ZUCHAR ucMode);

/**
 * @brief MTC session get mode of receiving-side ANR.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pucMode Mode of Rx-ANR, @ref EN_MTC_NS_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetRxAnrMode
 */
MTCFUNC ZINT Mtc_CallGetRxAnrMode(ZUINT iCallId, ZUCHAR *pucMode);

/**
 * @brief MTC session set state of VAD.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] bEnable ZTRUE to enable VAD, ZFALSE to disable VAD.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetVadEnable
 */
MTCFUNC ZINT Mtc_CallSetVadEnable(ZUINT iCallId, ZBOOL bEnable);

/**
 * @brief MTC session get state of VAD.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pbEnable Current state of VAD.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetVadEnable
 */
MTCFUNC ZINT Mtc_CallGetVadEnable(ZUINT iCallId, ZBOOL *pbEnable);

/**
 * @brief MTC session set mode of VAD.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] ucMode Mode of VAD, @ref EN_MTC_VAD_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallGetVadMode
 */
MTCFUNC ZINT Mtc_CallSetVadMode(ZUINT iCallId, ZUCHAR ucMode);

/**
 * @brief MTC session get mode of VAD.
 *
 * @param [in] iCallId The ID of session.
 * @param [out] *pucMode Mode of VAD, @ref EN_MTC_VAD_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallSetVadMode
 */
MTCFUNC ZINT Mtc_CallGetVadMode(ZUINT iCallId, ZUCHAR *pucMode);

/**
 * @brief MTC session enable/disable color enhancement.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] bEnable ZTRUE to enable color enhancement, 
 *                     ZFALSE to disable color enhancement.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see 
 */
MTCFUNC ZINT Mtc_CallEnhanceColor(ZUINT iCallId, ZBOOL bEnable);

/**
 * @brief MTC session enable/disable CPU load control.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] bEnable ZTRUE to enable CPU load control, 
 *                     ZFALSE to disable CPU load control.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see 
 */
MTCFUNC ZINT Mtc_CallArsEnableCpuCtrl(ZUINT iCallId, ZBOOL bEnable);

/**
 * @brief MTC session set target usage percent of CPU load control.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] iLoad Target usage percent of CPU load control, should be 0-100.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see 
 */
MTCFUNC ZINT Mtc_CallArsSetCupCtrlTgt(ZUINT iCallId, ZUINT iLoad);

/**
 * @brief MTC session enable/disable bandwidth efficient mode.
 *
 * @param [in] iCallId The ID of session.
 * @param [in] bEnable ZTRUE to enable bandwidth efficient mode, 
 *                     ZFALSE to disable bandwidth efficient mode.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see 
 */
MTCFUNC ZINT Mtc_CallArsEnableBem(ZUINT iCallId, ZBOOL bEnable);

/**
 * @brief Get video ARS parameters.
 * @param  iCallId         The ID of session.
 * @param  piLowBitrate    The lowest bitrate in bps.
 * @param  piHighBitrate   The highest bitrate in bps.
 * @param  piLowFramerate  The lowest framerate in fps.
 * @param  piHighFramerate The highest framerate in fps.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 */
MTCFUNC ZINT Mtc_CallArsGetVideoParm(ZUINT iCallId, ZUINT *piLowBitrate,
    ZUINT *piHighBitrate, ZUINT *piLowFramerate, ZUINT *piHighFramerate);

/**
 * @brief Set video ARS parameters.
 * @param  iCallId        The ID of session.
 * @param  iLowBitrate    The lowest bitrate in bps.
 * @param  iHighBitrate   The highest bitrate in bps.
 * @param  iLowFramerate  The lowest framerate in fps.
 * @param  iHighFramerate The highest framerate in fps.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 */
MTCFUNC ZINT Mtc_CallArsSetVideoParm(ZUINT iCallId, ZUINT iLowBitrate,
    ZUINT iHighBitrate, ZUINT iLowFramerate, ZUINT iHighFramerate);

/**
 * @brief Query missed call information.
 *
 * @retval ZOK Query OK.
 * @retval ZFAILED Query failed.
 */
MTCFUNC ZINT Mtc_CallQueryMissed(ZFUNC_VOID);

#define MTC_CALL_CONNECTION_STATE_INVALID    "INVALID"
#define MTC_CALL_CONNECTION_STATE_IDLE       "IDLE"
#define MTC_CALL_CONNECTION_STATE_CONNECTING "CONNECTING"
#define MTC_CALL_CONNECTION_STATE_CONNECTED  "CONNECTED"

/**
 * @brief Get media connection state of call.
 *
 * @return Connection state information string,
 * MTC_CALL_CONNECTION_STATE_INVALID for invalid call.
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallMediaState(ZUINT iCallId);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CALL_EXT_H__ */

