# SPDX-FileCopyrightText: 2022-2025 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Documentation       Ballooning tests
Resource            ../../resources/ssh_keywords.resource
Resource            ../../resources/common_keywords.resource
Resource            ../../resources/connection_keywords.resource
Resource            ../../resources/gui_keywords.resource
Library             OperatingSystem
Test Timeout        10 minutes
Suite Setup         Ballooning tests setup
Suite Teardown      Ballooning tests teardown


*** Variables ***
${DISABLE_LOGOUT}     ${EMPTY}


*** Keywords ***

Ballooning tests setup
    [timeout]    5 minutes
    Initialize Variables, Connect And Start Logging

Ballooning tests teardown
    [timeout]    5 minutes
    Connect to ghaf host
    Log journctl
    Close All Connections
