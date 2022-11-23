# x2tester wrapper

Wrapper of the x2t test utility

## Getting start

For local startup in developer mode,
recommended installing a local `bundle config` file.

```shell
  bundle config set --local with development
```

Afterwards install the dependencies with the bundle.

```shell
  bundle install
```

### Private fonts as a submodule

The x2ttester run uses fonts from a private repository.
You can install them as a `member` of ONLYOFFICE-QA
and must have `ssh` access to the repository set up.

```shell
  git submodule update --init --recursive
```

## Key Features

## How To Use

### First, you need to change the parameters in the config.json file

- `branch` - branch name with core. Examle: `release`
- `version` - version the core. Example: `7.3.0.27`
- `cores` - num cores to use
- `errors_only` - reports only errors (default - 0)
- `delete` - is delete successful conversions files (default - 0)
- `timestamp` - timestamp in report file name (default - 1)
- `input_dir` - path to the folder with the documents
to be converted. By default: `./documents/`
- `output_dir` - path to the folder with
the resulting files. By default: `./tmp/`
- `files_array` - file names for selective conversion

Example:

```shell
{
  "branch": "release",
  "version": "7.3.0.27",
  "cores": "4",
  "errors_only": "1",
  "delete": "1",
  "timestamp": "1",
  "input_dir": "./documents/",
  "output_dir": "./tmp/",
  "files_array": []
}
```

### Download core

```shell
rake core
```

### Start conversion with option

```shell
rake convert[input_format,output_format,list] 
```

Flags:
`input_format` - (non-required) input extensions of files
(default - all possible input extensions)
`output_format` - (non-required) output extensions of files
(default - all possible output extensions)
`list` - file list conversion, pass ls value to enable.
Example: `rake convert[,,ls]`

### Start conversion all formats to all formats

```shell
rake convert
```

## Credits

This software uses the following open source packages:
