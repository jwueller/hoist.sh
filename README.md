# `hoist.sh`

**Move files up the directory tree.**

## Requirements

- **POSIX-compliant shell:** Works with shells like `bash` or even plain `sh`.

## Installation

To use `hoist`, just download the [latest release](https://github.com/jwueller/hoist.sh/releases/latest) to where you want it, then make it executable:

```sh
sudo curl -Lo /usr/local/bin/hoist https://github.com/jwueller/hoist.sh/releases/latest/download/hoist
sudo chmod +x /usr/local/bin/hoist
```

## Examples

### Hoisting a directory

These examples show how the file structure on the left is transformed into the one on the right.

```sh
hoist dir1/
# .                   .
# ├── carol           ├── carol
# └── dir1        →   │
#     ├── dave    →   ├── dave
#     └── emily   →   └── emily
```

### Hoisting a file

```sh
hoist dir1/emily
# .                   .
# ├── carol           ├── carol
# └── dir1            ├── dir1
#     ├── dave        │   └── dave
#     └── emily   →   └── emily
```

### Hoisting across multiple levels 

```sh
hoist -n 2 dir1/dir2/
# .                       .
# ├── carol               ├── carol
# └── dir1                ├── dir1
#     ├── dave            │   └── dave
#     └── dir2        →   │
#         └── emily   →   └── emily
```

## Versioning

This project uses [Semantic Versioning](https://semver.org/), so you can expect a new release to indicate backwards-incompatible changes with a new major version number, although those will be avoided if at all possible. Documentation or formatting changes without user-facing impact will not trigger a new version.

## License

Copyright 2024 Johannes Wüller <johanneswueller@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; If not, see <http://www.gnu.org/licenses/>.
