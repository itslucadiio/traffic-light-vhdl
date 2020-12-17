<h2 align="center">Traffic Lights</h2>

## Traffic Lights

The main point of this project is to recreate a traffic light using the BASYS 3 and VHDL. For this, we will use a FSM - Finite State Machine - with the following diagram:

[image]

The program will control the 3 discs for vehicles: green, amber and red, as well as the 2 indicators for pedestrians: green and red. In addition, it will have a numerical indicator that will inform the time left to pedestrians to cross the street. It will have a pedestrian crossing request button, which when activated will start a timed sequence that can be implemented with FSM, as shwon in the image below.


## Table of contents

- [Document of the project](#TrafficLights)
- Sources:
  - [Main Project](#pr7)
  - [Counter](#Counter)
  - [7 Segments Coder](#seg7_coder)
  - [Clock divider](#clk_divider)
  - [Binary to BCD converter](#bin2bcd)
  - [Flipflop T](#biestable-t)
  



## Copyright and license

Code and documentation copyright 2020–2030 the [Luca Di Iorio]. Docs released under [Creative Commons](https://creativecommons.org/licenses/by/3.0/).
