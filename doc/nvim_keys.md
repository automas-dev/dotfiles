---
title: "NeoVim Keymap"
draft: false
---

**Leader**: <kbd>,</kbd>

key | command | name
--|--|--
\<leader\> <kbd>s</kbd> <kbd>s</kbd> | setlocal spell! | Toggle spell check
\<leader\> <kbd>s</kbd> <kbd>t</kbd> | syntax spell toplevel | Expand spell check to top level
<kbd>Ctrl</kbd>+<kbd>down</kbd> | ... | Move line down
<kbd>Ctrl</kbd>+<kbd>up</kbd> | ... | Move line up
<kbd>Alt</kbd>+<kbd>h</kbd> | ... | Switch to panel left
<kbd>Alt</kbd>+<kbd>j</kbd> | ... | Switch to panel down
<kbd>Alt</kbd>+<kbd>k</kbd> | ... | Switch to panel up
<kbd>Alt</kbd>+<kbd>l</kbd> | ... | Switch to panel right
<kbd>Ctrl</kbd>+<kbd>left</kbd> | bprev | Switch to previous buffer
<kbd>Ctrl</kbd>+<kbd>left</kbd> | bnext | Switch to next buffer
\<leader\> <kbd>f</kbd> <kbd>b</kbd> | read !figlet -f big | Insert big figlet banner
\<leader\> <kbd>f</kbd> <kbd>n</kbd> | read !figlet -f standard | Insert standard figlet banner
\<leader\> <kbd>f</kbd> <kbd>s</kbd> | read !figlet -f small | Insert small figlet banner
<kbd>w</kbd> <kbd>!</kbd> | !sudo tee > /dev/null % | Write as sudo
<kbd>Ctrl</kbd>+<kbd>k</kbd> <kbd>n</kbd> | ... | Open horizontal terminal
<kbd>Ctrl</kbd>+<kbd>k</kbd> <kbd>Ctrl</kbd>+<kbd>n</kbd> | ... | Open vertical terminal
<kbd>Ctrl</kbd>+<kbd>b</kbd> | ... | Toggle NERDTree panel
<kbd>g</kbd> <kbd>d</kbd> | (coc-definition) | Goto Definition
<kbd>g</kbd> <kbd>y</kbd> | (coc-type-definition) | Goto Type Definition
<kbd>g</kbd> <kbd>i</kbd> | (coc-implementation) | Goto Implementation
<kbd>g</kbd> <kbd>r</kbd> | (coc-references) | Show References
<kbd>Shift</kbd>+<kbd>k</kbd> | show_documentation() | Show Documentation
\<leader\> <kbd>r</kbd> <kbd>n</kbd> | (coc-rename) | Rename Symbol
<kbd>Ctrl</kbd>+<kbd>k</kbd> <kbd>Ctrl</kbd>+<kbd>r</kbd> | (coc-rename) | Rename Symbol
\<leader\><kbd>f</kbd> | (coc-format-selected) | Format Selected
<kbd>Ctrl</kbd>+<kbd>f</kbd> | ... | Format File
<kbd>Ctrl</kbd>+<kbd>f</kbd> <kbd>Esc</kbd> | ... | Format File
<kbd>Ctrl</kbd>+<kbd>k</kbd> <kbd>Ctrl</kbd>+<kbd>d</kbd> | ... | Format File
<kbd>Ctrl</kbd>+<kbd>k</kbd> b | ... | CMake Build
<kbd>Ctrl</kbd>+<kbd>k</kbd> <kbd>Ctrl</kbd>+<kbd>b</kbd> | ... | CMake Build
<kbd>F5</kbd> | ... | CMake Build
<kbd>Ctrl</kbd>+<kbd>l</kbd> | (coc-snippets-expand) | Trigget snippet expand
<kbd>Ctrl</kbd>+<kbd>j</kbd> | (coc-snippets-select) | Select text for visual placeholder of snippet
<kbd>Ctrl</kbd>+<kbd>j</kbd> | (coc-snippets-expand-jump) | Trigget expand snippet and jump
<kbd>Ctrl</kbd>+<kbd>j</kbd> | ... | Jump to next snippet
<kbd>Ctrl</kbd>+<kbd>k</kbd> | ... | Jump to previous snippet

