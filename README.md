Fold Cycling
============
This plugin provides the ability to cycle open and closed folds and nested
folds. It could also be described as a  type of visibility cycling similar to
Emacs org-mode.

Usage
-----
| Mode   | Default Key | `<Plug>` map                      | Description              |
| ------ | ----------- | --------------------------------- | ------------------------ |
| normal | \<CR>       | `<Plug>(fold-cycle-open)`         | Cycle open fold          |
| normal | \<BS>       | `<Plug>(fold-cycle-close)`        | Cycle close fold         |
| normal | z\<CR>      | `<Plug>(fold-cycle-open-global)`  | Cycle open all folds     |
| normal | z\<BS>      | `<Plug>(fold-cycle-close-global)` | Cycle close all folds    |

Demo
----
![clean fold demo](https://cloud.githubusercontent.com/assets/2142684/7664231/d57b6300-fb32-11e4-9b34-e73ac9099e77.gif)

Customization
-------------
Examples:

Using just the "fold open" commands
```vim
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <CR> <Plug>(fold-cycle-open)
nmap <BS> <Plug>(fold-cycle-open-global)
```
or
```vim
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <TAB><TAB> <Plug>(fold-cycle-open)
nmap <S-TAB><S-TAB> <Plug>(fold-cycle-open-global)
```

Some idea's for alternative key mappings
```vim
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap z; <Plug>(fold-cycle-open)
nmap z, <Plug>(fold-cycle-close)
nmap z( <Plug>(fold-cycle-open-global)
nmap z) <Plug>(fold-cycle-close-global)
```

Override Defaults
```vim
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap zo <Plug>(fold-cycle-open)
nmap zc <Plug>(fold-cycle-close)
nmap zr <Plug>(fold-cycle-open-global)
nmap zm <Plug>(fold-cycle-close-global)
```
