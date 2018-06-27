![Header](https://raw.githubusercontent.com/vedantpuri/pyosphere/master/resources/header.png)

A script that simulates a flatted development environment to enable easy  imports in **python**.

<!-- Problem -->
<!--
- Running a file from a diff location spoils importing
- Confusing and complicated ways to import files in python (relative imports etc)
-->
<!-- Solution -->
<!--
- Aggregation of hard-links of all py files into one folder
- Simply import 'filename'. No path or relative imports or anything of that sort needed.
-->
## Requirements
- macOS or Linux OS
- bash >= 3.2
- A Python Project

<!--  curl ??  @mayankk2308-->

## Installation
Below are different ways to install the script and get it up and running.
- Using Bash
  <!--  To be filled by @mayankk2308-->
  <!-- This will automatically install the latest version of pyosphere.sh. -->

<!-- - Using HomeBrew -->
- Using Simple GitHub Download
  - Download the [latest release](https://github.com/vedantpuri/pyosphere/releases).
  - Run the following commands in **Terminal**:
  <!-- ```bash
  $ cd ~/Downloads
  $ chmod +x pyosphere.sh
  $ ./pyosphere.sh
  ``` -->

## Usage
### Step 1
Navigate to your python project.
```bash
$ cd ~/path/to/project
```

### Step 2
Initialize pyosphere in this project.
```bash
$ pyosphere -i
```
**or**
```bash
$ pyosphere -ie="python_file_to_be_executed"
```
This creates a **pyosphere.config** file in your project directory. One could always edit it to alter the configuration. This would be compulsory if you used solely the '-i' flag because you would have to specify the `run_source` within the config file.

### Step 3
Run pyosphere to execute your python file.
```bash
$ pyosphere -cf="pyosphere.config"
```
This runs your specified `run_source` according to the configuration within **pyosphere.config**.

### Options
- #### Initialize pyosphere (`-i|--init`)
  Generates a default **pyosphere.config** file in current directory.
- #### Initialize Execution (`-ie=|--init-exec=`)
  Initializes pyosphere in current dir + Specifies which python file to run in **pyosphere.config**.
- #### Configuration (`-cf=|--config-file=`)
  Provides path to **pyosphere.config** which is then parsed to execute the `run_source` mentioned within.
- #### Prune project (`-p|--prune`)
  Gets rid of redundant files from the **pyosphere** directory.
- #### Clean project (`-cl|--clean`)
  Cleans the project, i.e. Deletes the **pyosphere** directory from the project.
- #### Reset project (`-r|--reset`)
  Cleans + Removes **pyosphere.config**.
- #### Silent (`-s|--silent`)
  Executes silently, only output seen is that from python execution.
- #### Script Version (`-v|--version`)
  Prints the current version of **pyosphere.sh**.
- #### Help (`-h|--help`)
  Prints a manual of how to use the script.

## Limitations
Due to the semantics of the script it fails to work as expected in projects which have:
- Multiple files with the same name.
- Hard coded file paths(resources) within the python code. This could be solved using  os.path to make the path dynamic.

## Contributing
This is an open-source project and contribution is cordially welcome. Refer to [contribution guidelines](https://github.com/vedantpuri/pyosphere/blob/master/.github/CONTRIBUTING.md) for further details on how to contribute. Also be sure to view the [code of conduct.](https://github.com/vedantpuri/pyosphere/blob/master/CODE_OF_CONDUCT.md)

<!-- ## Disclaimer -->
<!-- Short and well worded statement that ensures that script not liable for any issues caused -->

## License
 The project is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/pyosphere/blob/master/LICENSE.md) file for more information.
