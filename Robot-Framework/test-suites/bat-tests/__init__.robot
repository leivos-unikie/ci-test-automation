# SPDX-FileCopyrightText: 2022-2024 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Documentation       BAT tests
Resource            ../../resources/ssh_keywords.resource
Resource            ../../resources/serial_keywords.resource
Resource            ../../resources/common_keywords.resource
Resource            ../../resources/power_meas_keywords.resource
Suite Setup         Common Setup
Suite Teardown      Common Teardown

*** Variables ***

${connection}       ${NONE}

*** Keywords ***

Common Setup
    Set Variables   ${DEVICE}

    # Connects to measurement agent, saves the connection and starts power logging
    Start power measurement   ${BUILD_ID}   timeout=3600
    # Switch connection from measurement agent back to target device
    Run Keyword And Ignore Error  Switch Connection         ${ghaf_host_ssh}

    # This is required for setting the interval for plotting
    Set start timestamp

    Run Keyword If  "${DEVICE_IP_ADDRESS}" == "NONE"    Get ethernet IP address
    ${port_22_is_available}     Check if ssh is ready on device   timeout=60
    IF  ${port_22_is_available} == False
        FAIL    Failed because port 22 of device was not available, tests can not be run.
    END
    ${connection}       Connect
    Set Suite Variable  ${connection}
    Log versions
    Run journalctl recording

Common Teardown
    IF  ${connection}
        Connect
        Log journctl
    END
    Close All Connections
