# Customization Project Template

## Overview
The template repo provides a customization package scaffold for Acumatica xRP Framework. With this scaffold, you create a standard customization project with common framework dependencies, build scripts and assets folder layouts.


## Project Setup
To generate project scaffold run `csMake.ps1` script as follows. `Usage: csMake.ps1 <Project Name>`
### CMD
```
powershell  ./csMake.ps1 Demo

```

## Generated Repository structure

```
.
├── OpenVS.bat                  <!-- This this file to open solution or change location of your ERP Site
|
├── YOUR_PROJECT.sln
|
├── assets
│   ├── GI
│   ├── Pages
│   │   └── MY                  <!-- New aspx pages e.g (MYPE1001.aspx)
│   ├── Pages_Ext               <!-- Extensions to existing pages
│   ├── Reports
│   ├── SiteMap
│   ├── Sql
│   ├── Tables                  <!-- New table definitions
│   └── Tables_Ext              <!-- Extensions to existing tables
|
├───src
│   └───Demo
│       ├───Attributes
│       ├───Extentions
│       └───DAC
|
├── tests
│   └── YOUR_PROJECT.Tests
|
├── database
│       └── Schema.sql          <!-- This is where you keep SQL Schema
|
├── build.cake                  <!-- Build definition
├── build.ps1                   <!-- Cake bootstrap file
|
└── tools
    └── CsPack                  <!-- Customization packaging utility

```

## Prerequisites
* [.NET 4.8 Developer Pack](https://dotnet.microsoft.com/download/dotnet-framework/net48)
* ERP Site


### Site Resolution
As this is a customisation, the presence of the ERP Site is required.  When setting up your development environment please follow one of the conventions to describe location of your ERP Site.

By default, we use relative paths so find the ERP Site. The build script and solution looks for the site in the folder above the current repository. Once done you will be able to build this solution or run ./build.ps1.

```
.
├── site   <!-- The default location of the site
|
├── code
|
├── customisations
|   |
│   └── YOUR_PROJECT
└── data

```

Alternately, you can use a different directory path. You can use `OpenVS.bat` to specify location of the site, or create an Environment variable.

Name = ADVANCEDPESITEDIR
Value = The path to your site directory e.g C:\src\advanced\code\Source\App\WebSites\Pure\Site\


Restrictions:
 - We use relative paths at the project level as $(SolutionDir) is only defined when building a solution in the IDE and would not be available when compiling via ./build.ps1.
 - Because a .sln Project definition cannot be conditionally configured it has been wired to the environment variable. If you do NOT define this variable then you cannont load the Site project.
 - ./build.ps1 still takes a SitePath argument but this MUST match the directory used by Directory.Build.props. It will also be overriden by ADVANCEDPESITEDIR if it exists.

## Compiling and Running
### Build in VS
- [ ] Clone this repo.
- [ ] Set the siste as startup project, and run

### Build in CLI
- [ ] Clone this repo.
- [ ] Run from the root of your project directory.

```
.\build.ps1

```

### Running Unit Tests
```
.\build.ps1 -Target UnitTests
```

## Conventions
1. Graph Extensions - go to Extentions\PMProjectMaintExt
2. DACs & DAC Extentions -  DAC\MYPESetup, DAC\MYPEAPTran.  Note: NO need add namespace DAC segment to the namespace e.g `MYOB.Objects.PE.DAC`. Doing creates concise code and does require unnecessary import of name space.
3. You using folders to modules the code is totally
4. Both cache extensions (virtual or with backed table) and new DAC must have designated module prefix e.g MYPExYourDAC  or MYPExPMSetup
5. Cache extensions names MUST end with the extended table e.g MYPExPMSetup (PMSetup is the original table)
6. Graphs -> ProjectMaint.cs No need for a prefix, in are already in the namespace of the project. If you MUST use to letters of you nominated code e.g [PE]ProjectMaint
7. User defined fields MUST have designated prefix in the name e.g `UsrMYPExClaimNbrAttributeID`


### Examples

```
namespace MyProject   // <===== 2  Do not use DAC in the namespace
{
	public class MyCustomTable : IBqlTable {
	}

    public sealed class MAPExPMSetup : PXCacheExtension<PMSetup> {

        public abstract class usrMAPExClaimNbrAttributeID : PX.Data.BQL.BqlString.Field<usrMAPExClaimNbrAttributeID> { }
        public string UsrMAPExClaimNbrAttributeID { get; set; }
    }

```

# Customizations
## Screens

- [ ] Create new pages as per screen and report numbering conventions
- [ ] Modify an existing page using Layout Editor
- [ ] Modify the pages using in app - ASPX
- [ ] Modify publish paged ASPX page


## Other
- [ ] Feature File
- [ ] Export
- [ ] Site Map
- [ ] Business Events
- [ ] External files and libraries

## Database

### Create new tables

1. Create DDL for a new table and update database\schema.sql (Choose dialect either MSSQL\MYSQL.  Depends on your local RDBMS and if you plan on migrating the project to the main extension)
2. Run the script against a local database
3. Create file Sql_MYPEDACName.xml e.g (assets\Tables\MYPESetup.xml)
4. Alternatively, refresh the customization project to load the new table and extract definition XML.

### Data changes via SQL
 1. Do seed table(s) with the database. Create file `assets\Sql_AppUpdate.xml` Use VSQL dialect.

### Changes of the tables via C#

1. Use `CustomizationPlugin.UpdateDatabase()` to update the database


## Export Project

## CI/CD
- [ ] Project runs CI with automated build and test on each PR.
- [ ] Team City


# References

- [Customization Guide](https://help-2021r1.acumatica.com/(W(1))/Help?ScreenId=ShowWiki&pageid=316b14fa-f406-4788-993c-7b043b1c5bd9)
- [Custom Feature Switch](https://help-2021r1.acumatica.com/(W(1))/Help?ScreenId=ShowWiki&pageid=8285172e-d3b1-48d9-bcc1-5d20e39cc3f0)

