# Tea Time


## Description

A simple desktop timer application.


## Screenshots

![Period entry](http://i.imgur.com/R2jx5.png)
![Countdown](http://i.imgur.com/Q4m1c.png)
![Finish notification](http://i.imgur.com/DlOHw.png)


## Usage

Run *make* to compile. The executable is called *teatime*. To
install, copy it somewhere in your *PATH*.

You can pass a the time as a command-line option in format
*minutes* or *minutes:seconds* or *:seconds*. Then the countdown is
started immediately. Otherwise the time period can be chosen
interactively.

In the interactive interface, aside from using the graphical
buttons, the time period can also be changed using the arrow keys
on the keyboard. The countdown can be started with the *Enter* or
*Space* keys.

When the countdown is complete, the program shows a notification
box. Depending on the system configuration, this may emit a sound.


## Dependencies

- GTK+ 3.0
- Vala 0.12.0 if compiling from Git repository


## License

Copyright © 2016 kspi

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
