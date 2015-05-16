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

------------------------------------------------------------------------------

Fold Style
==========

Also provides alternative to the default foldtext and a new foldmethod

Usage
-----
* `fold#clean_fold_text(foldchar)`
    * cleaner alternative to default fold text, still including number of folded lines
    * `set foldtext=fold#clean_fold_text('_')`

* `fold#cleanest_fold_text()`
    * just include the text on the line except fold markers
    * Usage: `set foldtext=fold#cleanest_fold_text()`

* `fold#get_clean_fold_expr(lnum)`
    * like indent folding but also include first line that is one indent level lower
    * Usage:
        * `set foldmethod=expr`
        * `set foldexpr=fold#get_clean_fold_expr(v:lnum)`

