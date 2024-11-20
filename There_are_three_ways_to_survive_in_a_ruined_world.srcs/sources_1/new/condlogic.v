module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	RegW,
	MemW,
	PCSrc,
	RegWrite,
	MemWrite,
	NoWrite,
	Carry
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [4:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire RegW;
	input wire MemW;
	output wire PCSrc;
	output wire RegWrite;
	output wire MemWrite;
	output wire Carry;
	input wire NoWrite;
	wire [1:0] FlagWrite;
	wire [4:0] Flags;
	wire CondEx;
	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[4:3]),
		.q(Flags[4:3])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[2:1]),
		.q(Flags[2:1])
	);
	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);
	assign Flags[0] = ALUFlags[0];
	assign Carry = Flags[2];
	assign FlagWrite = FlagW & {2 {CondEx}};
	assign RegWrite = RegW & CondEx & ~NoWrite;
    assign MemWrite = MemW & CondEx;
	assign PCSrc = PCS & CondEx;
endmodule