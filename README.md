# godeplist

zsh script to list go dependencies from main module

``` bash
chmod +x godeplist.zsh
alias godeplist="$(pwd)/godeplist.zsh"
```

## usage

- `godeplist`: list all dependencies
- `godeplist <modules>`: list only in modules

### option

- `-d DELIM`: change delimiter (default: ` `)
