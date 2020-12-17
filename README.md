<h2 align="center">Traffic Lights</h2>

## Traffic Lights

The main point of this project is to recreate a traffic light using the BASYS 3 and VHDL. For this, we will use a FSM - Finite State Machine - with the following diagram:

[image]

The program will control the 3 discs for vehicles: green, amber and red, as well as the 2 indicators for pedestrians: green and red. In addition, it will have a numerical indicator that will inform the time left to pedestrians to cross the street. It will have a pedestrian crossing request button, which when activated will start a timed sequence that can be implemented with FSM, as shwon in the image below.


## Table of contents

- [Main Project](#Main Project)
  - [FSM](#FSM)
  - [Counter](#Counter)
  - [Display visualization](#Display visualization)
  - [Blinking](#Blinking)
  - [Flipflop T](#biestable-t)
- [Counter Component](#Counter Component)


## Main Project

This entity will be the mother project. In other words, it is the central project. We will use both our own code and other components, to reach the specifications of the practice mentioned above.

````VHDL
entity pr7 is 
  Port (polsador : in std logic ;
        clk, reset : in STD LOGIC;
        cat : out STD LOGIC VECTOR (7 downto 0); 
        an : out STD LOGIC VECTOR (3 downto 0); 
        LED : out STD LOGIC VECTOR (15 downto 0)
       ); 
end pr7;
````

You can see the full code in the file: pr7.vhdl

### FSM

The code for the state machine consists of three processes: a state decoder, an output decoder, and an output register. 

You can see the full code in the file: pr7.vhdl


### Counter

We will use two counting processes, which are based on a single component called counter. The first counter is used to maintain the flow of the state machine. The second, to display on the screen the time when the pedestrian traffic light is green, allowing the passage. To declare the components we use this syntax:

````VHDL
u2: counter
  generic map(num => ”11001”) 
  port map (rst en => rst en,
            enable => enable,
            clk div => clk div 1s, 
            reset => reset,
            c => c);
u7: counter
  generic map(num => ”01111”) 
  port map (rst en => rst en,
            enable => enable b, 
            clk div => clk div 1s, 
            reset => reset,
            c =>cb);
````

The components use a split clock signal to generate a pulse every second. The clock splitting process, as we have seen in other repos and we will not delve further into this one, is stated as follows:

````VHDL
u1: clk divider
  generic map (eoc => 100000000) 
  port map (clk => clk,
          reset => reset,
          clk div => clk div 1s);
````

You can see the full code in the file: pr7.vhdl

### Display visualization

To visualize the time on the displays, we need the component that we have already seen in other repos, called 7seg_coder. In addition, we use another clock divider to get the right frequency.

````VHDL
u3: clk divider
  generic map (eoc => 100000) 
  port map (clk => clk, reset => reset, clk div => clk div);
  
u4: seg7 coder
  port map (char0 => char0, char1 => char1, char2 => ”1111”, char3 => ”1111”, clk => clk,
            reset => reset, clk div => clk div, cat => cat, an => an);
````

There is a state that requires the intermittency of the value displayed by the displays. To achieve this, we use the following assignment:

````VHDL
char0 <= disp0 when state reg=walk else
         disp0 when state reg=end walk and blink=’0’ 
         else ”1111”;
         
char1 <= disp1 when state reg=walk else
         disp1 when state reg=end walk and blink=’0’ 
         else ”1111”;
````

### Blinking









## Copyright and license

Code and documentation copyright 2020–2030 the [Luca Di Iorio]. Docs released under [Creative Commons](https://creativecommons.org/licenses/by/3.0/).
