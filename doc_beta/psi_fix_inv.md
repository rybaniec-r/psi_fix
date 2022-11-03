<img align="right" src="../doc/psi_logo.png">
***

# psi_fix_inv
 - VHDL source: [psi_fix_inv](../hdl/psi_fix_inv.vhd)
 - Testbench source: [psi_fix_inv_tb.vhd](../testbench/psi_fix_inv_tb/psi_fix_inv_tb.vhd)

### Description
*INSERT YOUR TEXT*

### Generics
| Name           | type          | Description                                                   |
|:---------------|:--------------|:--------------------------------------------------------------|
| in_fmt_g       | psi_fix_fmt_t | must be unsigned, wuare root not defined for negative numbers |
| out_fmt_g      | psi_fix_fmt_t | output fomrat fp                                              |
| round_g        | psi_fix_rnd_t | round or trunc                                                |
| sat_g          | psi_fix_sat_t | sat or wrap                                                   |
| ram_behavior_g | string        | rbw = read before write, wbr = write before read              |

### Interfaces
| Name   | In/Out   | Length     | Description                             |
|:-------|:---------|:-----------|:----------------------------------------|
| clk_i  | i        | 1          | system clock $$ type=clk; freq=127e6 $$ |
| rst_i  | i        | 1          | system reset $$ type=rst; clk=clk $$    |
| dat_i  | i        | in_fmt_g)  | data input                              |
| vld_i  | i        | 1          | valid signal input frequency sampling   |
| dat_o  | o        | out_fmt_g) | data output                             |
| vld_o  | o        | 1          | valid output frequency samlping         |