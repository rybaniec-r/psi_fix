<img align="right" src="../doc/psi_logo.png">
***

# psi_fix_mod_cplx2real
 - VHDL source: [psi_fix_mod_cplx2real](../hdl/psi_fix_mod_cplx2real.vhd)
 - Testbench source: [psi_fix_mod_cplx2real_tb.vhd](../testbench/psi_fix_mod_cplx2real_tb/psi_fix_mod_cplx2real_tb.vhd)

### Description
*INSERT YOUR TEXT*

### Generics
| Name              | type          | Description                                         |
|:------------------|:--------------|:----------------------------------------------------|
| generic(rst_pol_g | std_logic     | reset polarity $$ constant = '1' $$                 |
| pl_stages_g       | integer       | select the pipelines stages required                |
| inp_fmt_g         | psi_fix_fmt_t | input format fp $$ constant=(1,1,15) $$             |
| coef_fmt_g        | psi_fix_fmt_t | coef format $$ constant=(1,1,15) $$                 |
| int_fmt_g         | psi_fix_fmt_t | internal format computation $$ constant=(1,1,15) $$ |
| out_fmt_g         | psi_fix_fmt_t | output format fp $$ constant=(1,1,15) $$            |
| ratio_g           | natural       | ratio for deciamtion $$ constant=5 $$               |

### Interfaces
| Name      | In/Out   | Length       | Description                     |
|:----------|:---------|:-------------|:--------------------------------|
| clk_i     | i        | 1            | $$ type=clk; freq=100e6 $$      |
| rst_i     | i        | 1            | $$ type=rst; clk=clk_i $$       |
| dat_inp_i | i        | inp_fmt_g)-1 | in-phase data                   |
| dat_qua_i | i        | inp_fmt_g)-1 | quadrature data                 |
| vld_i     | i        | 1            | valid input frequency sampling  |
| dat_o     | o        | out_fmt_g)-1 | data output if/rf               |
| vld_o     | o        | 1            | valid output frequency sampling |