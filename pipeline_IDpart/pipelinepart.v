// wire possibly be needed


wire [31:0] instruction32ID,
            Readdata1ID,
            Readdata2ID,
            CompareData1ID,
            CompareData2ID,
            JumpAddrID,
            BeqAddrID,
            pcPlus4ID,
            signExtendedID;

//wire [15:0] tobenamed1; used as a number to be extended
//wire [25:0] tobenamed2; used as a jump immnumber
wire [5:0]  OpcodeID;// the first 6 bits of instruction32ID
wire [4:0]  RsID, RtID, RdID;

wire Branchjudge, //judge whether there is a branch
     BrancBeqID,BranchBneID,
     RegWriteID, MemtoRegID, ALUSrcID, MemWriteID, RegDstID, MemReadID, JumpID;//this line + OpcodeID is the input of control
wire [1:0] ALUopID;



// connect regfile wire;

// extend
// Signextend sextend(instruction32[15:0], signExtended); 
// we can assign the tobenamed1 as instruction32ID[15:0] and replace the instruction32[15:0] with tobenamed1

// 2 3to1(2to1mux) mux

// ID / EX