# SPDX-FileCopyrightText: 2022-2025 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Documentation       Common system tests
Force Tags          others
Resource            ../../resources/ssh_keywords.resource
Resource            ../../resources/serial_keywords.resource
Library             ../../lib/output_parser.py

*** Test Cases ***

Test ballooning
    [Documentation]    Check if dynamic allocation of memory works when consuming a lot of memory.
    [Tags]             ballooning
    ${timeout}         Set Variable   60
    Connect to VM                     chrome-vm
    Put File                          ballooning-tests/consume_memory   /tmp
    Execute Command                   chmod 777 /tmp/consume_memory
    Log To Console                    Starting to consume memory
    Run Keyword And Ignore Error      Execute Command  -b timeout ${timeout} /tmp/consume_memory  sudo=True  sudo_password=${PASSWORD}  timeout=3

    Log To Console                    Logging total and available memory
    ${start_time}=                    Get Time	epoch
    FOR    ${i}    IN RANGE    120
        ${total_mem}=                 Execute Command  free -h | awk -F: 'NR==2 {print $2}' | awk '{print $1}'
        ${available_mem}=             Execute Command  free -h | awk -F: 'NR==2 {print $2}' | awk '{print $6}'
        Log                           Total memory: ${total_mem} / Available memory: ${available_mem}  console=True
        ${diff}=                      Evaluate    int(time.time()) - int(${start_time})
        IF   ${diff} < ${timeout}
            Sleep    1
            CONTINUE
        ELSE
            BREAK
        END
    END

    Log To Console                    Releasing memory
    Execute Command                   rm /dev/shm/test/*    sudo=True  sudo_password=${PASSWORD}
    Execute Command                   rm -r /dev/shm/test   sudo=True  sudo_password=${PASSWORD}

    Log To Console                    Logging total and available memory
    ${start_time}=                    Get Time	epoch
    FOR    ${i}    IN RANGE    60
        ${total_mem}=                 Execute Command  free -h | awk -F: 'NR==2 {print $2}' | awk '{print $1}'
        ${available_mem}=             Execute Command  free -h | awk -F: 'NR==2 {print $2}' | awk '{print $6}'
        Log                           Total memory: ${total_mem} / Available memory: ${available_mem}  console=True
        ${diff}=                      Evaluate    int(time.time()) - int(${start_time})
        IF   ${diff} < 30
            Sleep    1
            CONTINUE
        ELSE
            BREAK
        END
    END
