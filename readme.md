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
- `input_dir` - path to the folder with the documents
to be converted. By default: `./documents/`
- `output_dir` - path to the folder with
the resulting files. By default: `./tmp/`

Example:

```shell
{
  "branch": "release",
  "version": "7.3.0.27",
  "input_dir": "./documents/",
  "output_dir": "./tmp/"
}
```

### Download core

```shell
rake core
```

### Start conversion

```shell
rake convert[cores,direction] 
```

Flags:
`cores` - number of threads
`direction` - conversion direction

## Credits

This software uses the following open source packages:
