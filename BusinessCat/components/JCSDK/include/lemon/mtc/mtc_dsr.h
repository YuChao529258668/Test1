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
  File name     : mtc_dsr.h
  Module        : multimedia talk client
  Author        : bob.liu
  Created on    : 2016-01-12
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_DSR_H__
#define _MTC_DSR_H__

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

/**
 * @file mtc_dsr.h
 * @brief MTC Document Sharing Interface Functions
 *
 * This file includes document sharing interface function.
 */

/** @brief The failed reason number. */
typedef enum EN_MTC_DSR_REASON_TYPE
{
    EN_MTC_DSR_REASON_BASE = 3000,    /**< @brief Base of reason number. */
    EN_MTC_DSR_REASON_INVALID_ID,     /**< @brief Invalid document ID. */
    EN_MTC_DSR_REASON_TOO_LARGE_DOCUMENT, /**< @brief Too large document. */
    EN_MTC_DSR_REASON_SERVER,         /**< @brief Server error. */
} EN_MTC_DSR_REASON_TYPE;

/** @brief The document state number. */
typedef enum EN_MTC_DSR_STATE_TYPE
{
    EN_MTC_DSR_STATE_INVALID = 0,     /**< @brief Invalid state. */
    EN_MTC_DSR_STATE_QUEUED,          /**< @brief Document is waiting for convert. */
    EN_MTC_DSR_STATE_CONVERTING,      /**< @brief Document is converting. */
    EN_MTC_DSR_STATE_READY,           /**< @brief Document is ready for loading. */
    EN_MTC_DSR_STATE_LOADED,          /**< @brief Document is loaded. */
    EN_MTC_DSR_STATE_CACHED,          /**< @brief Document is cached on load storage. */
} EN_MTC_DSR_STATE_TYPE;

/**
 * @defgroup MtcDsrKey MTC notification key for document sharing.
 * @{
 */

/**
 * @brief A key whose value is a number object reflecting
 * the failed reason, @ref EN_MTC_DSR_REASON_TYPE.
 */
#define MtcDsrReasonKey                     "Reason"

/**
 * @brief A key whose value is a string object reflecting
 * the detail information of failure.
 */
#define MtcDsrFailInfoKey                   "FailInfo"

/**
 * @brief A key whose value is a string object reflecting
 * the ID of sharing document.
 */
#define MtcDsrDocIdKey                      "Id"

/**
 * @brief A key whose value is a number object reflecting
 * the state of document.
 */
#define MtcDsrDocStateKey                   "State"

/**
 * @brief A key whose value is a string object reflecting
 * the name property of sharing document.
 */
#define MtcDsrDocNameKey                    "Name"

/**
 * @brief A key whose value is a string object reflecting
 * the memo property of sharing document.
 */
#define MtcDsrDocMemoKey                    "Memo"

/**
 * @brief A key whose value is a string object reflecting
 * the user data property of sharing document.
 */
#define MtcDsrDocUserDataKey                "UserData"

/**
 * @brief A key whose value is a string object reflecting
 * the document shared URI.
 */
#define MtcDsrDocUriKey                     "URI"

/**
 * @brief A key whose value is a boolean object reflecting
 * if the user is the owner of document.
 */
#define MtcDsrDocIsOwnerKey                 "IsOwner"

/**
 * @brief A key whose value is a number object reflecting
 * the page count of sharing document.
 */
#define MtcDsrPageCountKey                  "PageCount"

/**
 * @brief A key whose value is a array object.
 * Each item is string object reflecting the path of thumbnail file of
 * corresponding page.
 */
#define MtcDsrThumbsKey                     "Thumbs"

/**
 * @brief A key whose value is a array object.
 * Each item is string object reflecting the path of image file of
 * corresponding page.
 */
#define MtcDsrPagesKey                      "Pages"

/**
 * @brief A key whose value is a number object reflecting
 * the page index of sharing document, start from 0.
 */
#define MtcDsrPageIdKey                     "PageId"

/**
 * @brief A key whose value is a string object reflecting
 * the page image file name of sharing document.
 */
#define MtcDsrPageKey                       "Page"

/**
 * @brief A key whose value is a number object reflecting
 * uploading progress in percentage.
 */
#define MtcDsrProgressKey                   "Progress"

/** @} */

/**
 * @defgroup MtcDsrNotification MTC notification names for document sharing.
 * @{
 */

/**
 * @brief Posted when query sharing documents successfully..
 *
 * The pcInfo of this notification contains 
 * an array of document info object. Each object contains
 * @ref MtcDsrDocIdKey
 * @ref MtcDsrDocStateKey
 * @ref MtcDsrDocNameKey
 * @ref MtcDsrDocMemoKey
 * @ref MtcDsrDocUserDataKey
 * @ref MtcDsrPageCountKey.
 */
#define MtcDsrQueryOkNotification           "MtcDsrQueryOkNotification"

/**
 * @brief Posted when query sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrQueryDidFailNotification      "MtcDsrQueryDidFailNotification"

/**
 * @brief Posted when delete sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey.
 */
#define MtcDsrRemoveOkNotification          "MtcDsrRemoveOkNotification"

/**
 * @brief Posted when query sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrDocIdKey.
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrRemoveDidFailNotification     "MtcDsrRemoveDidFailNotification"

/**
 * @brief Posted during document uploading.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrDocIdKey.
 * @ref MtcDsrProgressKey.
 */
#define MtcDsrUploadProgressNotification    "MtcDsrUploadProgressNotification"

/**
 * @brief Posted when upload sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey.
 */
#define MtcDsrUploadOkNotification          "MtcDsrUploadOkNotification"

/**
 * @brief Posted when upload sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrUploadDidFailNotification     "MtcDsrUploadDidFailNotification"

/**
 * @brief Posted when upload sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey.
 * @ref MtcDsrDocUriKey.
 */
#define MtcDsrUploadImagesOkNotification    "MtcDsrUploadImagesOkNotification"

/**
 * @brief Posted when upload sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrUploadImagesDidFailNotification "MtcDsrUploadImagesDidFailNotification"

/**
 * @brief Posted when convert sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey.
 */
#define MtcDsrConvertOkNotification         "MtcDsrConvertOkNotification"

/**
 * @brief Posted when convert sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrDocIdKey.
 */
#define MtcDsrConvertDidFailNotification    "MtcDsrConvertDidFailNotification"

/**
 * @brief Posted when download sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey.
 */
#define MtcDsrDownloadOkNotification        "MtcDsrDownloadOkNotification"

/**
 * @brief Posted when download sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrDownloadDidFailNotification   "MtcDsrDownloadDidFailNotification"

/**
 * @brief Posted when modify sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey.
 */
#define MtcDsrModifyOkNotification          "MtcDsrModifyOkNotification"

/**
 * @brief Posted when modify sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrModifyDidFailNotification     "MtcDsrModifyDidFailNotification"

/**
 * @brief Posted when load sharing document successfully.
 *
 * The pcInfo of this notification contains 
 * @ref MtcDsrDocIdKey,
 * @ref MtcDsrDocStateKey
 * @ref MtcDsrDocNameKey
 * @ref MtcDsrDocMemoKey
 * @ref MtcDsrDocUserDataKey
 * @ref MtcDsrPageCountKey.
 * @ref MtcDsrThumbsKey,
 * @ref MtcDsrPagesKey.
 */
#define MtcDsrLoadOkNotification            "MtcDsrLoadOkNotification"

/**
 * @brief Posted when load sharing documents failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrReasonKey
 * @ref MtcDsrFailInfoKey.
 */
#define MtcDsrLoadDidFailNotification       "MtcDsrLoadDidFailNotification"

/**
 * @brief Posted when page loaded.
 *
 * The pcInfo of this notification contains
 * @ref MtcDsrDocIdKey,
 * @ref MtcDsrPageIdKey
 * @ref MtcDsrPageKey.
 */
#define MtcDsrPageLoadedNotification        "MtcDsrPageLoadedNotification"

/**
 * @brief Posted when pack document OK.
 */
#define MtcDsrPackOkNotification            "MtcDsrPackOkNotification"

/**
 * @brief Posted when pack document failed.
 */
#define MtcDsrPackDidFailNotification       "MtcDsrPackDidFailNotification"

/**
 * @brief Posted when import document OK.
 */
#define MtcDsrImportOkNotification          "MtcDsrImportOkNotification"

/**
 * @brief Posted when import document failed.
 */
#define MtcDsrImportDidFailNotification     "MtcDsrImportDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Query all document for sharing.
 * 
 * @param  zCookie The cookie value.
 * 
 * @retval ZOK       The request has been sent successfully.
 *         When query has been done successfully, UI will receive @ref MtcDsrQueryOkNotification.
 *         When query failed, UI will receive @ref MtcDsrQueryDidFailNotification.
 * @retval ZFAILED   Failed to send request.
 */
MTCFUNC ZINT Mtc_DsrQuery(ZCOOKIE zCookie);

/**
 * @brief Remove specific sharing document.
 * 
 * @param  zCookie The cookie value.
 * @param  pcDocId The document ID string.
 * 
 * @retval ZOK       The request has been sent successfully.
 *         When document deleted successfully, UI will receive @ref MtcDsrRemoveOkNotification.
 *         When delete failed, UI will receive @ref MtcDsrRemoveDidFailNotification.
 * @retval ZFAILED   Failed to send request.
 */
MTCFUNC ZINT Mtc_DsrRemove(ZCOOKIE zCookie, ZCONST ZCHAR *pcDocId);

/**
 * @brief Upload document for sharing.
 * 
 * @param  zCookie    The cookie value.
 * @param  pcFilePath The file path string.
 * @param  pcInfo     The info of the document, which contains
 *                    @ref MtcDsrDocNameKey
 *                    @ref MtcDsrDocMemoKey
 *                    @ref MtcDsrDocUserDataKey.
 *                    
 * @retval ZOK       The request has been sent successfully.
 *         When the document upload successfully, UI will receive @ref MtcDsrUploadOkNotification.
 *         The document cannot be shared immediately. The document can be shared after its state
 *         changed to ready.
 *         When delete failed, UI will receive @ref MtcDsrUploadDidFailNotification.
 * @retval ZFAILED   Failed to send request.
 */
MTCFUNC ZINT Mtc_DsrUpload(ZCOOKIE zCookie, ZCONST ZCHAR *pcFilePath, ZCONST ZCHAR *pcInfo);

/**
 * @brief Upload document image files for sharing.
 * 
 * @param  zCookie    The cookie value.
 * @param  pcDocId    The Id of doc.
 * @param  pcDirPath  The directory contains image files.
 * @param  iPageCount The pagecount of doc.
 * @param  pcInfo     The info of the document, which contains
 *                    @ref MtcDsrDocNameKey
 *                    @ref MtcDsrDocMemoKey
 *                    @ref MtcDsrDocUserDataKey.
 *                    
 * @retval ZOK       The request has been sent successfully.
 *         When the document upload successfully, UI will receive @ref MtcDsrUploadImagesOkNotification.
 *         The document cannot be shared immediately. The document can be shared after its state
 *         changed to ready.
 *         When upload failed, UI will receive @ref MtcDsrUploadImagesDidFailNotification.
 *         UI will receive @ref MtcDsrUploadProgressNotification during uploading.
 * @retval ZFAILED   Failed to send request.
 */
MTCFUNC ZINT Mtc_DsrUploadImages(ZCOOKIE zCookie, ZCONST ZCHAR *pcDocId,
    ZCONST ZCHAR *pcDirPath, ZINT iPageCount, ZCONST ZCHAR *pcInfo);

/**
 * @brief Modify document information.
 * 
 * @param  zCookie    The cookie value.
 * @param  pcDocId The document ID string.
 * @param  pcInfo     The info of the document, which contains
 *                    @ref MtcDsrDocNameKey
 *                    @ref MtcDsrDocMemoKey
 *                    @ref MtcDsrDocUserDataKey.
 *                    
 * @retval ZOK       The request has been sent successfully.
 *         When the document modified successfully, UI will receive @ref MtcDsrModifyOkNotification.
 *         When modify failed, UI will receive @ref MtcDsrModifyDidFailNotification.
 * @retval ZFAILED   Failed to send request.
 */
MTCFUNC ZINT Mtc_DsrModify(ZCOOKIE zCookie, ZCONST ZCHAR *pcDocId, ZCONST ZCHAR *pcInfo);

/**
 * @brief Load document from the URI of sharing link.
 * 
 * @param  zCookie The cookie value.
 * @param  pcUri   The URI of sharing link.
 * 
 * @retval ZOK       The request has been sent successfully.
 *         When the document loaded successfully, UI will receive @ref MtcDsrLoadOkNotification.
 *         When loaded failed, UI will receive @ref MtcDsrLoadDidFailNotification.
 * @retval ZFAILED   Failed to send request.
 */
MTCFUNC ZINT Mtc_DsrLoad(ZCOOKIE zCookie, ZCONST ZCHAR *pcUri);

/**
 * @brief Pack document.
 * @param  zCookie      The cookie value.
 * @param  pcOutputFile The output file name.
 * @param  pcDocId      The document ID.
 * @param  pcDirPath    The directory contains image file.s
 * @param  iPageCount   The page count.
 * @param  pcInfo       The info of the document, which contains
 *                      @ref MtcDsrDocNameKey
 *                      @ref MtcDsrDocMemoKey
 *                      @ref MtcDsrDocUserDataKey.
 * @retval ZOK          The request has been sent successfully.
 *         When the document packed successfully, UI will receive @ref MtcDsrPackOkNotification.
 *         When pack failed, UI will receive @ref MtcDsrPackDidFailNotification.
 * @retval ZFAILED      Failed to pack document..
 */
MTCFUNC ZINT Mtc_DsrPack(ZCOOKIE zCookie, ZCONST ZCHAR *pcOutputFile,
    ZCONST ZCHAR *pcDocId, ZCONST ZCHAR *pcDirPath, ZINT iPageCount,
    ZCONST ZCHAR *pcInfo);

/**
 * @brief Import document
 * @param  zCookie  The cookie value
 * @param  pcPacket The packet file name
 * @retval ZOK          The request has been sent successfully.
 *         When the document packed successfully, UI will receive @ref MtcDsrImportOkNotification.
 *         When pack failed, UI will receive @ref MtcDsrImportDidFailNotification.
 * @retval ZFAILED      Failed to pack document..
 */
MTCFUNC ZINT Mtc_DsrImport(ZCOOKIE zCookie, ZCONST ZCHAR *pcPacket);

/**
 * @brief Get document ID from file
 *
 * @param pcFilePath  The file path.
 *
 * @return The document ID of the file.
 */
MTCFUNC ZCONST ZCHAR * Mtc_DsrGetDocId(ZCONST ZCHAR *pcFilePath);

/**
 * @brief Check document is exist.
 *
 * @param pcDocId  The document ID.
 *
 * @return ZTRUE when document is exist, otherwise is not exist.
 */
MTCFUNC ZBOOL Mtc_DsrIsDocExist(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the document state.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         The state of document @ref EN_MTC_DSR_STATE_TYPE.
 */
MTCFUNC ZINT Mtc_DsrGetDocState(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the document URI for sharing.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         The string of document URI.
 */
MTCFUNC ZCONST ZCHAR * Mtc_DsrGetDocUri(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the document name information.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         The string of document name.
 */
MTCFUNC ZCONST ZCHAR * Mtc_DsrGetDocName(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the document memo information.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         The string of document memo.
 */
MTCFUNC ZCONST ZCHAR * Mtc_DsrGetDocMemo(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the document user data information.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         The string of document user data.
 */
MTCFUNC ZCONST ZCHAR * Mtc_DsrGetDocUserData(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the document page count.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         The count of pages.
 */
MTCFUNC ZUINT Mtc_DsrGetDocPageCount(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get if the user is the owner of document.
 * 
 * @param  pcDocId The document ID string.
 * 
 * @return         ZTRUE, the user is the owner.
 */
MTCFUNC ZBOOL Mtc_DsrIsDocOwner(ZCONST ZCHAR *pcDocId);

/**
 * @brief Get the image file path of specific page index.
 * 
 * @param  pcDocId The document ID string.
 * @param  iPageId The page index, from 0 to count-1.
 * 
 * @return         The path string of image file.
 */
MTCFUNC ZCONST ZCHAR * Mtc_DsrGetPage(ZCONST ZCHAR *pcDocId, ZINT iPageId);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_DSR_H__ */

