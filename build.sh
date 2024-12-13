#!/bin/bash
source /opt/buildpiper/shell-functions/functions.sh
source /opt/buildpiper/shell-functions/log-functions.sh
source /opt/buildpiper/shell-functions/str-functions.sh
source /opt/buildpiper/shell-functions/file-functions.sh
source /opt/buildpiper/shell-functions/aws-functions.sh

TASK_STATUS=0

CODEBASE_LOCATION="${WORKSPACE}"/"${CODEBASE_DIR}"
logInfoMessage "I'll do processing at [$CODEBASE_LOCATION]"
sleep  $SLEEP_DURATION
cd  "${CODEBASE_LOCATION}"

aws autoscaling start-instance-refresh \
  --auto-scaling-group-name "${ASG_NAME}" \
  --preferences '{"InstanceWarmup": 30, "MinHealthyPercentage": 30, "SkipMatching": true}' \
  --desired-configuration "$(cat <<EOF
{
    "LaunchTemplate": {
        "LaunchTemplateId": "${LAUNCHTEMPLATE_ID}",
        "Version": "\$Latest"
    }
}
EOF
)"

TASK_STATUS=$?
saveTaskStatus ${TASK_STATUS} ${ACTIVITY_SUB_TASK_CODE}