# SPDX-FileCopyrightText: 2022-2025 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Resource            ../../resources/common_keywords.resource
Resource            ../../resources/connection_keywords.resource
Resource            ../../resources/ssh_keywords.resource
Resource            ../../config/variables.robot
Library             OperatingSystem
Suite Setup         Initialize Variables And Connect
Suite Teardown      Close All Connections


*** Test Cases ***

Run custom command in every VM on LenovoX1
    [Documentation]      Log in to every VM, run the command, report the outputs.
    [Tags]               custom-cmd
    @{vms}          Create List          net-vm
    ...                                  gui-vm
    ...                                  gala-vm
    ...                                  zathura-vm
    ...                                  chrome-vm
    ...                                  comms-vm
    ...                                  admin-vm
    ...                                  audio-vm
    ...                                  business-vm
    Connect to netvm
    OperatingSystem.Create File   custom-test-output.txt
    FOR	 ${vm}	IN	@{vms}
        Connect to VM       ${vm}
        Put File            custom-tests/test_script    /tmp
        Execute Command     chmod 777 /tmp/test_script
        ${output}           Execute Command      /tmp/test_script  sudo=True  sudo_password=${PASSWORD}
        ${vm_colored}=      Evaluate  "\\033[31m${vm}\\033[0m"
        Log To Console      ${vm_colored}
        Log To Console      ${output}
        OperatingSystem.Append To File     custom-test-output.txt  ${vm}\n
        OperatingSystem.Append To File     custom-test-output.txt  ${output}\n\n---------------------\n\n
    END
