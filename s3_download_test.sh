#!/bin/sh

S3_BUCKET="s3://test-web-data-store/test"
S3_CHECK_FILE="test.txt"

OLD_TIMESTAMP_FILE="/tmp/old_file_timestamp.txt"
NEW_TIMESTAMP_FILE="/tmp/new_file_timestamp.txt"

DOWNLOAD_DIR="/tmp"

if [ -f ${NEW_TIMESTAMP_FILE} ] ; then
        mv ${NEW_TIMESTAMP_FILE} ${OLD_TIMESTAMP_FILE}
fi

# S3バケット上のファイルのタイムスタンプを取得
aws s3 ls ${S3_BUCKET}/ | grep "${S3_CHECK_FILE}" | awk '{print $1,$2}' > ${NEW_TIMESTAMP_FILE}

if [ -f ${OLD_TIMESTAMP_FILE} ] ; then

        DIFF_COUNT=`diff ${NEW_TIMESTAMP_FILE} ${OLD_TIMESTAMP_FILE} | wc -l`

        if [ ${DIFF_COUNT} -ge 1 ] ; then

                echo "diff [${S3_BUCKET}/${S3_CHECK_FILE}]"
                echo "aws s3 cp ${S3_BUCKET}/${S3_CHECK_FILE} ${DOWNLOAD_DIR}/"
                aws s3 cp ${S3_BUCKET}/${S3_CHECK_FILE} ${DOWNLOAD_DIR}/

        else

                echo "not diff [${S3_BUCKET}/${S3_CHECK_FILE}]"

        fi
fi
