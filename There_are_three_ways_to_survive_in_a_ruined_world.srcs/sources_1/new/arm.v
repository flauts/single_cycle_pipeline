module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [4:0] ALUFlags;
	wire PostIndex;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;
	wire MulOp;
	wire Shift;
	wire RegShift;
	wire PreIndex;
	wire WriteBack;
	wire SaturatedOp;
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.MulOp(MulOp),
		.SpecialCode(Instr[7:4]),
		.Shift(Shift),
		.RegShift(RegShift),
		.PreIndex(PreIndex),
		.WriteBack(WriteBack),
		.PostIndex(PostIndex),
		.SaturatedOp(SaturatedOp),
		.Carry(Carry)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.Instr(Instr),
		.ALUResult(ALUResult),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.MulOp(MulOp),
		.shamnt5(Instr[11:7]),
		.Carry(Carry),
		.Shift(Shift),
		.ShiftControl(Instr[6:5]),
		.RegShift(RegShift),
		.rot_imm(Instr[11:8]),
		.PreIndex(PreIndex),
		.WriteBack(WriteBack),
		.PostIndex(PostIndex),
		.SaturatedOp(SaturatedOp)
	);
endmodule