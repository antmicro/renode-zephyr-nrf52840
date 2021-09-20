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

Should Return Provided Date
    Requires                    booted-zephyr
    Write Line to Uart          date set 2021-09-16 00:00:00
    Wait for Line on Uart       2021-09-16 00:00:00 UTC

Should Return Consecutive Params
    Requires                    booted-zephyr
    Write Line to Uart          demo params a b c
    Wait for Line on Uart       argc = 4
    Wait for Line on Uart       argv[0] = params
    Wait for Line on Uart       argv[1] = a
    Wait for Line on Uart       argv[2] = b
    Wait for Line on Uart       argv[3] = c

Should Create Dynamic Command
    Requires                    booted-zephyr
    Write Line to Uart          dynamic add test
    Wait for Line on Uart       command added successfully
    Write Line to Uart          dynamic execute test
    Wait for Line on Uart       dynamic command: test
    Write Line to Uart          dynamic remove test
    Wait for Line on Uart       command removed successfully

Should Return Pong
    Requires                    booted-zephyr
    Write Line to Uart          demo ping
    Wait for Line on Uart       pong

Should Enumerate Available Devices
    Requires                    booted-zephyr
    Write Line to uart          device list
    Wait for Line on Uart       devices:
    Wait for Line on Uart       - CLOCK (READY)
    Wait for Line on Uart       - UART_1 (READY)
    Wait for Line on Uart       - UART_0 (READY)
    Wait for Line on Uart       - sys_clock (READY)
    Wait for Line on Uart       - GPIO_0 (READY)
    Wait for Line on Uart       - GPIO_1 (READY)
