# Toolbelt
Collection of scripts and dotfiles that follow me on all of my linux adventures

## 🧰 [Toolbox](toolbox)(scripts)
Colection of scripts to be used in the terminal or on a keybind
* [blind](toolbox/blind.tool) brightness changer for backlight and keyboard (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))
* [bulkrename](toolbox/bulkrename.tool) rename files in your `$EDITOR` (made by [Mendes](https://github.com/mendess/))
* [calendar](toolbox/calendar.tool) notify of next event and open location if there is less than 60 seconds to go
* [cal_sync](toolbox/cal_sync.tool) Sync calendar with vdirsyncer
* [colors](toolbox/colors.tool) display all color codes for text formating (from [flogisoft](https://misc.flogisoft.com/bash/tip_colors_and_formatting))
* [cuffs](toolbox/cuffs.tool) screenshot tool
* [deaf](toolbox/deaf.tool) volume changer (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))
* [death](toolbox/death.tool) warn if all batteries are bellow a certain percent
* [dl_anime](toolbox/dl_anime.tool) TUI to download from [nyaa](https://nyaa.si) based on watching list from [MAL](https://myanimelist.net)
* [dmenu_IQ](toolbox/dmenu_IQ.tool) dmenu app launcher with history
* [ex](toolbox/ex.tool) extract anything
* [launch_and_move](toolbox/launch_and_move.tool) move to a workspace and launch a program (if that program is not running)
* [lock](toolbox/lock.tool) blured lockscreen
* [menu](toolbox/menu.tool) dmenu menu launcher
* [meross-cli](toolbox/meross-cli.tool) control meross lights (integrates with [merossd](https://github.com/JoseFilipeFerreira/merossd))
* [nospace](toolbox/nospace.tool) correct filenames
* [pixel](toolbox/pixel.tool) TUI to draw pixelart for [neofetch](powertools/neofetch)
* [share](toolbox/share.tool) share files in my webserver
* [termFromHere](toolbox/termFromHere.tool) open terminal in the current user, machine and directory
* [timer](toolbox/timer.tool) timer with message and alarm sound
* [tr](toolbox/tr.tool) transmission-remote wrapper
* [udm](toolbox/udm.tool) playlist manager (integrates with [thonkbar](https://github.com/JoseFilipeFerreira/thonkbar))
* [vimtemp](toolbox/vimtemp.tool) open your `$EDITOR` and copy to clipboard on save&exit
* [wall](toolbox/wall.tool) wallpaper manager (integrates with [dmenu](https://github.com/mendess/dmenu)) (color picker made by [mendess](https://github.com/mendess))
* [workin](toolbox/workin.tool) workout manager

## :wrench: [Toolkit](toolkit) (dmenu scripts)
Collection of scripts to be launched from a [menu](toolbox/menu.tool)
* [dock](toolkit/dock.menu) choose display setting
* [emoji](toolkit/emoji.menu) pick a emoji
* [subs](toolkit/subs.menu) subscribe to a RSS feed with categories
* [todo](toolkit/todo.menu) simple TODO list
* [trayer](toolkit/trayer.menu) toggle trayer

## :hammer: [Powertools](powertools) (.dotfiles)
Colection of static config files

## :iphone: [Handtools](handtools)
Collection of scripts I keep on my phone (used with
[Tasker](https://tasker.joaoapps.com/) and
[Termux](https://github.com/termux/termux-app))
* [change_lock](handtools/change_lock.tool) change phone wallpaper
* [control_music](handtools/control_music.tool) control music on a remote device
* [music_devices](handtools/music_devices.tool) choose a remote device to connect with history
* [sync_kiwi](handtools/sync_kiwi.tool) sync phone data with remote
* [toggle_light](handtools/toggle_light.tool) toggle lights

## :link: Install
Collection of installation scripts
* [generate_config](./generate_config.py) templating language for dotfiles (made by [Mendess](https://github.com/mendess/spell-book))
* [hammer](./hammer) Deploy dotfiles and install programs that are part of my [workflow](.workflow.csv)
* [label_printer](./label_printer) autogenerate [README](README.md)
* [nail](./nail) symlink dotfiles and scripts
* [schedule](./schedule) run job scheduler for [Termux](https://github.com/termux/termux-app)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
