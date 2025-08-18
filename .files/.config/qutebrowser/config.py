# Open every tab as a new window, Vimb style
# c.tabs.tabs_are_windows = False
# c.tabs.show = "multiple"
c.tabs.last_close = "close"

c.auto_save.session = True
c.scrolling.smooth = True
c.session.lazy_restore = True
c.content.autoplay = False
c.tabs.position = 'left'  # 或 'right'，控制标签栏在窗口左侧或右侧显示
# c.tabs.show = 'multiple'  # 确保多个标签页可同时显示

# Scale pages and UI better for hidpi
# c.zoom.default = "125%"
# c.fonts.hints = "bold 12pt monospace"

# Better default fonts
# c.fonts.web.family.standard = "Bitstream Vera Sans"
# c.fonts.web.family.serif = "Bitstream Vera Serif"
# c.fonts.web.family.sans_serif = "Bitstream Vera Sans"
# c.fonts.web.family.fixed = "JetBrains Mono"
# c.fonts.statusbar = "12pt Iosevka Aile"

# Use dark mode where possible
# c.colors.webpage.darkmode.enabled = True
# c.colors.webpage.darkmode.policy.images = "never"
# c.colors.webpage.bg = "black"

# HiDPI 和字体清晰度优化
c.qt.highdpi = True
c.zoom.default = "100%"
c.fonts.hints = "bold 12pt JetBrains Mono"

# 现代字体配置
c.fonts.web.family.standard = "Noto Sans, Microsoft YaHei, sans-serif"
c.fonts.web.family.serif = "Noto Serif, SimSun, serif"
c.fonts.web.family.fixed = "JetBrains Mono, Cascadia Code"
c.fonts.statusbar = "12pt Iosevka Aile"

# 黑暗模式优化
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.algorithm = "lightness-hsl"

# Automatically turn on insert mode when a loaded page focuses a text field
c.input.insert_mode.auto_load = True

# Edit fields in Emacs with Ctrl+E
c.editor.command = ["emacsclient", "+{line}:{column}", "{file}"]

# Make Ctrl+g quit everything like in Emacs
config.bind('<Ctrl-g>', 'leave-mode', mode='insert')
config.bind('<Ctrl-g>', 'leave-mode', mode='command')
config.bind('<Ctrl-g>', 'leave-mode', mode='prompt')
config.bind('<Ctrl-g>', 'leave-mode', mode='hint')
# config.bind('v', 'spawn ~/.dotfiles/bin/umpv {url}')
# config.bind('V', 'hint links spawn ~/.dotfiles/bin/umpv {hint-url}')

# Tweak some keybindings
config.unbind('d') # Don't close window on lower-case 'd'
config.bind('yy', 'yank')

# Vim-style movement keys in command mode
config.bind('<Ctrl-n>', 'completion-item-focus --history next', mode='command')
config.bind('<Ctrl-p>', 'completion-item-focus --history prev', mode='command')

# More binding hints here: https://gitlab.com/Kaligule/qutebrowser-emacs-config/blob/master/config.py

# Load the autoconfig file (quteconfig.py)
config.load_autoconfig()
