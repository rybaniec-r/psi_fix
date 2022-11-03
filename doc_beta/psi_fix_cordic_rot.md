<img align="right" src="../doc/psi_logo.png">
***

# psi_fix_cordic_rot
 - VHDL source: [psi_fix_cordic_rot](../hdl/psi_fix_cordic_rot.vhd)
 - Testbench source: [psi_fix_cordic_rot_tb.vhd](../testbench/psi_fix_cordic_rot_tb/psi_fix_cordic_rot_tb.vhd)

### Description
*INSERT YOUR TEXT*

### Generics
| Name            | type          | Description                                 |
|:----------------|:--------------|:--------------------------------------------|
| in_abs_fmt_g    | psi_fix_fmt_t | must be unsigned $$ constant=(0,0,16) $$    |
| in_angle_fmt_g  | psi_fix_fmt_t | must be unsigned $$ constant=(0,0,15) $$    |
| out_fmt_g       | psi_fix_fmt_t | usually signed $$ constant=(1,2,16) $$      |
| internal_fmt_g  | psi_fix_fmt_t | must be signed $$ constant=(1,2,22) $$      |
| angle_int_fmt_g | psi_fix_fmt_t | must be (1, -2, x) $$ constant=(1,-2,23) $$ |
| iterations_g    | natural       | iterative required $$ constant=21 $$        |
| gain_comp_g     | boolean       | gain compensation $$ export=true $$         |
| round_g         | psi_fix_rnd_t | round or trunc $$ export=true $$            |
| sat_g           | psi_fix_sat_t | sat or wrap $$ export=true $$               |
| mode_g          | string        | pipelined or serial $$ export=true $$       |

### Interfaces
| Name      | In/Out   | Length          | Description                              |
|:----------|:---------|:----------------|:-----------------------------------------|
| clk_i     | i        | 1               | clk system $$ type=clk; freq=100e6 $$    |
| rst_i     | i        | 1               | rst system $$ type=rst; clk=clk $$       |
| dat_abs_i | i        | in_abs_fmt_g)   | amplitude signal input                   |
| dat_ang_i | i        | in_angle_fmt_g) | phase signal input                       |
| vld_i     | i        | 1               | valid input                              |
| rdy_i     | o        | 1               | ready output signal $$ lowactive=true $$ |
| dat_inp_o | o        | out_fmt_g)      | dat inphase out                          |
| dat_qua_o | o        | out_fmt_g)      | dat quadrature out                       |
| vld_o     | o        | 1               | valid output                             |