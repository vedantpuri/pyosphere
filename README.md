![Header](https://raw.githubusercontent.com/vedantpuri/pyosphere/master/resources/header.png)

Python projects that have complex codebase directory structures introduce a fairly common problem with **imports** within the project. While providing absolute paths is recommended, it is cumbersome, repetitive, and rather **boilerplate**. Absolute imports may also decrease application portability. **pyosphere.sh** mitigates these issues by simply providing a flattened execution environment, allowing all files to relatively import each other trivially, while allowing developers to maintain their choice of directory structure.

## Requirements
- macOS or Linux
- Bash >= **3.2** (lower versions untested)

## Installation
**pyosphere.sh** can be installed or deployed in many ways:

### Homebrew (Coming Soon)
Install with [homebrew](https://brew.sh):
```bash
brew tap vedantpuri/concoctions
brew install pyosphere
```

### Manual System Install
For **macOS**, you can install from the repo directly:
```bash
mkdir -p -m 775 /usr/local/bin/ && curl -s "https://api.github.com/repos/vedantpuri/pyosphere/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | xargs curl -L -s -0 > /usr/local/bin/pyosphere && chmod +x /usr/local/bin/pyosphere && chmod 700 /usr/local/bin/pyosphere
```

For **Linux**, you can do the same for the local user (requires `curl`, `sed`, `grep`, and `xargs`):
```bash
mkdir -p ~/bin && curl -s "https://api.github.com/repos/vedantpuri/pyosphere/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | xargs curl -L -s -0 > ~/bin/pyosphere && chmod +x ~/bin/pyosphere && chmod 700 ~/pyosphere
```

You can also download specific versions to your project:
```bash
cd ~/path/to/project
curl -L -s "https://github.com/vedantpuri/pyosphere/releases/download/1.0.0/pyosphere.sh" > pyosphere.sh && chmod +x pyosphere.sh
```

Alternatively, download [pyosphere.sh](https://github.com/vedantpuri/pyosphere/releases/) and make it executable:
```bash
cd ~/path/to/downloaded/script
chmod +x pyosphere.sh
```

## Usage
**pyosphere.sh** is designed to be as simple as possible to use. It has 2 aspects:
- **"pyosphere"** directory - created in your project directory when the script genreates a build
- **"pyosphere.config"** file - can be generated using the script that specifies a configuation for the build

### Step 1
Navigate to your python project.
```bash
cd ~/path/to/project
```

### Step 2
To build and run with default **pyosphere** settings:
```bash
pyosphere
```

Initialize pyosphere in this project.
```bash
pyosphere -i
```
Auto-generates **pyosphere.config** in your project with default settings, and does not build/execute.

**or**
```bash
pyosphere -ie="python_file_to_be_executed"
```
Auto-generates **pyosphere.config** in your project with specified file as `run_source`. Does not build/execute.

### Step 3
By default, **pyosphere.sh** auto-detects configuration files if they use the default naming scheme. You can specify the **config** file yourself, although you must ensure that it is a **bash** script:
```bash
# auto-detect configuration (pyosphere.config)
pyosphere
# If filename is different
pyosphere -cf="myconfig.config"
# You can use any extension for this file, or none
pyosphere -cf="myconfig"
```

### Options
- #### Initialize pyosphere (`-i|--init`)
  Generate a default **pyosphere.config** file in current directory
- #### Initialize Execution (`-ie=|--init-exec=`)
  Initialize pyosphere in current dir and specify which python file to run in configuration file
- #### Configuration (`-cf=|--config-file=`)
  Specify path to configuration file
- #### Prune project (`-p|--prune`)
  Remove unused project files from future builds
- #### Clean project (`-cl|--clean`)
  Clean pyosphere build
- #### Reset project (`-r|--reset`)
  Reset project to its state prior to use of pyosphere
- #### Silent (`-s|--silent`)
  Silence pyosphere echo messages while executing project
- #### Version (`-v|--version`)
  Print script version
- #### Help (`-h|--help`)
  Print script usage
  
You can tune the following options in your configuration file:
- #### python_bin (default = `python`)
  Specify **python** binary to use (such as **python**, **python3**, or their full paths)
- #### project_path (default = `pwd`)
  Specify project path if different
- #### always_prune (default = `false`)
  Specify preference to prune (`-p|--prune`) every build
- #### run_source
  Specify python file to run on executing build

Not providing one or more of these fields is acceptable and default settings will be inferred in such cases.

## Limitations
Due to the semantics of the script it fails to work as expected in projects which have:
- Multiple files with the **same name**
- Using hard-coded file paths in your projects (use `os.path` instead to generalize)

## Contributing
This is an open-source project and contribution is cordially welcome. Refer to [contribution guidelines](https://github.com/vedantpuri/pyosphere/blob/master/.github/CONTRIBUTING.md) for further details on how to contribute. Also be sure to view the [code of conduct.](https://github.com/vedantpuri/pyosphere/blob/master/CODE_OF_CONDUCT.md)

## License
 The project is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/pyosphere/blob/master/LICENSE.md) file for more information.
