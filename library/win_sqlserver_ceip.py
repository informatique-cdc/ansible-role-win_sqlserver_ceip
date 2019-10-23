#!/usr/bin/python
# -*- coding: utf-8 -*-

# This is a windows documentation stub.  Actual code lives in the .ps1
# file of the same name.

# Copyright 2019 Informatique CDC. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

from __future__ import absolute_import, division, print_function
__metaclass__ = type


ANSIBLE_METADATA = {'metadata_version': '1.0',
                    'status': ['preview'],
                    'supported_by': 'communoty'}


DOCUMENTATION = r'''
---
module: win_sqlserver_ceip
short_description: Enables or disables the CEIP for SQL Server
author: 
    - Stéphane Bilqué (@sbilque) Informatique CDC 
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
'''

EXAMPLES = r'''
---
- hosts: all

  roles:
      - win_sqlserver_ceip

  tasks:

      - name: Desactivate all CEIP services
        win_sqlserver_ceip:
          state: absent

      - name: Enable all CEIP services
        win_sqlserver_ceip:
          state: present
'''

RETURN = r'''
'''
