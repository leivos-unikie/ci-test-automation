# SPDX-FileCopyrightText: 2022-2024 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Documentation       Performance tests
Resource            ../../resources/ssh_keywords.resource
Resource            ../../config/variables.robot
Resource            ../../resources/power_meas_keywords.resource
Suite Setup         Common Setup
Suite Teardown      Common Teardown


*** Keywords ***

Common Setup
    Set Variables   ${DEVICE}

Common Teardown
    # This keyword creates a power vs time graph from start_timestamp (set before) to current moment
    Generate power plot           ${BUILD_ID}   full HW test

    # Only save the accumulated power log file to ../../../power_measurements/ and log average power
    Get power record              ${BUILD_ID}.csv
    Log average power             ../../../power_measurements/${BUILD_ID}.csv

    # Without this measurement agent will log power forever (need to add some timeout to power logging script)
    # Could be placed also to suite Teardown
    Stop recording power

    # Switch connection back to target in case test run continues with other test cases
    Run Keyword And Ignore Error  Switch Connection                 ${ghaf_host_ssh}
    Close All Connections
