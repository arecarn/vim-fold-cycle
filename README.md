Fold Cycling
============
Cycle open and close folds in a org-mode inspired way.

Usage
-----
| Mode   | Default Key | `<Plug>` map         | Description              |
| ------ | ----------- | -------------------- | ------------------------ |
| normal | \<CR>        | `<Plug>(fold-open)`  | Cycle open nested folds  |
| normal | \<BS>        | `<Plug>(fold-close)` | Cycle close nested folds |

Demo
----
![clean fold demo](https://cloud.githubusercontent.com/assets/2142684/7664231/d57b6300-fb32-11e4-9b34-e73ac9099e77.gif)

Customization
-------------
Example:
```vim
nmap <Tab><Tab> <Plug>(fold-open)
nmap <S-Tab><S-Tab> <Plug>(fold-close)
```
