#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2019, Informatique CDC.
# GNU General Public License v3.0+ (see LICENSE or https://www.gnu.org/licenses/gpl-3.0.txt)

# This is a windows documentation stub.  Actual code lives in the .ps1
# file of the same name.

from __future__ import absolute_import, division, print_function
__metaclass__ = type


ANSIBLE_METADATA = {'metadata_version': '1.0',
                    'status': ['preview'],
                    'supported_by': 'community'}


DOCUMENTATION = r'''
---
module: win_sqlserver_ceip
short_description: Enables or disables the CEIP for SQL Server
author:
    - Stéphane Bilqué (@sbilque)
description:
    - Ansible module to enable or disable the Customer Experience Improvement Program (CEIP) for SQL Server on Windows-based systems.
    - This module examines all specific registry locations and services where a value indicates that the CEIP is enabled.
    - Before SQL Server 2016, you had the possibility to check the case "Send Windows and SQL Server Error Reports...." during the installation if you want to be a part of the Customer Experience Improvement Program (CEIP).
    - In SQL Server 2016, after the installation, all of the CEIP are automatically turned on.
options:
    state:
        description:
            - Specifies the state needed for the Customer Experience Improvement Program (CEIP) for SQL Server.
        choices: [ "present", "absent" ]
        required: 'Yes'
        type: str
notes:
    - This module uses some partial or full parts of open source functions in PowerShell belows.
    - SQL Server Tips - Deactivate the Customer Experience Improvement (U(https://blog.dbi-services.com/sql-server-tips-deactivate-the-customer-experience-improvement-program-ceip/))
    - How to turn off telemetry for SQL 2016 (U(https://stackoverflow.com/questions/43548794/how-to-turn-off-telemetry-for-sql-2016))

'''

EXAMPLES = r'''
---
- hosts: all

  roles:
      - win_sqlserver_ceip

  tasks:

      - name: Disable all CEIP services
        win_sqlserver_ceip:
          state: absent

      - name: Enable all CEIP services
        win_sqlserver_ceip:
          state: present
'''

RETURN = r'''
'''
