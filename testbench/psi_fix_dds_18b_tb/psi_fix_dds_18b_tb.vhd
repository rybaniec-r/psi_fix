------------------------------------------------------------------------------
--  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Libraries
------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
library std;
	use std.textio.all;

library work;
	use work.psi_tb_txt_util.all;
	use work.psi_fix_pkg.all;
	use work.psi_tb_textfile_pkg.all;

entity psi_fix_dds_18b_tb is
	generic (
		FileFolder_c		: string 	:= "../testbench/psi_fix_dds_18b_tb/Data";
		IdleCycles_g		: integer	:= 0
	);
end entity psi_fix_dds_18b_tb;

architecture sim of psi_fix_dds_18b_tb is

	-------------------------------------------------------------------------
	-- File Names
	-------------------------------------------------------------------------
	constant ConfigFile		: string	:= "Config.txt";
	constant SinCosFile		: string	:= "SinCos.txt";

	-------------------------------------------------------------------------
	-- TB Defnitions
	-------------------------------------------------------------------------
	constant 	ClockFrequency_c	: real 		:= 160.0e6;
	constant	ClockPeriod_c		: time		:= (1 sec)/ClockFrequency_c;
	signal 		TbRunning			: boolean 	:= True;
	signal		TestCase			: integer	:= -1;	
	signal 		ResponseDone		: integer	:= -1;
	
	-------------------------------------------------------------------------
	-- Interface Signals
	-------------------------------------------------------------------------
	constant OutFmt_c				: PsiFixFmt_t		:= (1, 0, 17);
	constant PhaseFmt_c				: PsiFixFmt_t		:= (0, 0, 31);
	signal Clk						: std_logic			:= '0';
	signal Rst						: std_logic 		:= '1';
	signal InVld					: std_logic			:= '0';
	signal OutVld					: std_logic			:= '0';
	signal OutSin					: std_logic_vector(PsiFixSize(OutFmt_c)-1 downto 0)		:= (others => '0');
	signal OutCos					: std_logic_vector(PsiFixSize(OutFmt_c)-1 downto 0)		:= (others => '0');
	signal PhaseStep				: std_logic_vector(PsiFixSize(PhaseFmt_c)-1 downto 0)	:= (others => '0');
	signal PhaseOffs				: std_logic_vector(PsiFixSize(PhaseFmt_c)-1 downto 0)	:= (others => '0');
	signal Restart					: std_logic			:= '0';
	signal SigIn					: TextfileData_t(0 to 1);
	signal SigOut					: TextfileData_t(0 to 1);

begin

	-------------------------------------------------------------------------
	-- DUT
	-------------------------------------------------------------------------
	i_dut : entity work.psi_fix_dds_18b
		generic map (
			PhaseFmt_g	=> PhaseFmt_c
		)
		port map (
			-- Control Signals
			Clk			=> Clk,
			Rst			=> Rst,
			-- Control Signals
			Restart		=> Restart,
			PhaseStep	=> PhaseStep,
			PhaseOffs	=> PhaseOffs,
			-- Input
			InVld		=> InVld,
			-- Output
			OutVld		=> OutVld,
			OutSin		=> OutSin,
			OutCos		=> OutCos
		);
	
	-------------------------------------------------------------------------
	-- Clock
	-------------------------------------------------------------------------
	p_clk : process
	begin
		Clk <= '0';
		while TbRunning loop
			wait for 0.5*ClockPeriod_c;
			Clk <= '1';
			wait for 0.5*ClockPeriod_c;
			Clk <= '0';
		end loop;
		wait;
	end process;
	
	
	-------------------------------------------------------------------------
	-- TB Control
	-------------------------------------------------------------------------
	PhaseStep <= std_logic_vector(to_signed(SigIn(0), PhaseStep'length));
	PhaseOffs <= std_logic_vector(to_signed(SigIn(1), PhaseOffs'length));
	p_control : process
		file fCfg, fSig	: text;
		variable ln	 	: line;
		variable Spl	: integer;
	begin
		-- Reset
		Rst <= '1';
		wait for 1 us;
		wait until rising_edge(Clk);
		Rst <= '0';
		wait for 1 us;
		
		-- Apply Configuration
		ApplyTextfileContent(	Clk 		=> Clk, 
								Rdy 		=> PsiTextfile_SigOne,
								Vld 		=> PsiTextfile_SigUnused, 
								Data		=> SigIn,
								Filepath	=> FileFolder_c & "/" & ConfigFile,
								IgnoreLines	=> 1);	
		
		
		-- *** Case 0: Bittrueness ***
		print("Case 0: Bittrueness");
		TestCase <= 0;
		-- File reading only required for determining number of samples
		ApplyTextfileContent(	Clk 		=> Clk, 
								Rdy 		=> PsiTextfile_SigOne,
								Vld 		=> InVld, 
								Data		=> PsiTextfile_SigUnusedData, 
								Filepath	=> FileFolder_c & "/" & SinCosFile, 
								ClkPerSpl	=> IdleCycles_g+1);	
		wait until ResponseDone = 0;
		
		-- *** Case 1: Restart ***
		print("Case 1: Restart");
		TestCase <= 1;
		-- Restart
		wait until rising_edge(Clk);
		Restart <= '1';
		wait until rising_edge(Clk);
		Restart <= '0';
		-- Apply Inputs
		-- File reading only required for determining number of samples
		ApplyTextfileContent(	Clk 		=> Clk, 
								Rdy 		=> PsiTextfile_SigOne,
								Vld 		=> InVld, 
								Data		=> PsiTextfile_SigUnusedData, 
								Filepath	=> FileFolder_c & "/" & SinCosFile, 
								ClkPerSpl	=> IdleCycles_g+1,
								MaxLines	=> 10);		
		wait until ResponseDone = 1;		
		
		-- TB done
		wait for 1 us;
		TbRunning <= false;
		wait;
	end process;
	
	SigOut(0) <= to_integer(signed(OutSin));
	SigOut(1) <= to_integer(signed(OutCos));
	p_check : process
	begin
		-- *** Case 0: Bittrueness ***
		wait until TestCase = 0;		
		CheckTextfileContent(	Clk			=> Clk,
								Rdy			=> PsiTextfile_SigUnused,
								Vld			=> OutVld,
								Data		=> SigOut,
								Filepath	=> FileFolder_c & "/" & SinCosFile);
		
		ResponseDone <= 0;
		
		-- *** Case 1: Restart ***
		wait until TestCase = 1;
		CheckTextfileContent(	Clk			=> Clk,
								Rdy			=> PsiTextfile_SigUnused,
								Vld			=> OutVld,
								Data		=> SigOut,
								Filepath	=> FileFolder_c & "/" & SinCosFile,
								MaxLines	=> 10);
		ResponseDone <= 1;		
	
		-- TB done
		wait;
	end process;
	
	

end sim;
