module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire [4:0] ALUFlags
);

    wire neg, zero, carry, overflow, q;
    wire [31:0] condinvb;
    wire [32:0] sum;
    wire sat_pos;
    wire sat_neg;
    assign condinvb = ALUControl[0] ? ~b : b;  // Invertir B si es resta
    assign sum = a + condinvb + ALUControl[0]; // Suma/resta según ALUControl
        
    assign sat_pos = ~a[31] & ~b[31] & sum[31];  // Desbordamiento positivo
    assign sat_neg = a[31] & b[31] & ~sum[31];   // Desbordamiento negativo

    always @(*) begin
        casex (ALUControl[3:0])
            4'b000?: Result = sum; // add y sub
            4'b0010: Result = a & b; // and
            4'b0011: Result = a | b; // orr
            4'b0100: Result = a * b; // mul
            4'b0101: Result = a * b + c; // mla
            4'b0110: Result = a ^ b; // eor
            4'b0111: Result = ~b; // mvn ~ not
            4'b100?: begin // QADD (Suma saturada con signo)
                if (sat_pos)
                    Result = 32'h7FFFFFFF; // Máximo positivo
                else if (sat_neg)
                    Result = 32'h80000000; // Mínimo negativo
                else Result = sum;
                end
        endcase
    end

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] == 1'b0) & sum[32]; // Sólo válido para operaciones sin signo
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign q = (sat_pos | sat_neg); // Flag Q para saturación
    assign ALUFlags = {neg, zero, carry, overflow,q};

endmodule
