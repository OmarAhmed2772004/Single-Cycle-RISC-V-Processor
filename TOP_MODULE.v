module TOP_MODULE
(
    input clk,
    input areset 
);


wire [31:0] PC, SrcA, SrcB, ALUResult, ImmExt, Inst, WriteData, ReadData, Result;
wire [2:0] AluControl;
wire [1:0] ImmSrc;
wire zeroFlag, signFlag, PCSrc, ALUSrc, RegWrite, ResultSrc, MemWrite, load;
 
Program_Counter PC_TOP
(
    .clk(clk),
    .areset(areset),
    .load(1'b1),
    .PCSrc(PCSrc),
    .ImmExt(ImmExt),
    .PC(PC)
);


Instruction_Memory Instruction_Memory_TOP
(
    .A(PC),
    .RD(Inst)
);


Control_Unit Control_Unit_TOP
(
    .opcode(Inst[6:0]),
    .func7(Inst[30]),
    .func3(Inst[14:12]),
    .Zero_Flag(zeroFlag),
    .Sign_Flag(signFlag),
    .ALUControl(AluControl),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc)
);


 Register_File  Register_File_TOP
 ( 
    .clk(clk),
    .rst_n(areset),
    .WE3(RegWrite),
    .A1(Inst[19:15]),
    .A2(Inst[24:20]),
    .A3(Inst[11:7]),
    .WD3(Result),
    .RD1(SrcA),
    .RD2(WriteData)

 );




ALU ALU_TOP
(
 .AluControl(AluControl),
 .A(SrcA),
 .B(SrcB),
 .ZeroFlag(zeroFlag),
 .SignFlag(signFlag),
 .ALUResult(ALUResult)

);


Data_Memory Data_Memory_TOP
(
    .clk(clk),
    .WE(MemWrite),
    .WD(WriteData),
    .A(ALUResult),
    .RD(ReadData)

);

 
Sign_Extender Sign_Extender_TOP
(
    .ImmSrc(ImmSrc),
    .Inst(Inst),
    .ImmExt(ImmExt)
);

assign SrcB = ALUSrc ?  ImmExt : WriteData ;
assign Result = ResultSrc ? ReadData : ALUResult ;

endmodule