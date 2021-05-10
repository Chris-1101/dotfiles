#!/usr/bin/env node
//
//    .d888b, d8888b  88bd88b  .d888b, d8888b   88bd88b .d888b,
//    ?8b,   d8b_,dP  88P' ?8b ?8b,   d8P' ?88  88P'  ` ?8b,
//      `?8b 88b     d88   88P   `?8b 88b  d88 d88        `?8b
//   `?888P' `?888P'd88'   88b`?888P' `?8888P'd88'     `?888P'

//   ~/.config/rofi/sensors.js

// Author       : Chris-1101 @ GitHub
// Description  : Displays a Rofi menu listing all thermal sensory output
// Dependencies : node, rofi

// =================
// --- Functions ---
// =================

const promisify = require('util').promisify;
const exec = promisify(require('child_process').exec);

// Top Level Async
async function main()
{
  // NOTE: A bit manual - `sensors` output lacks common structure
  const sensorsJson = await exec('sensors -j');
  const sensors = JSON.parse(sensorsJson.stdout);

  // Table Structure
  const delimiter = ',';
  const separator = '      ';
  const headers = [ '龍 SENSOR NAME', ' READING', '  INTERFACE' ];
  const title = '                HARDWARE SENSORS                ';

  // Motherboard
  const mobo = [
    'Motherboard',
    sensors['acpitz-acpi-0'].temp1.temp1_input + '°C'
  ];

  // NVMe PCIe M2
  const nvme = [
    'Internal SSD',
    sensors['nvme-pci-5800'].Composite.temp1_input + '°C'
  ];

  // Wifi
  const wifi = [
    'Wifi Card',
    sensors['iwlwifi_1-virtual-0'].temp1.temp1_input + '°C'
  ];

  // Processor
  const cpu0 = [
    'Processor',
    sensors['coretemp-isa-0000']['Package id 0'].temp1_input + '°C'
  ];

  const cpu1 = [
    '· Core 01',
    sensors['coretemp-isa-0000']['Core 0'].temp2_input + '°C'
  ];

  const cpu2 = [
    '· Core 02',
    sensors['coretemp-isa-0000']['Core 1'].temp3_input + '°C'
  ];

  const cpu3 = [
    '· Core 03',
    sensors['coretemp-isa-0000']['Core 2'].temp4_input + '°C'
  ];

  const cpu4 = [
    '· Core 04',
    sensors['coretemp-isa-0000']['Core 3'].temp5_input + '°C'
  ];

  // Battery
  const bat0 = [
    'Battery V',
    sensors['BAT0-acpi-0'].in0.in0_input + 'V'
  ];

  const bat1 = [
    'Battery A',
    sensors['BAT0-acpi-0'].curr1.curr1_input + 'A'
  ];

  // CSV Output
  const csvOutput = [
    mobo, nvme, wifi, cpu0, cpu1, cpu2, cpu3, cpu4, bat0, bat1
  ].map(e => e.join(delimiter)).join('\n');

  // Tabular Output
  const tabOutput = await exec(`printf "${ csvOutput }" | column -t -s '${ delimiter }' -o '${ separator }'`);

  // Launch Rofi
  const options = '-i -dmenu -markup-rows -config ~/.config/rofi/sensors.rasi';
  await exec(`rofi ${ options } <<< "${ tabOutput.stdout.replace(/\n$/, '') }" > /dev/null || true`);
}

// =================
// --- Execution ---
// =================

main();
