# win_sqlserver_ceip - Enables or disables the CEIP for SQL Server

## Synopsis

* Ansible module to enable or disable the Customer Experience Improvement Program (CEIP) for SQL Server on Windows-based systems.
* This module examines all specific registry locations and services where a value indicates that the CEIP is enabled.
* Before SQL Server 2016, you had the possibility to check the case "Send Windows and SQL Server Error Reports...." during the installation if you want to be a part of the Customer Experience Improvement Program (CEIP).
* In SQL Server 2016, after the installation, all of the CEIP are automatically turned on.

### Parameters

| Parameter | Required | Choices/Defaults                           | Comments                                                                                          |
| --------- | -------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| state     | no       | Choices: <ul><li>present <-<li>absent</ul> | Specifies the state needed for the Customer Experience Improvement Program (CEIP) for SQL Server. |

## Examples

```yaml
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
```

## License

GNU General Public License v3.0

See [LICENCE](LICENCE.txt) to see the full text.

## Author Information

* **Stéphane Bilqué** - [sbilque](https://github.com/sbilque)

## Open Source Components

This module uses some partial or full parts of open source functions in PowerShell :

* SQL Server Tips: Deactivate the Customer Experience Improvement ([Source blog.dbi-services.com](https://blog.dbi-services.com/sql-server-tips-deactivate-the-customer-experience-improvement-program-ceip/))
* How to turn off telemetry for SQL 2016 ([Source stackoverflow.com](https://stackoverflow.com/questions/43548794/how-to-turn-off-telemetry-for-sql-2016))
  