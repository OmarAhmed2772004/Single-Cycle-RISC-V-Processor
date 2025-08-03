module Program_Counter
(
    input wire clk,
    input wire areset, 
    input wire load, 
    input wire PCSrc, 
    input wire [31:0] ImmExt, 
    output reg [31:0] PC 
    
);

wire [31:0] pc_next_inst; 
wire [31:0] pc_branch;
wire [31:0] pc; 
assign pc_next_inst = PC + 4; 
assign pc_branch = PC + ImmExt; 
assign pc = (PCSrc) ? pc_branch : pc_next_inst; 

  
    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            PC <= 32'b0; 
        end else if (load) begin
            PC <= pc; 
        end
    end

endmodule