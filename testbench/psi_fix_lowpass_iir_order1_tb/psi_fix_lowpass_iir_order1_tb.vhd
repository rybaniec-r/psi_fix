------------------------------------------------------------------------------
--  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

------------------------------------------------------------
-- Testbench generated by TbGen.py
------------------------------------------------------------
-- see Library/Python/TbGenerator

------------------------------------------------------------
-- Libraries
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.psi_fix_pkg.all;
use work.psi_tb_textfile_pkg.all;

------------------------------------------------------------
-- Entity Declaration
------------------------------------------------------------
entity psi_fix_lowpass_iir_order1_tb is
  generic(
    FileFolder_g : string  := "../testbench/psi_fix_lowpass_iir_order1_tb/Data";
    Pipeline_g   : boolean := false
  );
end entity;

------------------------------------------------------------
-- Architecture
------------------------------------------------------------
architecture sim of psi_fix_lowpass_iir_order1_tb is
  -- *** Fixed Generics ***
  constant FSampleHz_g : real        := 100.0e6;
  constant FCutoffHz_g : real        := 1.0e6;
  constant InFmt_g     : PsiFixFmt_t := (1, 0, 15);
  constant OutFmt_g    : PsiFixFmt_t := (1, 0, 14);

  -- *** Not Assigned Generics (default values) ***
  constant IntFmt_g        : PsiFixFmt_t := (1, 0, 24);
  constant CoefFmt_g       : PsiFixFmt_t := (1, 0, 17);
  constant Round_g         : PsiFixRnd_t := PsiFixRound;
  constant Sat_g           : PsiFixSat_t := PsiFixSat;
  constant ResetPolarity_g : std_logic   := '1';

  -- *** TB Control ***
  signal TbRunning            : boolean                  := True;
  signal NextCase             : integer                  := -1;
  signal ProcessDone          : std_logic_vector(0 to 1) := (others => '0');
  constant AllProcessesDone_c : std_logic_vector(0 to 1) := (others => '1');
  constant TbProcNr_stimuli_c : integer                  := 0;
  constant TbProcNr_check_c   : integer                  := 1;

  -- *** DUT Signals ***
  signal InClk_sti  : std_logic                                           := '0';
  signal InRst_sti  : std_logic                                           := '1';
  signal InVld_sti  : std_logic                                           := '0';
  signal InDat_sti  : std_logic_vector(PsiFixSize(InFmt_g) - 1 downto 0)  := (others => '0');
  signal OutVld_obs : std_logic                                           := '0';
  signal OutDat_obs : std_logic_vector(PsiFixSize(OutFmt_g) - 1 downto 0) := (others => '0');

  constant MaxStrbRate : integer                := 3;
  signal SigIn         : TextfileData_t(0 to 0) := (others => 0);
  signal SigOut        : TextfileData_t(0 to 0) := (others => 0);

begin
  ------------------------------------------------------------
  -- DUT Instantiation
  ------------------------------------------------------------
  i_dut : entity work.psi_fix_lowpass_iir_order1
    generic map(
      Pipeline_g  => Pipeline_g,
      FSampleHz_g => FSampleHz_g,
      FCutoffHz_g => FCutoffHz_g,
      InFmt_g     => InFmt_g,
      OutFmt_g    => OutFmt_g
    )
    port map(
      clk_i => InClk_sti,
      rst_i => InRst_sti,
      vld_i => InVld_sti,
      dat_i => InDat_sti,
      vld_o => OutVld_obs,
      dat_o => OutDat_obs
    );

  ------------------------------------------------------------
  -- Testbench Control !DO NOT EDIT!
  ------------------------------------------------------------
  p_tb_control : process
  begin
    wait until InRst_sti = '0';
    wait until ProcessDone = AllProcessesDone_c;
    TbRunning <= false;
    wait;
  end process;

  ------------------------------------------------------------
  -- Clocks !DO NOT EDIT!
  ------------------------------------------------------------
  p_clock_clk_i : process
    constant Frequency_c : real := real(100e6);
  begin
    while TbRunning loop
      wait for 0.5 * (1 sec) / Frequency_c;
      InClk_sti <= not InClk_sti;
    end loop;
    wait;
  end process;

  ------------------------------------------------------------
  -- Resets
  ------------------------------------------------------------
  p_rst_rst_i : process
  begin
    wait for 1 us;
    -- Wait for two clk edges to ensure reset is active for at least one edge
    wait until rising_edge(InClk_sti);
    wait until rising_edge(InClk_sti);
    InRst_sti <= '0';
    wait;
  end process;

  ------------------------------------------------------------
  -- Processes
  ------------------------------------------------------------
  -- *** stimuli ***
  InDat_sti <= std_logic_vector(to_signed(SigIn(0), InDat_sti'length));
  p_stimuli : process
  begin
    -- start of process !DO NOT EDIT
    wait until InRst_sti = '0';

    -- Apply Stimuli	
    ApplyTextfileContent(Clk         => InClk_sti,
                         Rdy         => PsiTextfile_SigOne,
                         Vld         => InVld_sti,
                         Data        => SigIn,
                         Filepath    => FileFolder_g & "/input.txt",
                         ClkPerSpl   => MaxStrbRate,
                         IgnoreLines => 1);

    -- end of process !DO NOT EDIT!
    ProcessDone(TbProcNr_stimuli_c) <= '1';
    wait;
  end process;

  -- *** check ***
  SigOut(0) <= to_integer(signed(OutDat_obs));
  p_check : process
  begin
    -- start of process !DO NOT EDIT
    wait until InRst_sti = '0';

    -- Check
    CheckTextfileContent(Clk         => InClk_sti,
                         Rdy         => PsiTextfile_SigUnused,
                         Vld         => OutVld_obs,
                         Data        => SigOut,
                         Filepath    => FileFolder_g & "/output.txt",
                         IgnoreLines => 1);

    -- end of process !DO NOT EDIT!
    ProcessDone(TbProcNr_check_c) <= '1';
    wait;
  end process;

end;
