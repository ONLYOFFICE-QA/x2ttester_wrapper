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

## How To Use

### First, you need to change the parameters in the config.json file

- `version` - version the core. Example: `7.3.0.27`
- `cores` - num cores to use
- `errors_only` - reports only errors (value: `true\false`)
- `delete` - is delete successful conversions files (value: `true\false`)
- `timestamp` - timestamp in report file name (value: `true\false`)
- `input_dir` - path to the folder with the documents
to be converted. By default: `./documents/`
- `output_dir` - path to the folder with
the resulting files. By default: `./tmp/`
- `files_array` - file names for selective conversion
- `core_host_url` - Host address with OnlyOffice core files. Example <https://s3.eu-west-1.amazonaws.com>

Example:

```shell
{
  "version": "7.3.0.27",
  "cores": "4",
  "errors_only": "false",
  "delete": "true",
  "timestamp": "true",
  "input_dir": "./documents/",
  "output_dir": "./output_dir/",
  "files_array": []
  "core_host_url": "https://s3.eu-west-1.amazonaws.com"
}
```

### Download core

```shell
rake download_core
```

### Start conversion with option

```shell
rake convert[input_format,output_format] 
```

### Start selective conversion by file name from config.json

```shell
rake convert_array[input_format,output_format] 
```

Flags:

- `input_format` - (non-required) input extensions of files
(default - all possible input extensions)
- `output_format` - (non-required) output extensions of files
(default - all possible output extensions)

### Start conversion all formats to all formats

```shell
rake convert
```

## Credits

This software uses the following open source packages:
