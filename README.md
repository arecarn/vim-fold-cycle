Fold Cycling
============
This plugin provides the ability to cycle open and closed folds and nested
folds. It could also be described as a  type of visibility cycling similar to
Emacs org-mode.

Usage
-----
| Mode   | Default Key | `<Plug>` map               | Description              |
| ------ | ----------- | -------------------------- | ------------------------ |
| normal | \<CR>       | `<Plug>(fold-cycle-open)`  | Cycle open nested folds  |
| normal | \<BS>       | `<Plug>(fold-cycle-close)` | Cycle close nested folds |

Demo
----
![clean fold demo](https://cloud.githubusercontent.com/assets/2142684/7664231/d57b6300-fb32-11e4-9b34-e73ac9099e77.gif)

Customization
-------------
Example:
```vim
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <Tab><Tab> <Plug>(fold-cycle-open)
nmap <S-Tab><S-Tab> <Plug>(fold-cycle-close)

" Won't close when max fold is opened
let g:fold_cycle_toggle_max_open  = 0
" Won't open when max fold is closed
let g:fold_cycle_toggle_max_close = 0

```
