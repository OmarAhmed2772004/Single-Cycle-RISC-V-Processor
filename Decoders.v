module Main_Decoder (
    input  [6:0] opcode,        
    output reg [1:0] ALUOp,    
    output reg Branch,         
    output reg ResultSrc,      
    output reg MemWrite,       
    output reg ALUSrc,         
    output reg [1:0] ImmSrc,   
    output reg RegWrite        
);

    // Opcode constants
    localparam loadWord  = 7'b0000011,
               storeWord = 7'b0100011,
               Rtype     = 7'b0110011,
               Itype     = 7'b0010011,
               branch    = 7'b1100011;

    // Group 1: Set 4 signals
    always @(*) begin
        ALUOp     = 2'b00;
        Branch    = 1'b0;
        ResultSrc = 1'b0;
        MemWrite  = 1'b0;

        case (opcode)
            loadWord: begin
                ALUOp     = 2'b00;
                ResultSrc = 1;
                Branch    = 0;
                MemWrite  = 0;
            end

            storeWord: begin
                ALUOp     = 2'b00;
                Branch    = 0;
                MemWrite  = 1;
            end

            Rtype: begin
                ALUOp     = 2'b10;
                Branch    = 0;
                MemWrite  = 0;
            end

            Itype: begin
                ALUOp     = 2'b10;
                Branch    = 0;
                MemWrite  = 0;
            end

            branch: begin
                ALUOp     = 2'b01;
                Branch    = 1;
                MemWrite  = 0;
            end
        endcase
    end

    // Group 2: Set remaining 3 signals
    always @(*) begin
        ALUSrc   = 1'b0;
        ImmSrc   = 2'b00;
        RegWrite = 1'b0;

        case (opcode)
            loadWord: begin
                ALUSrc   = 1;
                ImmSrc   = 2'b00;
                RegWrite = 1;
            end

            storeWord: begin
                ALUSrc   = 1;
                ImmSrc   = 2'b01;
                RegWrite = 0;
            end

            Rtype: begin
                ALUSrc   = 0;
                RegWrite = 1;
            end

            Itype: begin
                ALUSrc   = 1;
                ImmSrc   = 2'b00;
                RegWrite = 1;
            end

            branch: begin
                ALUSrc   = 0;
                ImmSrc   = 2'b10;
                RegWrite = 0;
            end
        endcase
    end

endmodule


module ALU_Decoder (
    input wire [6:0] opcode,
    input wire func7,
    input wire [1:0] ALUOP,
    input wire [2:0] func3,
    output reg [2:0] ALUControl
);


localparam ADD  = 3'b000,
           SLL  = 3'b001,
           SUB  = 3'b010,
           XOR  = 3'b100,
           SRL  = 3'b101,
           OR   = 3'b110,
           AND  = 3'b111;

always @(*) begin
    case (ALUOP)
        2'b00: ALUControl = ADD; 
        2'b01: ALUControl = SUB; 
        2'b10: begin  
            case (func3)
                3'b000: ALUControl = (opcode[5] & func7) ? SUB : ADD;
                3'b001: ALUControl = SLL;
                3'b100: ALUControl = XOR;
                3'b101: ALUControl = SRL;
                3'b110: ALUControl = OR;
                3'b111: ALUControl = AND;
                default: ALUControl = ADD;
            endcase
        end
        default: ALUControl = ADD;
    endcase
end
endmodule

module Branch_Logic (
    input [2:0] func3,
    input Zero_Flag,
    input Sign_Flag,
    input Branch,
    output reg PCSrc
);

localparam beq = 3'b000,
           bne = 3'b001,
           blt = 3'b100;

always @(*) begin
    case (func3)
        beq : PCSrc = Branch & Zero_Flag ;
        bne : PCSrc = Branch & ~Zero_Flag;
        blt : PCSrc = Branch & Sign_Flag;
        default : PCSrc = 0;
    endcase
end
endmodule