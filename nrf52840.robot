*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${SCRIPT}                     ${CURDIR}/nrf52840.resc
${UART}                       sysbus.uart0
${PROMPT}                     uart:~$

*** Keywords ***
Prepare Sample
    [Arguments]                 ${sample_name}

    Execute Command             $bin="${CURDIR}/artifacts/${sample_name}.elf"
    Execute Script              ${SCRIPT}
    Set Default Uart Timeout    60
    Create Terminal Tester      ${UART}

*** Test Cases ***
Should Boot Zephyr
    Prepare Sample              zephyr-shell_module
    Start Emulation
    Wait for Prompt on Uart     ${PROMPT}
    Provides                    booted-zephyr

Should Print Hello World
    Prepare Sample              zephyr-hello_world
    Start Emulation
    Wait for Line on Uart       Hello World

Should Return Pong
    Requires                    booted-zephyr
    Write Line to Uart          demo ping
    Wait for Line on Uart       pong
