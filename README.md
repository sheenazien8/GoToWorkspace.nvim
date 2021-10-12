
# GoToWorkspace

This plugin will help you to move around your project easily, and it will also save your working session 


## Installation

Install with [vim-plug](https://github.com/junegunn/vim-plug):
```viml
Plug 'sheenazien8/GoToWorkspace.nvim'
```
Install with [packer](https://github.com/wbthomason/packer.nvim):
```viml
use 'sheenazien8/GoToWorkspace.nvim'
```
## Usage

```viml
lua << EOF
require('GoToWorkspace')
EOF
```

  
### Commands

| Command | Description                |
| :-------- |  :------------------------- |
| `:GoToWorkspace <args>` | Move to your another projects |
| `:SaveSession` | Save your current session |
| `:SessionRestore` | Restore your last session |
| `:OpenWorkspace` | Opens the file that stores all the sessions you have saved, json file |
  
## Roadmap

- Add setup function
- Refactor to lua OOP
- Write documentation
- Integrate with another plugin like [Telescope](https://github.com/nvim-telescope) or other plugins

  
## Related Plugins

Here are some related projects

- [Extended session management for Vim](https://github.com/xolox/vim-session)
- [vim-simple-sessions](https://github.com/isaacmorneau/vim-simple-sessions)
## Authors

- [@sheenazien8](https://github.com/sheenazien8)

  
## Support

For support, you can make PR in this repository, or you can gave me rupiahs in my [Trakteer Account](https://trakteer.id/sheena-zien-rw6gf)

  
## License

[MIT](https://choosealicense.com/licenses/mit/)

  
