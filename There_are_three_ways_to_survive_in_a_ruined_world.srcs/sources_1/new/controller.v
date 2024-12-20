module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemWrite,
	MemtoReg,
	PCSrc,
	MulOp,
	SpecialCode,
	Shift,
	RegShift,
	PreIndex,
	WriteBack,
	PostIndex,
	SaturatedOp,
	Carry
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [4:0] ALUFlags;
	output wire [1:0] RegSrc;
	output wire RegWrite;
	output wire [1:0] ImmSrc;
	output wire ALUSrc;
	output wire [3:0] ALUControl;
	output wire MemWrite;
	output wire MemtoReg;
	output wire PCSrc;
	output wire MulOp;
	input wire [3:0] SpecialCode;
	output wire Shift;
	output wire RegShift;
	output wire PreIndex;
	output wire WriteBack;
	output wire PostIndex;
	output wire SaturatedOp;
	output wire Carry;
	wire NoWrite;
	wire [1:0] FlagW;
	wire PCS;
	wire RegW;
	wire MemW;
	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.MulOp(MulOp),
		.SpecialCode(SpecialCode),
		.Shift(Shift),
		.RegShift(RegShift),
		.NoWrite(NoWrite),
		.PreIndex(PreIndex),
		.WriteBack(WriteBack),
		.PostIndex(PostIndex),
		.SaturatedOp(SaturatedOp)
	);
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(Instr[31:28]),
		.ALUFlags(ALUFlags),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.PCSrc(PCSrc),
		.RegWrite(RegWrite),
		.MemWrite(MemWrite),
		.NoWrite(NoWrite),
		.Carry(Carry)
	);
endmodule