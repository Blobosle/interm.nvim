# interm.nvim

`interm.nvim` is a Neovim plugin that provides convenient functions and mappings for managing terminal windows, directory changes, and buffer behavior. It includes features for toggling terminal behavior, adjusting line numbers, and setting custom highlights for terminal windows.

## Features

- Easily open terminals in vertical splits with automatic directory management.
- Toggle between terminal and normal modes with custom key mappings.
- Customize line number display and status line appearance specifically for terminal buffers.
- Automatically handle buffer closing to maintain clean session management.

## Installation

With [Packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'Blobosle/interm.nvim',
    config = function()
      require('interm').setup()
    end
}
```

## Usage

### Functions

- **`cd_and_open_term`**: Opens a terminal in the current file's directory and restores the original directory upon closing.
- **`cd_and_open_term_mod`**: Opens a terminal in a vertical split, restoring the original window and directory when closed.
- **`disable_line_numbers` / `enable_line_numbers`**: Manually disable or enable line numbers.
- **`setup_term_number_toggle`**: Automatically disables line numbers when entering terminal mode and restores them upon exit.
- **`setup_term_highlight`**: Sets terminal-specific background and foreground colors.
- **`setup_term_statusline_highlight`**: Customizes the status line to indicate when the terminal is active.
- **`setup_term_close_autocmd`**: Automatically deletes terminal buffers upon closing.
- **`setup_term_enter_autocmd`**: Adjusts `timeoutlen` upon entering the terminal for quicker mode switching.
- **`setup_term_leave_autocmd`**: Restores `timeoutlen` upon leaving the terminal.

### Key Mappings

- **Normal Mode**:
  - **`Q`**: Opens a terminal in the current file's directory (`cd_and_open_term`).
  - **`<leader>q`**: Opens a terminal in a vertical split with directory tracking (`cd_and_open_term_mod`).
  - **`<S-CR>`**: Cycle through windows.

- **Terminal Mode**:
  - **`<C-q>`**: Exits terminal and closes it with `exit`.
  - **`<S-CR>`**: Cycle through windows.
  - **`<Esc>`**: Exit terminal insert mode.
