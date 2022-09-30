<h1 align="center"> Project Report </h1>

## descriptions of all aspects of modeling and implementation:

---

1. overall hierarchical structure of modules:  
	would be uploaded to WeChat Group
2. description of different modules and implementations
	1. for pc, instruction memory, mux, sign extention, adder, shifter, register file, control. alu, data_memory: a very brief description of its function (maybe attached with codes ?) and schematic diagram is okay
		- NOTE1: for data memory and instruction memory, it'd be better emphasize that the memory is actually designed to be word-addressable, namely the module is implemented by:
		
			```verilog
			reg		[7:0]	memory	[3:0][size-1:0];	// byte-addressable
			```
			where the data memory size is 4 KB, and instruction memory size is 0.25 KB.
		- NOTE2: for register file, since we never need to extract only some bytes from it, it's designed to be only word-addressable, namely it's implemented by:
			
			```verilog
			reg		[31:0]	regMem	[31:0];				//	word-addressable
			```
	2. for forwarding unit and data harzard detection unit, it's better to clarify their logic in report (?:
		- various cases for data hazard:
			1. ALU data hazard ( handled by forwarding unit )
			2. load use data hazard ( handled by hazard detection unit )
			3. branch data hazard ( in total 4 cases to be considered, handled by hazard detection unit )
				- case 1
				
				```mips
				add $1, xx, xx
				beq $1, xx, xx
				```
				how to solve: insert 1 stall, then refer to case 2.
				
				- case 2
				
				```mips
				add $1, xx, xx
				xxx xx, xx, xx	# any unrelated instruction
				beq $1, xx, xx
				```
				how to solve: `ALUResult` forwarding from MEM stage to EX stage, through two muxes.
				
				- case 3
				
				```mips
				lw	$1, xx (xx)
				beq	$1, xx, xx
				```
				how to solve: insert 1 stall to EX stage, then refer to case 4.
				
				- case 4
		
				```mips
				lw	$1, xx (xx)
				xx xx, xx, xx
				beq	$1, xx, xx
				```
				how to solve: insert 1 stall to EX stage.
		- forwarding unit: pseudo-code
		
		```verilog
		input:	EXMEMRegWrite, ExMemDst, IdExRs, IdExRt, MemWbDst, MemWbRegWrite
		output:	ForwardA, ForwardB
		
       if      ( ExMemRegWrite && ExMemDst != 0 && ExMemDst == IdExRs ) 
       // 1 & 2 rs hazard
            ForwardA = 2'b10;
       else if ( MemWbRegWrite && MemWbDst != 0 && MemWbDst == IdExRs ) 
       // 1 & 3 rs hazard
            ForwardA = 2'b01;
       else
            ForwardA = 2'b00;
		
       if      ( ExMemRegWrite && ExMemDst != 0 && ExMemDst == IdExRt ) 
       // 1 & 2 rs hazard
            ForwardB = 2'b10;
       else if ( MemWbRegWrite && MemWbDst != 0 && MemWbDst == IdExRt ) 
       // 1 & 3 rt hazard
            ForwardB = 2'b01;
       else
            ForwardB = 2'b00;
	   ```
		
		- data hazard unit:
		
		```verilog
		input:	IFIDRt, IFIDRs, IDEXRt, IDEXMemRead, IDBranch, IDEXRegWrite,
				EXMEMRegWrite, EXMEMMemRead, EXDst, EXMEMDst, IDRt, IDRs;
		output:	IFIDWrite, IDEXFlush, forward1, forward2, 
				PCWrite;
		
		if ( 
			// load use data hazard
			( IDEXMemRead && ( EXDst == IDRs || EXDst == IDRt )  ) ||
			// branch data hazard, case 1 and case 3
			( IDEXRegWrite && IDBranch && ( EXDst == IDRs || EXDst == IDRt ) ) ||
			// branch data hazard, case 4
			( EXMEMMemRead && IDBranch && ( EXMEMDst == IDRs || EXMEMDst == IDRt ) )
		)
				{ PCWrite = 0; IFIDWrite = 0; IDEXFlusb = 1; }
		else // no hazard
				{ PCWrite = 1; IFIDWrite = 1; IDEXFlusb = 0; }
				
		// branch data hazard, case 2
		if ( EXMEMRegWrite && !EXMEMMemRead && IDBranch ) 
			if ( EXMEMDst == IDRs )		forward1 = 1;
			if ( EXMEMDst == IDRt )		forward2 = 1;
		else
			{ forward 1 = 0; forward2 = 0; }
		```

	3. how control hazard (beq, bne and j) are solved?
		- beq & bne:  
			- detected and decided in ID stage (therefore may need to flush IF)
			- control generates signals: `Branch_Beq` and `Branch_Bne` according to instruction. if the instruction is `beq`, `Branch_Beq` is set to 1 while `Branch_Bne` is 0; if `bne`, `Branch_Bne` is set to 1 and `Branch_Beq` be 0. Otherwise, they are both 0
			- a comparator in ID stage gives signal `Equal`, which is taken by control unit
			- these signals together determines whether to branch or not
			- if branch, update next pc, flush IFID pipeline register and insert a bubble to ID stage.
			- pseudo-code:
			
			```verilog
			if (
				( Branch_Beq && Equal ) ||
				( Branch_Bne && ~Equal )
			)
					{ IFID.Flush = 1; BranchTarget	= PC+4+4*Relative_Address; }
			else	
					{ IFID.Flush = 0; BranchTarget	= PC+4; }
			```
		- jump:
			- detected in ID stage (therefore may need to flush IF)
			- control generates signal `Jump`, which is set to 1 if it's a jump instruction
			- if jump, update next pc, flush IFID pipeline register and insert a bubble to ID stage.
			- pseudo-code:
			
			```verilog
			if ( Jump )
				{ IFID.Flush = 1; NextPC = JumpTarget; }
			else
				{ IFID.Flush = 0; NextPC = BranchTarget; } 
				// BranchTarget is the signal determined in beq & bne section
			```
	4. one thing that worth attention:  
		In both register file and data memory, data is only written at negative edge of clock, because that's safer ( write data that arrives earrlier than control signal would not be accidentally written into the memory )

---

## simulation results: 
---

- simulation result txt file has been uploaded to WeChat Group
- emphasize that we correctly handle all the data hazards and control hazards
- the theoretically expected results are:

	<table>
		<caption> project2-expected results </caption>
		<thead>
			<tr>
				<th scope="col"> #cycle </th>
				<th scope="col"> fetched operation in IF stage </th>
				<th scope="col"> IF	</th>
				<th scope="col"> ID </th>
				<th scope="col"> EX </th>
				<th scope="col"> MEM </th>
				<th scope="col"> WB </th>
				<th scope="col"> changes in register file </th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td> 1 </td>
				<td> 1. addi $t0, $zero, 0x20 </td>
				<td> 1 </td>
				<td> x </td>
				<td> x </td>
				<td> x </td>
				<td> x </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 2 </td>
				<td> 2. addi $t1, $zero, 0x37 </td>
				<td> 2 </td>
				<td> 1 </td>
				<td> x </td>
				<td> x </td>
				<td> x </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 3 </td>
				<td> 3. and $s0, $t0, $t1 </td>
				<td> 3 </td>
				<td> 2 </td>
				<td> 1 </td>
				<td> x </td>
				<td> x </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 4 </td>
				<td> 4. or $s0, $t0, $t1 </td>
				<td> 4 </td>
				<td> 3 </td>
				<td> 2 </td>
				<td> 1 </td>
				<td> x </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 5 </td>
				<td> 5. sw $s0, 4($zero) </td>
				<td> 5 </td>
				<td> 4 </td>
				<td> 3 </td>
				<td> 2 </td>
				<td> 1 </td>
				<td> t0 = 0x20 </td>
			</tr>
			<tr>
				<td> 6 </td>
				<td> 6. sw $t0, 8($zero) </td>
				<td> 6 </td>
				<td> 5 </td>
				<td> 4 </td>
				<td> 3 </td>
				<td> 2 </td>
				<td> t1 = 0x37 </td>
			</tr>
			<tr>
				<td> 7 </td>
				<td> 7. add $s1, $t0, $t1 </td>
				<td> 7 </td>
				<td> 6 </td>
				<td> 5 </td>
				<td> 4 </td>
				<td> 3 </td>
				<td> s0 = 0x20 </td>
			</tr>
			<tr>
				<td> 8 </td>
				<td> 8. sub $s2, $t0, $t1 </td>
				<td> 8 </td>
				<td> 7 </td>
				<td> 6 </td>
				<td> 5 </td>
				<td> 4 </td>
				<td> s0 = 0x37, DataMemory[4] = 0x37 </td>
			</tr>
			<tr>
				<td> 9 </td>
				<td> 9. beq $s1, $s2, error0 (does not branch) </td>
				<td> 9 </td>
				<td> 8 </td>
				<td> 7 </td>
				<td> 6 </td>
				<td> 5 </td>
				<td> DataMemory[8] = 0x20 </td>
			</tr>
			<tr>
				<td> 10 </td>
				<td> 10. lw $s1, 4($zero) </td>
				<td> 10 </td>
				<td> 9 </td>
				<td> 8 </td>
				<td> 7 </td>
				<td> 6 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 11 </td>
				<td>  </td>
				<td> 10 </td>
				<td> 9 </td>
				<td> nop </td>
				<td> 8 </td>
				<td> 7 </td>
				<td> s1 = 0x57 </td>
			</tr>
			<tr>
				<td> 12 </td>
				<td> 11. andi $s2, $s1, 0x48 </td>
				<td> 11 </td>
				<td> 10 </td>
				<td> 9 </td>
				<td> nop </td>
				<td> 8 </td>
				<td> s2 = 0xffffffe9 </td>
			</tr>
			<tr>
				<td> 13 </td>
				<td> 12. beq $s1, $s2, error1 </td>
				<td> 12 </td>
				<td> 11 </td>
				<td> 10 </td>
				<td> 9 </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 14 </td>
				<td>  </td>
				<td> 12 </td>
				<td> 11 </td>
				<td> nop </td>
				<td> 10 </td>
				<td> 9 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 15 </td>
				<td> 13. lw $s3, 8($zero) </td>
				<td> 13 </td>
				<td> 12 </td>
				<td> 11 </td>
				<td> nop </td>
				<td> 10 </td>
				<td> s1 = 0x37 </td>
			</tr>
			<tr>
				<td> 16 </td>
				<td>  </td>
				<td> 13 </td>
				<td> 12 </td>
				<td> nop </td>
				<td> 11 </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 17 </td>
				<td> 14. beq $s0, $s3, error2 (does not branch) </td>
				<td> 14 </td>
				<td> 13 </td>
				<td> 12 </td>
				<td> nop </td>
				<td> 11 </td>
				<td> s2 = 0x0 </td>
			</tr>
			<tr>
				<td> 18 </td>
				<td> 15. slt $s4, $s2, $s1 (Last) </td>
				<td> 15 </td>
				<td> 14 </td>
				<td> 13 </td>
				<td> 12 </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 19 </td>
				<td>  </td>
				<td> 15 </td>
				<td> 14 </td>
				<td> nop </td>
				<td> 13 </td>
				<td> 12 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 20 </td>
				<td>  </td>
				<td> 15 </td>
				<td> 14 </td>
				<td> nop </td>
				<td> nop </td>
				<td> 13 </td>
				<td> s3 = 0x20 </td>
			</tr>
			<tr>
				<td> 21 </td>
				<td> 16. beq $s4, $0, EXIT (does not branch) </td>
				<td> 16 </td>
				<td> 15 </td>
				<td> 14 </td>
				<td> nop </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 22 </td>
				<td> 17. add $s2, $s1, $0 </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> 15 </td>
				<td> 14 </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 23 </td>
				<td>  </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> nop </td>
				<td> 15 </td>
				<td> 14 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 24 </td>
				<td> 18. j Last </td>
				<td> 18 </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> nop </td>
				<td> 15 </td>
				<td> s4 = 0x1 </td>
			</tr>
			<tr>
				<td> 25 </td>
				<td> 19. addi $t0, $0, 0(error0) </td>
				<td> 19 </td>
				<td> 18 </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 26 </td>
				<td> 15. slt $s4, $s2, $s1 (Last) </td>
				<td> 15 </td>
				<td> flushed (nop) </td>
				<td> 18 </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 27 </td>
				<td> 16. beq $s4, $0, EXIT (branch) </td>
				<td> 16 </td>
				<td> 15 </td>
				<td> flushed (nop) </td>
				<td> 18 </td>
				<td> 17 </td>
				<td> s2 = 0x37 </td>
			</tr>
			<tr>
				<td> 28 </td>
				<td> 17. add $s2, $s1, $0 </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> 15 </td>
				<td> flushed (nop) </td>
				<td> 18 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 29 </td>
				<td>  </td>
				<td> 17 </td>
				<td> 16 </td>
				<td> nop </td>
				<td> 15 </td>
				<td> flushed (nop) </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 30 </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> flushed (nop) </td>
				<td> 16 </td>
				<td> nop </td>
				<td> 15 </td>
				<td> s4 = 0x0 </td>
			</tr>
			<tr>
				<td> 31 </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> flushed (nop) </td>
				<td> 16 </td>
				<td> nop </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 32 </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> flushed (nop) </td>
				<td> 16 </td>
				<td> nothing </td>
			</tr>
			<tr>
				<td> 33 </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> EXIT (nop) </td>
				<td> flushed (nop) </td>
				<td> nothing </td>
			</tr>
		</tbody>
	</table>