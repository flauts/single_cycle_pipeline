module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	MulOp,
	SpecialCode,
	Shift,
	RegShift,
	NoWrite,
	PreIndex,
	WriteBack,
	PostIndex,
	SaturatedOp
	);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire [3:0] SpecialCode;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl;
	output wire MulOp;
	output wire Shift;
	output wire RegShift;
	output reg NoWrite;
	output wire PreIndex;
	output wire WriteBack;
	output wire PostIndex;
	reg [9:0] controls;
	wire Branch;
	wire ALUOp;
	output wire SaturatedOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001;
				else
					controls = 10'b0000001001;
			2'b01:
				if (Funct[0]) begin //ldr
				    if(~Funct[5]) //inmediate
					controls = 10'b0001111000;
					else controls = 10'b0001011000; //no inmediate
				end //mentoreg 1 in both for imm mux
				else 
				begin
				if(~Funct[5]) //str
					controls = 10'b1001110100;
				else controls = 10'b1001010100;
                end         
			2'b10: controls = 10'b0110100010;
			default: controls = 10'bxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	assign MulOp = ((Funct[5:4] == 2'b00) & (SpecialCode == 4'b1001) & Op == 2'b00);
	assign SaturatedOp = (SpecialCode == 4'b0101 & Op == 2'b00 & Funct[4] &~Funct[3] & ~Funct[0]);
	assign Shift = (Funct[4:1] == 4'b1101 & Op == 2'b00);
	assign RegShift = (SpecialCode[3] == 1'b0 & SpecialCode[0] == 1'b1 & Funct[5] == 1'b0);
	assign PreIndex = (Op == 2'b01 & Funct[4]);
	assign PostIndex = (Op == 2'b01 & ~Funct[4]);
	assign WriteBack = (Op == 2'b01 & Funct[1] & Funct[4]) | (Op == 2'b01 & ~Funct[4]);
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 3'b000;//add
				4'b0010: ALUControl = 3'b001;//sub
				4'b0000: ALUControl = 3'b010;//and
				4'b1100: ALUControl = 3'b011;//orr
                4'b1010: ALUControl = 3'b001; //cmp subs no write
				4'b1011: ALUControl = 3'b000; //cmn add no write
				4'b1000: ALUControl = 3'b010; //TST and no write
				4'b1001: ALUControl = 3'b110; //TEQ eor no write
				4'b1111: ALUControl = 3'b111; //mvn
				default: ALUControl = 3'bxxx;
			endcase
			if(MulOp)
			begin
			case (Funct[3:1])
			 3'b000: ALUControl = 3'b100; //MUL
			 3'b001: ALUControl = 3'b101; //MAL
			 default: ALUControl = 3'bxxx; //xd?
			 endcase
			end
			if(SaturatedOp) begin
			case (Funct[2:1])
			2'b00: ALUControl = 4'b1000;
			2'b01: ALUControl = 4'b1001;
			default: ALUControl = 4'bxxxx;
			endcase
			end
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 2'b00) | (ALUControl == 2'b01));
            NoWrite = (Funct[4:3] == 2'b10 & ~SaturatedOp);
		end
		else begin
		    ALUControl = (Op == 2'b01 & ~Funct[3]) ? 3'b001:3'b000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule